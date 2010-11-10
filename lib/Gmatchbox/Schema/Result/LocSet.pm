package gmatchbox::Schema::Result::LocSet;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

gmatchbox::Schema::Result::LocSet

=cut

__PACKAGE__->table("loc_set");

=head1 ACCESSORS

=head2 loc_set_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 experiment_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 128

=head2 description

  data_type: 'varchar'
  is_nullable: 1
  size: 1054

=cut

__PACKAGE__->add_columns(
  "loc_set_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "experiment_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 128 },
  "description",
  { data_type => "varchar", is_nullable => 1, size => 1054 },
);
__PACKAGE__->set_primary_key("loc_set_id");
__PACKAGE__->add_unique_constraint("name", ["name"]);

=head1 RELATIONS

=head2 locs

Type: has_many

Related object: L<gmatchbox::Schema::Result::Loc>

=cut

__PACKAGE__->has_many(
  "locs",
  "gmatchbox::Schema::Result::Loc",
  { "foreign.loc_set_id" => "self.loc_set_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 experiment

Type: belongs_to

Related object: L<gmatchbox::Schema::Result::Experiment>

=cut

__PACKAGE__->belongs_to(
  "experiment",
  "gmatchbox::Schema::Result::Experiment",
  { experiment_id => "experiment_id" },
  { on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07000 @ 2010-11-10 13:01:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7/KmRBJEVISYUXlqg+/CCQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;