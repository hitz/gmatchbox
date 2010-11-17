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

=head2 base

   base chained url /lcb/X/

=cut
sub base : Chained('/') : PathPart('lcb') : CaptureArgs(1) {
	my ( $self, $c, $id ) = @_;
	$self->get_rs($c);
	$c->stash(select => { loc_set_id => $id });
}

=head2 id

   base  url /lcb/X/

=cut
sub id : Chained('base') : PathPart('') : Args(0) {
	my ( $self, $c) = @_;
	
	$c->stash(json_lcb => $c->stash->{resultset}->find($c->stash->{'select'}));
	
	$c->detach('/error_db') if !$c->stash->{json_lcb};
	$c->forward('View::JSON');
	
	
}

=head2 loc

   base  url /lcb/X/loc

=cut
sub loc: Chained('base')  : Args(0) {
	my ( $self, $c) = @_;
	
	$c->stash(json_lcb => $c->stash->{resultset}->find($c->stash->{'select'},
													   {prefetch => 'locs' }
													  ));
	
	$c->detach('/error_db') if !$c->stash->{json_lcb};
	$c->forward('View::JSON');
	
}

=head2 loc_chain

   URL for /lcb/x/loc...
   return json objects for specified lcbs
   
=cut

sub loc_chain : Chained('base') : PathPart('loc') : CaptureArgs(0) {
	my ($self, $c) = @_;

}

=head2 metadata

   URL for experiment/?/lcb/loc/metadata
   return json objects for specified lcbs
   
=cut

sub metadata : Chained('loc_chain') : Args(0) {
	my ($self, $c) = @_;
	
	$c->stash(json_lcb => $c->stash->{resultset}->find($c->stash->{'select'},
															  {prefetch => {
															  				'locs' => {
															  							'loc_metadatas' => 'loc_metadata_type'
															  						  }
															  				},
															  }
															  ));
	
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