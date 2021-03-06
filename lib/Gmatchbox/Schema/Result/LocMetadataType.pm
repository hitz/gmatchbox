package Gmatchbox::Schema::Result::LocMetadataType;

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

Gmatchbox::Schema::Result::LocMetadataType

=cut

__PACKAGE__->table("loc_metadata_type");

=head1 ACCESSORS

=head2 loc_metadata_type_id

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
  "loc_metadata_type_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 128 },
  "description",
  { data_type => "varchar", is_nullable => 1, size => 1054 },
);
__PACKAGE__->set_primary_key("loc_metadata_type_id");

=head1 RELATIONS

=head2 loc_metadatas

Type: has_many

Related object: L<Gmatchbox::Schema::Result::LocMetadata>

=cut

__PACKAGE__->has_many(
  "loc_metadatas",
  "Gmatchbox::Schema::Result::LocMetadata",
  { "foreign.loc_metadata_type_id" => "self.loc_metadata_type_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-11-10 14:58:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:qQ6AAN4XJF1RKfqO/g/8ZA


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
