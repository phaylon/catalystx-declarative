use CatalystX::Declare;

controller TestApp::Controller::Parameterized {
    with 'TestApp::ControllerRole::Parameterized' => { message => 'foo' };

    action base under '/' as 'param';
}
