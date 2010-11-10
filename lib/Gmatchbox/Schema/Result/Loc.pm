package Gmatchbox::Schema::Result::Loc;

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

Gmatchbox::Schema::Result::Loc

=cut

__PACKAGE__->table("loc");

=head1 ACCESSORS

=head2 loc_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 start

  data_type: 'integer'
  is_nullable: 0

=head2 stop

  data_type: 'integer'
  is_nullable: 0

=head2 orientation

  data_type: 'integer'
  is_nullable: 0

=head2 loc_set_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 linear_coordinate_object_id

  data_type: 'varchar'
  is_nullable: 1
  size: 1024

=cut

__PACKAGE__->add_columns(
  "loc_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "start",
  { data_type => "integer", is_nullable => 0 },
  "stop",
  { data_type => "integer", is_nullable => 0 },
  "orientation",
  { data_type => "integer", is_nullable => 0 },
  "loc_set_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "linear_coordinate_object_id",
  { data_type => "varchar", is_nullable => 1, size => 1024 },
);
__PACKAGE__->set_primary_key("loc_id");

=head1 RELATIONS

=head2 loc_set

Type: belongs_to

Related object: L<Gmatchbox::Schema::Result::LocSet>

=cut

__PACKAGE__->belongs_to(
  "loc_set",
  "Gmatchbox::Schema::Result::LocSet",
  { loc_set_id => "loc_set_id" },
);

=head2 loc_metadatas

Type: has_many

Related object: L<Gmatchbox::Schema::Result::LocMetadata>

=cut

__PACKAGE__->has_many(
  "loc_metadatas",
  "Gmatchbox::Schema::Result::LocMetadata",
  { "foreign.loc_id" => "self.loc_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-11-10 14:58:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:L/K7t1SY/Si6MQlHxOaT0A


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
