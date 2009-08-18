#!/usr/bin/env perl
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";

use Test::More; 
use Catalyst::Test 'TestApp';

TODO: {
    local $TODO = 'MooseX::MethodAttributes needs to allow this';
    is get('/param/greet'), 'foo:foo', 'parameterized role was consumed correctly';
}

done_testing;
