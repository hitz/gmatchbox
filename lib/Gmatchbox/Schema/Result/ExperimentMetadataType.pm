package gmatchbox::Schema::Result::ExperimentMetadataType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

gmatchbox::Schema::Result::ExperimentMetadataType

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

Related object: L<gmatchbox::Schema::Result::ExperimentMetadata>

=cut

__PACKAGE__->has_many(
  "experiment_metadatas",
  "gmatchbox::Schema::Result::ExperimentMetadata",
  {
    "foreign.experiment_metadata_type_id" => "self.experiment_metadata_type_id",
  },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07000 @ 2010-11-10 13:07:51
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:WZBc8vgPYD/VJSYjtPJ7iQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
