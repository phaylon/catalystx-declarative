use MooseX::Declare;

class CatalystX::Declarative::Keyword::Action
    with MooseX::Declare::Syntax::KeywordHandling {


    use Carp            qw( croak );
    use Perl6::Junction qw( any );
    use Data::Dump      qw( pp );

    use aliased 'MooseX::Method::Signatures::Meta::Method';
    use aliased 'MooseX::MethodAttributes::Role::Meta::Method', 'AttributeRole';


    method parse (Object $ctx) {

        # somewhere to put the attributes
        my %attributes;
        my @populators;
        my $skipped_declarator;

        # parse declarations
        until (do { $ctx->skipspace; $ctx->peek_next_char } eq any qw( ; { } )) {
            warn "LINESTR[" . pp($ctx->get_linestr) . "]\n";

            $ctx->skipspace;
            
            # optional commas
            if ($ctx->peek_next_char eq ',') {

                my $linestr = $ctx->get_linestr;
                substr($linestr, $ctx->offset, 1) = '';
                $ctx->set_linestr($linestr);

                next;
            }

            # next thing should be an option name
            my $option = (
                $skipped_declarator 
                ? $ctx->strip_name 
                : do { 
                    $ctx->skip_declarator; 
                    $skipped_declarator++;
                    $ctx->declarator;
                })
              or croak "Expected option token, not " . substr($ctx->get_linestr, $ctx->offset);

            # we need to be able to handle the rest
            my $handler = $self->can("_handle_${option}_option")
                or croak "Unknown action option: $option";

            # call the handler
            push @populators, $self->$handler($ctx, \%attributes);
        }

        croak "Need an action specification"
            unless exists $attributes{Signature};

        my $name   = $attributes{Subname};
        my $method = Method->wrap(
            signature       => qq{($attributes{Signature})},
            package_name    => $ctx->get_curstash_name,
            name            => $name,
        );

        $_->($method)
            for @populators;

        $attributes{PathPart} ||= "'$name'";

        delete $attributes{CaptureArgs}
            if exists $attributes{Args};

        $attributes{CaptureArgs} = 0
            unless exists $attributes{Args}
                or exists $attributes{CaptureArgs};

        if ($ctx->peek_next_char eq '{') {
            $ctx->inject_if_block($ctx->scope_injector_call . $method->injectable_code);
        }
        else {
            $ctx->inject_code_parts_here(
                sprintf '{ %s%s }',
                    $ctx->scope_injector_call,
                    $method->injectable_code,
            );
        }

        pp \%attributes;

        AttributeRole->meta->apply($method);

        my @attributes = map { 
            join('',
                $_,
                sprintf('(%s)', $attributes{ $_ }),
            );
        } keys %attributes;

        return $ctx->shadow(sub (&) {
            my $class = caller;

            $method->_set_actual_body(shift);
            $method->{attributes} = \@attributes;
    
            $class->meta->add_method($name, $method);
            $class->meta->register_method_attributes($class->can($method->name), \%attributes);
        });
    }

    method _handle_action_option (Object $ctx, HashRef $attrs) {

        # action name
        my $name = $ctx->strip_name
            or croak "Anonymous actions not yet supported";

        # signature
        my $proto = $ctx->strip_proto || '';
        $proto = join(', ', 'Object $self: Object $ctx', $proto || ());

        $attrs->{Subname}   = $name;
        $attrs->{Signature} = $proto;

        return;
    }

    method _handle_is_option (Object $ctx, HashRef $attrs) {

        my $what = $ctx->strip_name
            or croak "Expected symbol token after is symbol, not " . substr($ctx->get_linestr, $ctx->offset);

        return sub {
            my $method = shift;

            if ($what eq any qw( end endpoint final )) {
                my $count = $self->_count_positional_arguments($method);
                $attrs->{Args} = defined($count) ? $count : '';
            }
            elsif ($what eq 'private') {
                $attrs->{Private} = 1;
            }
        };
    }

    method _handle_under_option (Object $ctx, HashRef $attrs) {

        my $target = $self->_strip_actionpath($ctx);
        $attrs->{Chained} = "'$target'";

        return sub {
            my $method = shift;

            my $count = $self->_count_positional_arguments($method);
            $attrs->{CaptureArgs} = $count
                if defined $count;
        };
    }

    method _handle_chains_option (Object $ctx, HashRef $attrs) {

        $ctx->skipspace;
        $ctx->strip_name eq 'to'
            or croak "Expected to token after chains symbol, not " . substr($ctx->get_linestr, $ctx->offset);

        return $self->_handle_under_option($ctx, $attrs);
    }

    method _handle_as_option (Object $ctx, HashRef $attrs) {

        $ctx->skipspace;

        my $path = $self->_strip_actionpath($ctx);
        $attrs->{PathPart} = "'$path'";

        return;
    }

    method _count_positional_arguments (Object $method) {
        my $signature = $method->_parsed_signature;

        if ($signature->has_positional_params) {
            my $count = @{ scalar($signature->positional_params) };

            if ($count and ($signature->positional_params)[-1]->sigil eq '@') {
                return undef;
            }

            return $count - 1;
        }

        return 0;
    }

    method _strip_actionpath (Object $ctx) {

        $ctx->skipspace;
        my $linestr = $ctx->get_linestr;
        my $rest    = substr($linestr, $ctx->offset);

        if ($rest =~ /^ ( [_a-z] [_a-z0-9]* ) \b/ix) {
            substr($linestr, $ctx->offset, length($1)) = '';
            $ctx->set_linestr($linestr);
            return $1;
        }
        elsif ($rest =~ /^ ' ( (?:[a-z0-9]|\/)* ) ' /ix) {
            substr($linestr, $ctx->offset, length($1) + 2) = '';
            $ctx->set_linestr($linestr);
            return $1;
        }
        else {
            croak "Invalid syntax for action path: $rest";
        }
    }
}



