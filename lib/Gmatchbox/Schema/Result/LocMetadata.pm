package Gmatchbox::Schema::Result::LocMetadata;

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

Gmatchbox::Schema::Result::LocMetadata

=cut

__PACKAGE__->table("loc_metadata");

=head1 ACCESSORS

=head2 loc_metadata_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 value

  data_type: 'longblob'
  is_nullable: 0

=head2 loc_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 loc_metadata_type_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "loc_metadata_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "value",
  { data_type => "longblob", is_nullable => 0 },
  "loc_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "loc_metadata_type_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("loc_metadata_id");

=head1 RELATIONS

=head2 loc

Type: belongs_to

Related object: L<Gmatchbox::Schema::Result::Loc>

=cut

__PACKAGE__->belongs_to(
  "loc",
  "Gmatchbox::Schema::Result::Loc",
  { loc_id => "loc_id" },
);

=head2 loc_metadata_type

Type: belongs_to

Related object: L<Gmatchbox::Schema::Result::LocMetadataType>

=cut

__PACKAGE__->belongs_to(
  "loc_metadata_type",
  "Gmatchbox::Schema::Result::LocMetadataType",
  { loc_metadata_type_id => "loc_metadata_type_id" },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-11-10 14:58:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+ukVtnQFCjc4qmaYCAcL3A


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
