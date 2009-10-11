use inc::Module::Install;

BEGIN {
    if ($Module::Install::AUTHOR) {

        "Module::Install::$_"->can('can') 
            or die "Module::Install extension Module::Install::$_ is required for authors"
            for qw(
                    AuthorTests
                    AutoManifest
                    ReadmeFromPod
                    ProvidesClass
            );

        Module::Install::ProvidesClass->VERSION('0.000001_99');
    }
}

name            'CatalystX-Declare';
author          'Robert Sedlacek <rs@474.at>';
license         'perl';

all_from        'lib/CatalystX/Declare.pm';
readme_from     'lib/CatalystX/Declare.pm';

tests           't/*.t';
author_tests    'xt', 'examples/MyApp-Web/t';

requires        'Carp';
requires        'Class::Inspector',                 '1.24';
requires        'Perl6::Junction',                  '1.40000';
requires        'aliased',                          '0.30';
requires        'parent',                           '0.221';
requires        'Data::Dump',                       '1.14';
requires        'Catalyst',                         '5.80012';
requires        'CLASS',                            '1.00';
requires        'Devel::Declare',                   '0.005011';
requires        'Moose',                            '0.89';
requires        'MooseX::AttributeHelpers',         '0.21';
requires        'MooseX::Declare',                  '0.30';
requires        'MooseX::MethodAttributes',         '0.16';
requires        'MooseX::Role::Parameterized',      '0.13';
requires        'MooseX::Types',                    '0.20';
requires        'MooseX::Method::Signatures',       '0.26';
requires        'FindBin';

test_requires   'Test::More',                       '0.92';
test_requires   'Test::Output',                     '0.16';
test_requires   'Catalyst::Test';
test_requires   'FindBin';

repository      'http://github.com/phaylon/catalystx-declarative/tree/master';
bugtracker      'http://github.com/phaylon/catalystx-declarative/issues';

auto_manifest;
auto_provides_class;

WriteAll;
