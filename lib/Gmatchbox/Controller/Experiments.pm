package Gmatchbox::Controller::Experiments;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Gmatchbox::Controller::Experiments - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 get_rs

Just initializes the resultset and HRI for DBIC and puts it in the stash

=cut

sub get_rs {
	my ($self, $c ) = @_;

	my $rs = $c->model('DB::Experiment');
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	$c->stash(resultset => $rs);
	
}

=head2 index

Defaults to list of whole database.
=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

	$self->get_rs($c);
	$c->stash(json_experiments => [ $c->stash->{resultset}->all ]);
	$c->forward('View::JSON');
}

=head2 base

   base chained url /experiments/X/

=cut
sub base : Chained('/') : PathPart('experiment') : CaptureArgs(0) {
	my ( $self, $c ) = @_;
	$self->get_rs($c);
	
}

=head2 name

   URL for experiment/name/? 
   return json object for specified experiment by name
   
=cut

sub name : Chained('base')  : Args(1) {
	my ($self, $c, $name) = @_;
	
	$c->stash(json_experiment => $c->stash->{resultset}->find({name => { '-like' => "%$name%" }},
															  {prefetch => {
															  		'experiment_metadata' =>
															  		 'experiment_metadata_type'}
															  },
															  ));

	$c->detach('/error_db') if !$c->stash->{json_experiment};
	$c->forward('View::JSON');
	
}

=head2 id

   URL for experiment/id/? 
   return json object for specified experiment by id.
   How you got that id?  I dunno.
   
=cut

sub id : Chained('base') : Args(1) {
	my ($self, $c, $id) = @_;

	$c->stash(json_experiment => $c->stash->{resultset}->find({experiment_id => $id},
															  {prefetch => {
															  		'experiment_metadata' =>
															  		 'experiment_metadata_type'}
															  },
															  ));

	
	$c->detach('/error_db') if !$c->stash->{json_experiment};
	$c->forward('View::JSON');
	
}


=head2 id_chain

   URL for experiment/id/?/lcb
   return json object for specified experiment by id.
   How you got that id?  I dunno.
   
=cut

sub id_chain : Chained('base') : PathPart('id') : CaptureArgs(1) {
	my ($self, $c, $id) = @_;

	$c->stash('select' => { experiment_id => $id });
	
}

=head2 lcb_id

   URL for experiment/(id|name)/?/lcb/ 
   return json objects for specified lcbs
   
=cut

sub lcb_id : Chained('name_chain') : PathPart('lcb') Args(0) {
	my ($self, $c) = @_;

	$c->stash(json_experiment => $c->stash->{resultset}->find($c->stash->{'select'},
															  {prefetch => 'locs'},
															  ));
	
	$c->detach('/error_db') if !$c->stash->{json_experiment};
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
