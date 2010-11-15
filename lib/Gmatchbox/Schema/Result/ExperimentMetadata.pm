package Gmatchbox::Schema::Result::ExperimentMetadata;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Gmatchbox::Schema::Result::ExperimentMetadata

=cut

__PACKAGE__->table("experiment_metadata");

=head1 ACCESSORS

=head2 experiment_metadata_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 value

  data_type: 'varchar'
  is_nullable: 0
  size: 1054

=head2 experiment_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 experiment_metadata_type_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "experiment_metadata_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "value",
  { data_type => "varchar", is_nullable => 0, size => 1054 },
  "experiment_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "experiment_metadata_type_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("experiment_metadata_id");

=head1 RELATIONS

=head2 experiment_metadata_type

Type: belongs_to

Related object: L<Gmatchbox::Schema::Result::ExperimentMetadata>

=cut

__PACKAGE__->belongs_to(
  "experiment_metadata_type",
  "Gmatchbox::Schema::Result::ExperimentMetadataType",
  { "experiment_metadata_id" => "experiment_metadata_type_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 experiment_metadatas

Type: has_many

Related object: L<Gmatchbox::Schema::Result::ExperimentMetadata>

=cut

__PACKAGE__->has_many(
  "experiment_metadatas",
  "Gmatchbox::Schema::Result::ExperimentMetadata",
  {
    "foreign.experiment_metadata_type_id" => "self.experiment_metadata_id",
  },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 experiment

Type: belongs_to

Related object: L<Gmatchbox::Schema::Result::Experiment>

=cut

__PACKAGE__->belongs_to(
  "experiment",
  "Gmatchbox::Schema::Result::Experiment",
  { experiment_id => "experiment_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-11-12 15:45:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:KrZR9U6AnmnE16MqO84w+A


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
