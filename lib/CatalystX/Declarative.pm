use MooseX::Declare;

class CatalystX::Declarative extends MooseX::Declare {

    use aliased 'CatalystX::Declarative::Keyword::Controller',  'ControllerKeyword';
    use aliased 'CatalystX::Declarative::Keyword::Application', 'ApplicationKeyword';

    around keywords {
        $self->$orig,
        ApplicationKeyword->new(identifier => 'application'),
        ControllerKeyword->new(identifier => 'controller'),
    }
}

