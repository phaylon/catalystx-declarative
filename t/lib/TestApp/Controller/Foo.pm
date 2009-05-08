use CatalystX::Declarative;

controller TestApp::Controller::Foo {


    #
    #   look, a Moose!
    #

    has title => (
        is      => 'ro',
        isa     => 'Str',
        default => 'TestApp',
    );


    #
    #   normal methods are very useful too
    #

    method welcome_message { sprintf 'Welcome to %s!', $self->title }

    method greet (Str $name) { "Hello, $name!" }


    #
    #   the simple stuff
    #

    action base under '/base' as 'foo';

    action root under base as '' is final {
        $ctx->response->body( $self->welcome_message );
    }

    
    #
    #   with arguments
    #

    action with_args under base;

    action hello (Str $name) under with_args is final {
        $ctx->response->body($self->greet(ucfirst $name));
    }

    action at_end (Int $x, Int $y) under with_args is final { 
        $ctx->response->body( $x * $y );
    }

    action in_the_middle (Int $x, Int $y) under with_args {
        $ctx->stash(result => $x * $y);
    }
    action end_of_the_middle under in_the_middle is final {
        $ctx->response->body($ctx->stash->{result} * 2);
    }

    action all_the_way (Int $x) under with_args as '' {
        $ctx->stash(x => $x);
    }
    action through_the_sky (Int $y) under all_the_way as '' {
        $ctx->stash(y => $y);
    }
    action and_beyond (@rest) under through_the_sky as fhtagn is final {
        $ctx->response->body(join ', ', 
            $ctx->stash->{x},
            $ctx->stash->{y},
            @rest,
        );
    }


    #
    #   under is also a valid keyword
    #

    under base action under_base as under;

    under under_base as '' action even_more_under (Int $i) is final {
        $ctx->response->body("under $i");
    }


    #
    #   too many words? go comma go!
    #

    action comma_base, as '', under base;

    under comma_base, is final, action comma ($str), as ',comma' {
        $ctx->response->body($str);
    }

}

