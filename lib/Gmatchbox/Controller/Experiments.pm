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

=head2 experiment_name

   URL for experiment/name/? 
   return json object for specified experiment by name
   
=cut

sub experiment_name : Chained('base') : PathPart('name') : Args(1) {
	my ($self, $c, $name) = @_;
	
	$c->stash(json_experiment => $c->stash->{resultset}->find({name => { '-like' => "%$name%" }}));

	$c->detach('/error_db') if !$c->stash->{json_experiment};
	$c->forward('View::JSON');
	
}

=head2 experiment_id

   URL for experiment/id/? 
   return json object for specified experiment by id.
   How you got that id?  I dunno.
   
=cut

sub experiment_id : Chained('base') : PathPart('id') : Args(1) {
	my ($self, $c, $id) = @_;

	$c->stash(json_experiment => $c->stash->{resultset}->find({experiment_id => $id}));
	
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
