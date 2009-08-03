use MooseX::Declare;

role CatalystX::Declare::Action::CatchValidationError {

    use TryCatch;

    around execute (Object $controller, Object $ctx, @rest) {

        my $tc = $controller->meta->find_method_type_constraint($self->name)
              || do {
                   my $method = $controller->meta->find_method_by_name($self->name);
                   ( $_ = $method->can('type_constraint') )
                     ? $method->$_
                     : undef
                 };

        if ($tc and my $error = $tc->validate([$controller, $ctx, @rest])) {

            if ($ctx->debug) {
                $ctx->error("BAD REQUEST: $error");
            }
            else {
                $ctx->response->body( 'Bad Request' );
                $ctx->response->status( 400 );
            }
            
            $ctx->detach;
        }

        try {
            $self->$orig($controller, $ctx, @rest);
        }
        catch (Any $error) {

            $ctx->error($error);
            $ctx->detach;
        }

        return 1;
    }
}
