package TestApp;
use strict;
use warnings;

use parent 'Catalyst';
use Catalyst qw( Static::Simple );

__PACKAGE__->config(name => 'CatalystX::Declare TestApp');
__PACKAGE__->setup;

1;
