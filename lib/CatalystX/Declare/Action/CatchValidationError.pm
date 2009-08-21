use MooseX::Declare;

role CatalystX::Declare::Action::CatchValidationError {

    use aliased 'Moose::Meta::TypeConstraint';

    has method_type_constraint => (
        is          => 'rw',
        isa         => TypeConstraint,
        handles     => {
            _check_action_arguments => 'check',
        },
    );

    has controller_instance => (
        is          => 'rw',
        isa         => 'Catalyst::Controller',
        weak_ref    => 1,
    );

    around match (Object $ctx) {

        return 
            unless $self->$orig($ctx);
        return 1 
            unless $self->method_type_constraint;

        my @args    = ($self->controller_instance, $ctx, @{ $ctx->req->args });
        my $tc      = $self->method_type_constraint;
        my $ret     = $self->_check_action_arguments(\@args);

        return $ret;
    }
}
