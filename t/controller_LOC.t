use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'Gmatchbox' }
BEGIN { use_ok 'Gmatchbox::Controller::LOC' }

my $tLocId = 1;
ok( request("/loc/$tLocId")->is_success, '/loc/* success' );
ok( request("/loc/$tLocId/metadata")->is_success, '/loc/*/metadata' );

done_testing();
