use CatalystX::Declarative;

controller TestApp::Controller::Root {
    CLASS->config(namespace => '');

    action base under '/' as '';

    final action context_method ($n) under base { $ctx->response->body($ctx->loc($n)) }
}

