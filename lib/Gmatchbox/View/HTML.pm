package Gmatchbox::View::HTML;

use strict;
use warnings;

use base 'Catalyst::View::TT';

__PACKAGE__->config(
	render_die => 1,
	# Change default TT extension
    TEMPLATE_EXTENSION => '.tt2',
    # Set the location for TT files
    INCLUDE_PATH => [
    	Gmatchbox->path_to( 'root' ),
    	],
);

=head1 NAME

Gmatchbox::View::HTML - TT View for Gmatchbox

=head1 DESCRIPTION

TT View for Gmatchbox.

=head1 SEE ALSO

L<Gmatchbox>

=head1 AUTHOR

Ben Hitz

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
