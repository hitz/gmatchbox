package gmatchbox::Schema::Result::Experiment;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

gmatchbox::Schema::Result::Experiment

=cut

__PACKAGE__->table("experiment");

=head1 ACCESSORS

=head2 experiment_id

  data_type: 'integer'
  is_auto_increment: 1
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
  "experiment_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 128 },
  "description",
  { data_type => "varchar", is_nullable => 1, size => 1054 },
);
__PACKAGE__->set_primary_key("experiment_id");
__PACKAGE__->add_unique_constraint("name", ["name"]);

=head1 RELATIONS

=head2 experiment_metadatas

Type: has_many

Related object: L<gmatchbox::Schema::Result::ExperimentMetadata>

=cut

__PACKAGE__->has_many(
  "experiment_metadatas",
  "gmatchbox::Schema::Result::ExperimentMetadata",
  { "foreign.experiment_id" => "self.experiment_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 loc_sets

Type: has_many

Related object: L<gmatchbox::Schema::Result::LocSet>

=cut

__PACKAGE__->has_many(
  "loc_sets",
  "gmatchbox::Schema::Result::LocSet",
  { "foreign.experiment_id" => "self.experiment_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07000 @ 2010-11-10 13:01:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+AcTqnNX3GykQLDnfwNpjg


# You can replace this text with custom content, and it will be preserved on regeneration
1;