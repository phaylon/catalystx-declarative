use CatalystX::Declare;

controller_role TestApp::ControllerRole::Parameterized (Str :$message) {

    method get_message { $message }

    final action greet under base {
        no warnings 'uninitialized'; # remove if TODO is fixed
        $ctx->response->body( join ':', $self->get_message, $message );
    }
}
