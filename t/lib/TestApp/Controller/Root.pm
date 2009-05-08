use CatalystX::Declarative;

controller TestApp::Controller::Root {
    CLASS->config(namespace => '');

    action base under '/' as '';
}

