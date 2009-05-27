use CatalystX::Declarative;
use FindBin;

application TestApp 
    with ConfigLoader 
    with Static::Simple {

    CLASS->config(foobar => "baz");

    method loc ($msg) { uc $msg }
}


