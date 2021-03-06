package Gmatchbox::Schema::Result::LocSet;

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

Gmatchbox::Schema::Result::LocSet

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

=head1 RELATIONS

=head2 locs

Type: has_many

Related object: L<Gmatchbox::Schema::Result::Loc>

=cut

__PACKAGE__->has_many(
  "locs",
  "Gmatchbox::Schema::Result::Loc",
  { "foreign.loc_set_id" => "self.loc_set_id" },
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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:H5OUeF4RJhrn7Ut44CaO4g


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
