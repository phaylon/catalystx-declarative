#!/usr/bin/env perl
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";

use Catalyst::Test 'TestApp';

use Test::More tests => 2;

is(TestApp->config->{foobar}, 'baz', 'config worked on app');
is(get('/context_method/aSd3'), 'ASD3', 'context methods can be called');
