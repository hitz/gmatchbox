use strict;
use warnings;
use Test::More;
use JSON;

BEGIN { use_ok 'Catalyst::Test', 'Gmatchbox' }
BEGIN { use_ok 'Gmatchbox::Controller::LOC' }

## Note the following assumes you have loaded sql/gmatchbox.example_lco.sql into a database that your Model can access
my $tLocId = 66;
my $locData = {
      json_loc => {
          loc_id => "66",
          stop => "1709",
          linear_coordinate_object_id => "1||1709||2215||genomic_hit||-1",
          orientation => "-1",
          loc_set_id => "33",
          start => "2215",
      }
};

my $locMetaData = {
	loc_metadatas => [
      {
          loc_id => "66",
          value => "73.96",
            loc_metadata_type => {
                loc_metadata_type_id => "1",
                name => "Percent ID",
                description => undef,
            },
          loc_metadata_id => "391",
          loc_metadata_type_id => "1",
      },
      {
          loc_id => "66",
          value => "507",
            loc_metadata_type => {
                loc_metadata_type_id => "2",
                name => "Alignment Length",
                description => undef,
            },
          loc_metadata_id => "392",
          loc_metadata_type_id => "2",
      },
      {
          loc_id => "66",
          value => "131",
           loc_metadata_type => {
                loc_metadata_type_id => "3",
                name => "MisMatches",
                description => undef,
            },
          loc_metadata_id => "393",
          loc_metadata_type_id => "3",
      },
      {
          loc_id => "66",
          value => "1",
            loc_metadata_type => {
                loc_metadata_type_id => "4",
                name => "Gap Openings",
                description => undef,
            },
          loc_metadata_id => "394",
          loc_metadata_type_id => "4",
      },
      {
          loc_id => "66",
          value => "1e-83",
            loc_metadata_type => {
                loc_metadata_type_id => "5",
                name => "E-value",
                description => undef,
            },
          loc_metadata_id => "395",
          loc_metadata_type_id => "5",
      },
      {
          loc_id => "66",
          value => " 316",           
            loc_metadata_type => {
                loc_metadata_type_id => "6",
                name => "Bit Score",
                description => undef,
            },
          loc_metadata_id => "396",
          loc_metadata_type_id => "6",
      },
	]
};

#TODO - have to translate request JSON object back into Perl Hash!
# Then test values!
# Then create more natural streamlined objects
my $req = request("/loc/$tLocId");
ok( $req->is_success, '/loc/* success' );
is_deeply( from_json($req->content), $locData, '/loc/* returns correct JSON');
$req = request("/loc/$tLocId/metadata");
ok( $req->is_success, '/loc/*/metadata' );
is_deeply( from_json($req->content)->{json_loc}->{loc_metadatas}, $locMetaData->{loc_metadatas}, '/loc/*/metadata returns correct JSON');

done_testing();
