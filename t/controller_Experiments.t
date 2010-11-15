use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'Gmatchbox' }
BEGIN { use_ok 'Gmatchbox::Controller::Experiments' }

my $tExpId = 2;
my $tExpIdBAD = -1;
my $tExpName = 'testing';


ok( request('/experiments')->is_success, '/experiments success' );
ok( request("/experiment/$tExpId")->is_success, '/experiment/* success' );
#TODO test that data are valid for this request
ok( request("/experiment/$tExpIdBAD")->is_success, '/experiment/(bad id) success' );
#TODO test to make sure returns error
ok( request("/experiment/name/$tExpName")->is_success, '/experiment/name/* success' );
#TODO test that data are valid for this request
ok( request("/experiment/$tExpId/lcb")->is_success, '/experiment/*/lcb success' );
#TODO test that data are valid for this request
ok( request("/experiment/$tExpId/lcb/loc")->is_success, '/experiment/*/lcb/loc success' );
#TODO test that data are valid for this request
ok( request("/experiment/$tExpId/lcb/loc/metadata")->is_success, '/experiment/*/lcb/loc/metadata success' );
#TODO test that data are valid for this request

done_testing();
