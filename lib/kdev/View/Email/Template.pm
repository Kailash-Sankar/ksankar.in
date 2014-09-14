package kdev::View::Email::Template;

use strict;
use base 'Catalyst::View::Email::Template';

__PACKAGE__->config(

    #configurations are in local conf file
    template_prefix =>  'email',
    stash_key       =>  'email_send',
    default	    =>  { view => 'HTML' },
);

=head1 NAME

kdev::View::Email::Template - Templated Email View for kdev

=head1 DESCRIPTION

View for sending template-generated email from kdev. 

=head1 AUTHOR

root

=head1 SEE ALSO

L<kdev>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
