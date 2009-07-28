use MooseX::Declare;

class CatalystX::Declare extends MooseX::Declare {

    use aliased 'CatalystX::Declare::Keyword::Controller', 'ControllerKeyword';

    around keywords {
        $self->$orig,
        ControllerKeyword->new(identifier => 'controller'),
    }
}

