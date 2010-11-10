package Gmatchbox::Schema::Result::Loc;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

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

  data_type: 'integer'
  is_nullable: 1

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
  { data_type => "integer", is_nullable => 1 },
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
  { on_delete => "CASCADE", on_update => "CASCADE" },
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


# Created by DBIx::Class::Schema::Loader v0.07000 @ 2010-11-10 15:21:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:EMLxzyCyMs3mgfuZ6kN3xA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
