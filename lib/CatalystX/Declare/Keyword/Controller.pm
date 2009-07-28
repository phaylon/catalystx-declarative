use MooseX::Declare;

class CatalystX::Declare::Keyword::Controller 
    extends MooseX::Declare::Syntax::Keyword::Class
    with    CatalystX::Declare::DefaultSuperclassing {


    use MooseX::MethodAttributes ();
    use aliased 'CatalystX::Declare::Keyword::Action', 'ActionKeyword';
    use aliased 'CatalystX::Declare::Controller::RegisterActionRoles';
    use aliased 'CatalystX::Declare::Controller::DetermineActionClass';


    before add_namespace_customizations (Object $ctx, Str $package) {

        MooseX::MethodAttributes->init_meta(for_class => $package);
        $ctx->add_preamble_code_parts(
            'use CLASS',
            sprintf('with qw( %s )', join ' ',
                RegisterActionRoles,
                DetermineActionClass,
            ),
        );
    }

    method default_superclasses { 'Catalyst::Controller' }

    around default_inner () {

        return [ 
            @{ $self->$orig() || [] },
            ActionKeyword->new(identifier => 'action'),
            ActionKeyword->new(identifier => 'under'),
            ActionKeyword->new(identifier => 'final'),
        ];
    }
}

