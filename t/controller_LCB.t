use strict;
use warnings;
use Test::More;
use JSON; 

BEGIN { use_ok 'Catalyst::Test', 'Gmatchbox' }
BEGIN { use_ok 'Gmatchbox::Controller::LCB' }

## Note the following assumes you have loaded sql/gmatchbox.example_lco.sql into a database that your Model can access
my $tLcbId = 33;
my $lcbData = {
      json_lcb => {
         loc_set_id => "33",
         name => "hit 33",
         experiment_id => "2",
         description => undef,
      }
};

my $locsData = { 
	locs => [
            {
                loc_id => "65"
                ,stop => "224363"
                ,linear_coordinate_object_id => "1||223858||224363||genomic_hit||1"
                ,orientation => "-1"
                ,loc_set_id => "33"
                ,start => "223858"
            },
            {
                loc_id => "66"
                ,stop => "1709"
                ,linear_coordinate_object_id => "1||1709||2215||genomic_hit||-1"
                ,orientation => "-1"
                ,loc_set_id => "33"
                ,start => "2215"
            },
      ]
};
my $req = request("/lcb/$tLcbId");
ok( $req->is_success, '/lcb/* success' );
is_deeply( from_json($req->content), $lcbData, '/lcb/*/ returns correct JSON');
$req = request("/lcb/$tLcbId/loc");
ok( $req->is_success, '/lcb/*/loc success' );
is_deeply( from_json($req->content)->{json_lcb}->{locs}, $locsData->{locs}, '/lcb/*/loc returns correct JSON');
ok( request("/lcb/$tLcbId/loc/metadata")->is_success, '/lcb/*/loc/metadata success' );
# don't bother to test metadata results; that is tested in controller_LOC.t

done_testing();
