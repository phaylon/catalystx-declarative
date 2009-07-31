use MooseX::Declare;

role CatalystX::Declare::Action::CatchValidationError {

    use TryCatch;

    around execute (Object $controller, Object $ctx, @rest) {

        try {
            $self->$orig($controller, $ctx, @rest);
        }
        catch (Str $error where { /^Validation failed for/ }) {

            $ctx->response->body( 'Bad Request' );
            $ctx->response->status( 400 );
            $ctx->detach;
        }
        catch (Any $other) {

            die $other;
        }

        return 1;
    }
}
