use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'Gmatchbox' }
BEGIN { use_ok 'Gmatchbox::Controller::Matches' }

ok( request('/matches')->is_success, 'Request should succeed' );
done_testing();
