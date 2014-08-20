package kdev::Controller::Admin;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

kdev::Controller::Admin - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut
my $debug=1;

#TODO remove this page later
sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched kdev::Controller::Admin in Admin.');
}

#TODO move to admin controller
sub userslist :Path('/admin/users_list') :Args(0) {
    my ($self, $c) = @_;
   
    #my @userdata = $c->model('DB')->resultset('User')->all; 

    $c->log->debug("\n fetching list of users") if $debug;

    $c->stash(users => [$c->model('DB::User')->all], template=> 'userslist.tt', rightpanel => 'rightpanel.tt');

}

sub delete_user: Local : Args(1) {
	my ($self, $c, $user_id) = @_;
	
	$c->log->debug("\n call to delete user - $user_id") if $debug;
	if(!defined($user_id)) {
		warn "\n undefined id";
	}
	
	#TODO - Authenticate the admin session before deleting
	$c->forward('/userbase/getuserdata',$user_id);
	$c->log->debug("\n Deletig user - $user_id") if $debug;
	$c->stash->{profile}->delete;
	
	#redirect back to users list
	$c->res->redirect($c->uri_for('users_list', {status_msg => 'User account deleted.'}));
	$c->detach();	 	
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
