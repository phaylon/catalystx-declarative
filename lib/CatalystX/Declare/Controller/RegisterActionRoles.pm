use MooseX::Declare;
use Class::MOP;

role CatalystX::Declare::Controller::RegisterActionRoles 
    with CatalystX::Declare::Controller::QualifyClassNames {

    around create_action (%args) {

        my @action_roles = @{ delete($args{attributes}{CatalystX_Declarative_ActionRoles}) || [] };

        my $action = $self->$orig(%args);

        for my $role (@action_roles) {
            my $fq_role = $self->_qualify_class_name(ActionRole => $role);

            Class::MOP::load_class($role);
            $role->meta->apply($action);
        }

        return $action;
    }
}

