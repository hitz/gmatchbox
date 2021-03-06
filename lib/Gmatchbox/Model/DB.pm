package Gmatchbox::Model::DB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    default_view => 'View::JSON',
    schema_class => 'Gmatchbox::Schema',
    
    connect_info => {
        dsn => 'dbi:mysql:gmatchbox',
        user => 'gmod',
        password => '1gmod1',
    }
);

=head1 NAME

Gmatchbox::Model::DB - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<Gmatchbox>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<Gmatchbox::Schema>

=head1 GENERATED BY

Catalyst::Helper::Model::DBIC::Schema - 0.43

=head1 AUTHOR

Eric Lyons

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
