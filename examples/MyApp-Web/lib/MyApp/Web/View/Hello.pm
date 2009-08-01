use MooseX::Declare;

# nothing special here, so it's just normal MooseX::Declare syntax
class MyApp::Web::View::Hello extends Catalyst::View {

    # the process method is the standard method that is forwarded to
    method process (Object $ctx) {

        # render something
        $ctx->response->body(
            sprintf
                '<html><body><h1>Hello View: %s</h1></body></html>', 
                ($ctx->stash->{hello} || 'Hello World!'),
        );
    }
}
