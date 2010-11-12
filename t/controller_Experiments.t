use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'Gmatchbox' }
BEGIN { use_ok 'Gmatchbox::Controller::Experiments' }

my $tExpId = 0;
my $tExpName = '';


ok( request('/experiments')->is_success, '/experiments success' );
ok( request("/experiment/$tExpId")->is_success, '/experiment/* success' );
ok( request("/experiment/name/$tExpName")->is_success, '/experiment/name/* success' );
ok( request("/experiment/$tExpId/lcb")->is_success, '/experiment/*/lcb success' );
ok( request("/experiment/$tExpId/lcb/loc")->is_success, '/experiment/*/lcb/loc success' );
ok( request("/experiment/$tExpId/lcb/loc/metadata")->is_success, '/experiment/*/lcb/loc/metadata success' );

done_testing();
