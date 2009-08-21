use CatalystX::Declare;

controller TestApp::Controller::SignatureMatching {

    method mark (Catalyst $ctx) { 
        $ctx->response->body( $ctx->action->reverse );
    }


    action base as 'sigmatch' under '/';

    under base {

        final action int (Int $x) 
            as test { $self->mark($ctx) }

        final action str (Str $x where { /^[a-z]+$/ }) 
            as test { $self->mark($ctx) }

        final action rest (@) 
            as '' { $self->mark($ctx) }
    }
}
