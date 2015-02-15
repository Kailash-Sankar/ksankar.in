package kdev::Controller::Lab;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

kdev::Controller::Lab - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub lab_base : Chained('/') :PathPart('lab') :CaptureArgs(0) {
    my ( $self, $c ) = @_;

    $c->stash({ wrapper => 'lab/lab_wrap.tt'});
}

sub lab_main : Chained('lab_base') :PathPart('home') :Args(0) {
	my ( $self, $c ) = @_;	
	
	$c->stash({ template => 'lab/lab_main.tt'});
}

sub lab_bench : Chained('lab_base') :PathPart('bench') :Args(1) {
	my ( $self, $c, $exp ) = @_;	
	
	my $page = 'lab/content/' . $exp . '.tt';
	
	$c->stash({ template => 'lab/lab_bench.tt', exp => $page });
}

=encoding utf8

=head1 AUTHOR

root

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
