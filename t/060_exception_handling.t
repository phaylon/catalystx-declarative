#!/usr/bin/env perl
use strict;
use warnings;

no warnings 'redefine';

use FindBin;
use lib "$FindBin::Bin/lib";

use Test::More; 
use Test::Output;
use Catalyst::Test 'TestApp';

my $get    = sub { get(join '/', '/errors/signature_error_on_foo', @_) };
my $subget = sub { get(join '/', '/sub_errors/signature_error_on_foo', @_) };
my $modget = sub { get(join '/', '/sub_errors/signature_error_on_foo_modify', @_) };


local *TestApp::debug = sub { 0 };

is $get->('foo'),       'Bad Request', 'detected action signature error';
is $subget->('foo'),    'Bad Request', 'detected action signature error (child)';
is $modget->('foo'),    'Bad Request', 'detected action signature error (modified)';

stderr_like {

    like $get->('bar'),     qr/come back later/i, 'normal handling of method validation error';

} qr/Validation failed/, 'method error throws validation error to error log';

stderr_like {

    like $subget->('bar'),  qr/come back later/i, 'normal handling of method validation error (child)';

} qr/Validation failed/, 'method error throws validation error to error log (child)';

stderr_like {

    like $modget->('bar'),  qr/come back later/i, 'normal handling of method validation error (modified)';

} qr/Validation failed/, 'method error throws validation error to error log (modified)';

is $get->('baz'),       'FOO BAR', 'make sure all works without any errors happening';
is $subget->('baz'),    'FOO BAR', 'make sure all works without any errors happening (child)';
is $modget->('baz'),    'FOO_MODIFY BAR', 'make sure all works without any errors happening (child)';


local *TestApp::debug = sub { 1 };

stderr_like {

    my $foo_err = $get->('foo');
    like $foo_err, qr/BAD REQUEST: /, 'debug version of bad request error';
    like $foo_err, qr/Validation failed/i, 'debug version of bad request contains error message';

} qr/BAD REQUEST:.+Validation failed/i, 'debug output with bad request note and error message';

stderr_like {

    my $foo_err = $subget->('foo');
    like $foo_err, qr/BAD REQUEST: /, 'debug version of bad request error (child)';
    like $foo_err, qr/Validation failed/i, 'debug version of bad request contains error message (child)';

} qr/BAD REQUEST:.+Validation failed/i, 'debug output with bad request note and error message (child)';

stderr_like {

    my $foo_err = $modget->('foo');
    like $foo_err, qr/BAD REQUEST: /, 'debug version of bad request error (modified)';
    like $foo_err, qr/Validation failed/i, 'debug version of bad request contains error message (modified)';

} qr/BAD REQUEST:.+Validation failed/i, 'debug output with bad request note and error message (modified)';

stderr_like {

    my $bar_err = $get->('bar');
    unlike $bar_err, qr/BAD REQUEST: /, 'debug version of method error contains no bad request note';
    like $bar_err, qr/Validation failed/i, 'we got the right error message';

} qr/Validation failed/i, 'error message reaches stdout';

stderr_like {

    my $bar_err = $subget->('bar');
    unlike $bar_err, qr/BAD REQUEST: /, 'debug version of method error contains no bad request note (child)';
    like $bar_err, qr/Validation failed/i, 'we got the right error message (child)';

} qr/Validation failed/i, 'error message reaches stdout (child)';

stderr_like {

    my $bar_err = $modget->('bar');
    unlike $bar_err, qr/BAD REQUEST: /, 'debug version of method error contains no bad request note (modified)';
    like $bar_err, qr/Validation failed/i, 'we got the right error message (modified)';

} qr/Validation failed/i, 'error message reaches stdout (modified)';

stderr_unlike {

    is $get->('baz'), 'FOO BAR', 'make sure all works without any errors happening in debug mode';

} qr/\[error\]/i, 'no errors in output';

stderr_unlike {

    is $subget->('baz'), 'FOO BAR', 'make sure all works without any errors happening in debug mode (child)';

} qr/\[error\]/i, 'no errors in output (child)';

stderr_unlike {

    is $modget->('baz'), 'FOO_MODIFY BAR', 'make sure all works without any errors happening in debug mode (modified)';

} qr/\[error\]/i, 'no errors in output (modified)';


done_testing;
