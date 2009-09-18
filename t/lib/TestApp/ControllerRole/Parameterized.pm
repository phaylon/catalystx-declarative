use CatalystX::Declare;

controller_role TestApp::ControllerRole::Parameterized (Str :$message, Str :$base, Str :$part) {

    method get_message { $message }

    final action greet under base {
        $ctx->response->body( join ':', $self->get_message, $message );
    }

    final action dynabase under "$base" {
        $ctx->response->body( "under $base" );
    }

    final action dynapart under "$base" as $part {
        $ctx->response->body( "under $base as $part" );
    }

    under $base {

        final action scoped {
            $ctx->response->body( "scoped under $base" );
        }

        final action complex as "$part/deep" {
            $ctx->response->body( "$part/deep under $base" );
        }
    }
}
