package Gmatchbox::Controller::LOC;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Gmatchbox::Controller::LOC - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 get_rs

Just initializes the resultset and HRI for DBIC and puts it in the stash

=cut

sub get_rs {
	my ($self, $c ) = @_;

	my $rs = $c->model('DB::Loc');
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	$c->stash(resultset => $rs);
	
}

=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Gmatchbox::Controller::LOC in LOC.');
}

=head2 base

   base chained url /loc/X/

=cut
sub base : Chained('/') : PathPart('loc') : CaptureArgs(1) {
	my ( $self, $c, $id ) = @_;
	$self->get_rs($c);
	$c->stash(search => { loc_id => $id });
}

=head2 id

   base  url /loc/X/

=cut
sub id : Chained('base') : PathPart('') : Args(0) {
	my ( $self, $c) = @_;
	
	$c->stash(json_loc => $c->stash->{resultset}->find($c->stash->{'select'}));
	
	$c->detach('/error_db') if !$c->stash->{json_loc};
	$c->forward('View::JSON');
	
	
}

=head2 metadata

   base  url /loc/X/metadata

=cut
sub metadata: Chained('base')  : Args(0) {
	my ( $self, $c) = @_;
	
	$c->stash(json_loc => $c->stash->{resultset}->find($c->stash->{'select'},
													   {prefetch => 
															  {'loc_metadatas' =>
															  	 'loc_metadata_type'}
															  }
													   ));
	
	$c->detach('/error_db') if !$c->stash->{json_loc};
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
