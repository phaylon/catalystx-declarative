use inc::Module::Install;

name            'CatalystX-Declare';
author          'Robert Sedlacek <rs@474.at>';
license         'perl';

all_from        'lib/CatalystX/Declare.pm';
readme_from     'lib/CatalystX/Declare.pm';

author_tests    'xt';

requires        'Carp',                     '1.08';
requires        'Class::Inspector',         '1.24';
requires        'Perl6::Junction',          '1.40000';
requires        'aliased',                  '0.22';
requires        'Data::Dump',               '1.14';
requires        'Catalyst',                 '5.80007';
requires        'Moose',                    '0.88';
requires        'MooseX::AttributeHelpers', '0.16';
requires        'MooseX::Declare',          '0.23';
requires        'MooseX::MethodAttributes', '0.15';
requires        'MooseX::Types',            '0.16';

test_requires   'Catalyst::Test';
test_requires   'FindBin';
test_requires   'Test::More',               '0.92';

repository      'http://github.com/phaylon/catalystx-declarative/tree/master';
bugtracker      'http://github.com/phaylon/catalystx-declarative/issues';

auto_manifest;
auto_provides_class;

WriteAll;