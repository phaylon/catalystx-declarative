use CatalystX::Declarative;

controller TestApp::Controller::Foo {

    has bar => (is => 'rw');

    method baz { }

    under '/', action base, as '';

    action root under base as '' is final { }

    action list under base is final { }

    under base, as 'id', action object ($id) { }

    action view under object is final { $ctx->res->body('Hello World!') }

    action edit under object is final { }

    action tag (@tags) under object is final { }
}

