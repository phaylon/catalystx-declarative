use MooseX::Declare;

class CatalystX::Declarative::Keyword::Application
    extends MooseX::Declare::Syntax::Keyword::Class {


    our (@PluginStore);

    sub dbg { warn "THROUGH:\n" . join("\n", @_) . "\n"; @_ }

    
    override auto_make_immutable { 0 }

    override add_with_option_customizations (Object $ctx, Str $package, ArrayRef $plugins, HashRef $options) {

        $ctx->add_cleanup_code_parts(
            sprintf(
                '%s->setup(qw( %s ))',
                $package,
                join(' ', @$plugins),
            ),
            '1;',
        );
    }

    before add_namespace_customizations (Object $ctx, Str $package) {

        $ctx->add_preamble_code_parts(
            'use CLASS',
            'use parent q{Catalyst}',
        );
    }
}

