use MooseX::Declare;

class CatalystX::Declare::Keyword::Role
    extends MooseX::Declare::Syntax::Keyword::Role {


    use aliased 'MooseX::MethodAttributes::Role::Meta::Role';
    use aliased 'CatalystX::Declare::Keyword::Action', 'ActionKeyword';


    before add_namespace_customizations (Object $ctx, Str $package) {

        $ctx->add_preamble_code_parts(
            'use CLASS',
            'use Moose::Role -traits => q(MethodAttributes)',
        );
    }

    around default_inner () {

        my @modifiers = qw( );

        return [ 
            ( grep { my $id = $_->identifier; not grep { $id eq $_ } @modifiers } @{ $self->$orig() || [] } ),
            ActionKeyword->new(identifier => 'action'),
            ActionKeyword->new(identifier => 'under'),
            ActionKeyword->new(identifier => 'final'),
        ];
    }
}

__END__

=head1 NAME

CatalystX::Declare::Keyword::Role - Declare Catalyst Controller Roles

=head1 SYNOPSIS

    use CatalystX::Declare;

    component_role MyApp::Web::ControllerRole::Foo {

        method provided_method { ... }

        action foo, under base, is final { ... }

        around bar_action (Object $ctx) { ... }
    }

=head1 DESCRIPTION

This handler provides the C<component_role> keyword. It is an extension of the
L<MooseX::Declare::Syntax::Keyword::Role> handler. Like with declared 
controllers, the C<method> keyword and the modifiers are provided. For details
on the syntax for action declarations have a look at
L<CatalystX::Declare::Keyword::Action>, which also documents the effects of
method modifiers on actions.

=head1 SUPERCLASSES

=over

=item L<MooseX::Declare::Syntax::Keyword::Role>

=back

=head1 METHODS

=head2 add_namespace_customizations

    Object->add_namespace_customizations (Object $ctx, Str $package)

This hook is called by L<MooseX::Declare> and will set the package up as a role
and apply L<MooseX::MethodAttributes>.

=head2 default_inner

    ArrayRef[Object] Object->default_inner ()

Same as L<CatalystX::Declare::Keyword::Class/default_inner>.

=head1 SEE ALSO

=over

=item L<CatalystX::Declare>

=item L<MooseX::Declare/role>

=item L<CatalystX::Declare::Keyword::Action>

=item L<CatalystX::Declare::Keyword::Controller>

=back

=head1 AUTHOR

See L<CatalystX::Declare/AUTHOR> for author information.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under 
the same terms as perl itself.

=cut
