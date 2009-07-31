use MooseX::Declare;

class CatalystX::Declare::Keyword::Application
    extends MooseX::Declare::Syntax::Keyword::Class {

    
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

=head1 NAME

CatalystX::Declare::Keyword::Application - Declare Catalyst Application Classes

=head1 SYNOPSIS

    use CatalystX::Declare;

    application MyApp::Web
           with Static::Simple
           with ConfigLoader {

        $CLASS->config(name => 'My App');

        method debug_timestamp {
            $self->log->debug('Timestamp: ' . time)
                if $self->debug;
        }
    }

=head1 DESCRIPTION

This module provides a keyword handler for the C<application> keyword. It is an
extension of L<MooseX::Declare/class>. The role application mechanism behind 
the C<with> specification is hijacked and the arguments are passed to 
Catalyst's C<setup> method. This hijacking is proably going away someday since
in the future plugins will be actual roles.

You don't have to call the C<setup> method yourself, this will be done by the
handler after the body has been run.

=head1 SUPERCLASSES

=over

=item L<MooseX::Declare::Syntax::Keyword::Class>

=back

=head1 METHODS

=head2 auto_make_immutable

    Bool Object->auto_make_immutable ()

A modified method that returns C<0> to signal to L<MooseX::Declare> that it 
should not make this class immutable. Currently, making application classes
immutable isn't supported yet, therefore C<is mutable> is currently a no-op.
This will likely change as soon as application classes can be made immutable,

=head1 SEE ALSO

=over

=item L<CatalystX::Declare>

=item L<MooseX::Declare/class>

=item L<MooseX::Declare::Syntax::Keyword::Class>

=back

=head1 AUTHOR

See L<CatalystX::Declare/AUTHOR> for author information.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under 
the same terms as perl itself.

=cut
