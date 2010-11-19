use strict;
use warnings;
use Test::More;
use JSON;

BEGIN { use_ok 'Catalyst::Test', 'Gmatchbox' }
BEGIN { use_ok 'Gmatchbox::Controller::Experiments' }

my $tExpIdBAD = -1;
my $tExpName = 'testing';
## Note the following assumes you have loaded sql/gmatchbox.example_lco.sql into a database that your Model can access
my $tExpId = 2;
my $expData = {
      json_experiment => {
            experiment_metadatas => [
                  {
                      experiment_metadata_id => "1",
                      value => "MegaBlast",
                        experiment_metadata_type => {
                           experiment_metadata_type_id => "1",
                           name => "Algorithm",
                           description => undef,
                        },
                      experiment_metadata_type_id => "1",
                      experiment_id => "2",
                  },
            ],
         name => "testing exp name",
         experiment_id => "2",
         description => "testing exp description",
      }
};

my $numExperiments = 1;
my $numLcb = 31651;
my $firstLcb = {
   loc_set_id => "1",
   name => "hit 1",
   experiment_id => "2",
   description => undef,
      locs => [
            {
               loc_id => "1"
               ,stop => "124086"
               ,linear_coordinate_object_id => "1||69174||124086||genomic_hit||1"
               ,orientation => "1"
               ,loc_set_id => "1"
               ,start => "69174"
            },
            {
               loc_id => "2"
               ,stop => "90309"
               ,linear_coordinate_object_id => "1||35531||90309||genomic_hit||1"
               ,orientation => "1"
               ,loc_set_id => "1"
               ,start => "35531"
            },
      ],
};

my $req = request('/experiments');
ok( $req->is_success, '/experiments success' );
is( scalar from_json($req->content)->{json_experiments}, $numExperiments, "/experiments returns correct number" );
$req = request("/experiment/$tExpId");
ok( $req->is_success, '/experiment/* success' );
is_deeply( from_json($req->content), $expData, '/experiment/* returns correct JSON object');
request("/experiment/$tExpIdBAD");
ok( $req->is_success, '/experiment/(bad id) success' );
#TODO test to make sure returns error (currently returns HTML snippet)
$req = request("/experiment/name/$tExpName");
ok( $req->is_success, '/experiment/name/* success' );
is_deeply( from_json($req->content), $expData, '/experiment/name/* returns correct JSON object by name');
#TODO test that data are valid for this request
$req = request("/experiment/$tExpId/lcb");
ok( $req->is_success, '/experiment/*/lcb success' );
#TODO test that number of  lcbs is returned correctly
$req = request("/experiment/$tExpId/lcb/loc");
ok( $req->is_success, '/experiment/*/lcb/loc success' );
#TODO test that the first loc looks like a loc
ok( request("/experiment/$tExpId/lcb/loc/metadata")$req->is_success, '/experiment/*/lcb/loc/metadata success' );
# Don't bother testing metadata; tested in controller_LOC.t
done_testing();
