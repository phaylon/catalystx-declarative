use CatalystX::Declare;

controller TestApp::Controller::Parameterized is mutable {
    with 'TestApp::ControllerRole::Parameterized' => { message => 'foo' };

    action base under '/' as 'param';
}
