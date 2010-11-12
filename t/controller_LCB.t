use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'Gmatchbox' }
BEGIN { use_ok 'Gmatchbox::Controller::LCB' }

my $tLcbId = 0;
ok( request("/lcb/$tLcbId")->is_success, '/lcb/* success' );
ok( request("/lcb/$tLcbId/loc")->is_success, '/lcb/*/loc success' );
ok( request("/lcb/$tLcbId/loc/metadata")->is_success, '/lcb/*/loc/metadata success' );

done_testing();
