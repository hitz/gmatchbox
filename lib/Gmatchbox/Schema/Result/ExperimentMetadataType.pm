package Gmatchbox::Schema::Result::ExperimentMetadataType;

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

Gmatchbox::Schema::Result::ExperimentMetadataType

=cut

__PACKAGE__->table("experiment_metadata_type");

=head1 ACCESSORS

=head2 experiment_metadata_type_id

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
  "experiment_metadata_type_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 128 },
  "description",
  { data_type => "varchar", is_nullable => 1, size => 1054 },
);
__PACKAGE__->set_primary_key("experiment_metadata_type_id");

=head1 RELATIONS

=head2 experiment_metadatas

Type: has_many

Related object: L<Gmatchbox::Schema::Result::ExperimentMetadata>

=cut

__PACKAGE__->has_many(
  "experiment_metadatas",
  "Gmatchbox::Schema::Result::ExperimentMetadata",
  {
    "foreign.experiment_metadata_type_id" => "self.experiment_metadata_type_id",
  },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-11-15 17:27:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:MZy3+FW0hoCzc/BHOUL7Jw


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
