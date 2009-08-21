#!/usr/bin/env perl
use strict;
use warnings;

no warnings 'redefine';

use FindBin;
use lib "$FindBin::Bin/lib";

use Test::More; 
use Catalyst::Test 'TestApp';


is get('/sigmatch/test/23'), 'signaturematching/int', 'integer argument dispatched correctly';
is get('/sigmatch/test/foo'), 'signaturematching/str', 'string argument dispatched correctly';
is get('/sigmatch/test/f00'), 'signaturematching/rest', 'no match leads to other dispatched action';

done_testing;
