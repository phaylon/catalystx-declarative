#!/usr/bin/env perl
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";

use Test::More tests => 7;
use Catalyst::Test 'TestApp';

# simple stuff
is get('/foo'), 'Welcome to TestApp!', 'simple root action';

# with arguments
is get('/foo/with_args/hello/cthulhu'), 'Hello, Cthulhu!', 'simple argument';
is get('/foo/with_args/at_end/2/3'), 6, 'two arguments at the end';
is get('/foo/with_args/in_the_middle/3/4/end_of_the_middle'), 24, 'two arguments in the middle';
is get('/foo/with_args/4/8/fhtagn/15/16/23/42'), '4, 8, 15, 16, 23, 42', 'complex arguments in both';

# under keyword
is get('/foo/under/23'), 'under 23', 'under as keyword';

# comma separation
is get('/foo/,comma/iaia'), 'iaia', 'comma separation';
