package kdev::Controller::Userbase;
use Moose;
use namespace::autoclean;
use Data::Dumper;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

kdev::Controller::Userbase - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut
#debug flag
my $ debug=0;

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
  
    $c->log->debug("\n user session -".Dumper($c->user())) if $debug;

    $c->stash(rightpanel => 'rightpanel.tt', template => 'userbase.tt');
}


#get user data and keep it in stash
sub getuserdata : Local : Args(1) {
	my ($self, $c, $user_id)= @_;
    
    if ($user_id) {
		my $profile = $c->model('DB::User')->find($user_id);
		$c->stash( profile => $profile);
		$c->log->debug("\n user data stored in stash - $user_id") if $debug;
	}
	else {
		warn "\n undef user_id ";
	}
}   

sub myprofile: Local : Args(0) {
	my ($self, $c, $user_id) = @_;
	
	#if ($user_id) {
		#$c->forward('getuserdata',$user_id);
	#}
	##if there is no user id then call is coming from reg method		
	$c->stash(template => 'profile.tt');
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
