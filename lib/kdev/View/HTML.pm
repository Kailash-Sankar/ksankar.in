package kdev::View::HTML;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,

   #location of TT files
    INCLUDE_PATH => [ 
      kdev->path_to('root','templates'),
    ],

    #wrapper file
    WRAPPER => 'basewrapper.tt',

);


=head1 NAME

kdev::View::HTML - TT View for kdev

=head1 DESCRIPTION

TT View for kdev.

=head1 SEE ALSO

L<kdev>

=head1 AUTHOR

root

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
