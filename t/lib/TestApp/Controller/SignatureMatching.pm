use CatalystX::Declare;

controller TestApp::Controller::SignatureMatching {

    action base as 'sigmatch' under '/';

    under base {

        final action int (Int $x) 
            as 'test' { $ctx->response->body( $ctx->action->reverse ) }

        final action str (Str $x where { /^[a-z]+$/ }) 
            as 'test' { $ctx->response->body( $ctx->action->reverse ) }

        final action rest (@) 
            as '' { $ctx->response->body( $ctx->action->reverse ) }
    }
}
