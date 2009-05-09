use MooseX::Declare;
use Class::MOP;

role CatalystX::Declarative::Controller::DetermineActionClass
    with CatalystX::Declarative::Controller::QualifyClassNames {

    around create_action (%args) {

        my ($action_class) = @{ $args{attributes}{CatalystX_Declarative_ActionClass} || [] };
        $action_class ||= 'Catalyst::Action';

        my $fq_class = $self->_qualify_class_name('Action', $action_class);
        Class::MOP::load_class($fq_class);

        $args{attributes}{ActionClass} ||= [$fq_class];

        return $self->$orig(%args);
    }
}

