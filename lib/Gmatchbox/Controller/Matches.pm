package Gmatchbox::Controller::Matches;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Gmatchbox::Controller::Matches - Catalyst Controller

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
	$c->stash(json_matches => [ $c->stash->{resultset}->all ]);
	$c->forward('View::JSON');
}

=head2 base

   base chained url /matches/X/

=cut
sub base : Chained('/') : PathPart('matches') : CaptureArgs(0) {
	my ( $self, $c ) = @_;
	$self->get_rs($c);
	
}

=head2 match_name

   URL for matches/name/? 
   return json object for specified match by name
   
=cut

sub match_name : Chained('base') : PathPart('name') : Args(1) {
	my ($self, $c, $name) = @_;
	
	$c->stash(json_match => $c->stash->{resultset}->find({name => { '-like' => "%$name%" }},
														 {prefetch => { 'locs' => { 'loc_metadatas'} }}));

	$c->detach('/error_db') if !$c->stash->{json_match};
	$c->forward('View::JSON');
	
}

=head2 match_id

   URL for matches/id/? 
   return json object for specified match by id.
   How you got that id?  I dunno.
   
=cut

sub match_id : Chained('base') : PathPart('id') : Args(1) {
	my ($self, $c, $id) = @_;

	$c->stash(json_match => $c->stash->{resultset}->find({loc_set_id => $id},
														 {prefetch => { 'locs' => { 'loc_metadatas'} }}));
	
	$c->detach('/error_db') if !$c->stash->{json_match};
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


=head1 AUTHOR

Ben Hitz

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
