use MooseX::Declare;

role CatalystX::Declare::Controller::ActionPreparation {

    use aliased 'CatalystX::Declare::Action::CatchValidationError';
    use aliased 'CatalystX::Declare::Dispatching::ChainTypeSensitivity';


    method _apply_action_roles (Object $action, @roles) {

        for my $role (CatchValidationError, @roles) {
            my $fq_role = $self->_qualify_class_name(ActionRole => $role);

            Class::MOP::load_class($fq_role);
            $fq_role->meta->apply($action);
        }
    }

    method _find_method_type_constraint (Str $name) {

        $self->meta->find_method_type_constraint($name)
            || do {
                my $method = $self->meta->find_method_by_name($name);
                    ( $_ = $method->can('type_constraint') )
                    ? $method->$_
                    : undef
            };
    }

    method _ensure_applied_dispatchtype_roles {

        my $type = $self->_app->dispatcher->dispatch_type('Chained');

        return
            if $type->DOES(ChainTypeSensitivity);

        # FIXME this is ugly as hell
        my $immutable = $type->meta->is_immutable;
        $type->meta->make_mutable
            if $immutable;
        ChainTypeSensitivity->meta->apply($type->meta);
        $type->meta->make_immutable
            if $immutable;
    }

    after register_actions {

        $self->_ensure_applied_dispatchtype_roles;
    }

    around create_action (%args) {

        my @action_roles = @{ delete($args{attributes}{CatalystX_Declarative_ActionRoles}) || [] };

        my $action = $self->$orig(%args);

        return $action
            if $args{attributes}{Private};

        $self->_apply_action_roles($action, @action_roles);

        return $action 
            unless $action->DOES(CatchValidationError);

        my $tc = $self->_find_method_type_constraint($action->name);

        return $action
            unless $tc;

        $action->method_type_constraint($tc);
        $action->controller_instance($self);

        return $action;
    }
}
