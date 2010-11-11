package Gmatchbox::Controller::LCB;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Gmatchbox::Controller::LCB - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 get_rs

Just initializes the resultset and HRI for DBIC and puts it in the stash

=cut

sub get_rs {
	my ($self, $c ) = @_;

	my $rs = $c->model('DB::LocSet');
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	$c->stash(resultset => $rs);
	
}

=head2 index

Defaults to list of whole database.
=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

	$self->get_rs($c);
	$c->stash(json_lcbs => [ $c->stash->{resultset}->all ]);
	$c->forward('View::JSON');
}

=head2 base

   base chained url /lcb/X/

=cut
sub base : Chained('/') : PathPart('lcb') : CaptureArgs(0) {
	my ( $self, $c ) = @_;
	$self->get_rs($c);
	
}

=head2 lcb_name

   URL for lcb/name/? 
   return json object for specified lcb by name
   
=cut

sub lcb_name : Chained('base') : PathPart('name') : Args(1) {
	my ($self, $c, $name) = @_;
	
	$c->stash(json_lcb => $c->stash->{resultset}->find({name => { '-like' => "%$name%" }},
														 {prefetch => { 'locs' => { 'loc_metadatas'} }}));

	$c->detach('/error_db') if !$c->stash->{json_lcb};
	$c->forward('View::JSON');
	
}

=head2 lcb_id

   URL for lcb/id/? 
   return json object for specified lcb by id.
   How you got that id?  I dunno.
   
=cut

sub lcb_id : Chained('base') : PathPart('id') : Args(1) {
	my ($self, $c, $id) = @_;

	$c->stash(json_lcb => $c->stash->{resultset}->find({loc_set_id => $id},
														 {prefetch => { 'locs' => { 'loc_metadatas'} }}));
	
	$c->detach('/error_db') if !$c->stash->{json_lcb};
	$c->forward('View::JSON');
	
}

=head1 AUTHOR

Ben Hitz

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;