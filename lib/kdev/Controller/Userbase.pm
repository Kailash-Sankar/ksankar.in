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

sub myprofile :Local :Args(0) {
	my ($self, $c, $user_id) = @_;
	
	$c->log->debug('fetching profile');
	
	#need to check why dob is not coming as part of user.
	my $profile = $c->model('DB::User')->find($c->user->id);
	
	$c->load_status_msgs;
	$c->stash( wrapper => 'article/article_wrap.tt', blogindex => 'article/blogindex.tt');			
	$c->stash(template => 'profile.tt', profile => $profile, activetag => 2 );
}

sub updateprofile : Local : Args(0) {
    my ( $self, $c ) = @_;
	
	
	##Retrieve values from the form
    my $firstname 	     = $c->request->params->{reg_firstname};
    my $lastname 	     = $c->request->params->{reg_lastname};
    my $dob 		     = $c->request->params->{reg_dob};
    my $password 	     = $c->request->params->{reg_password};
    my $confirm_password = $c->request->params->{reg_confirmpassword};
    my $old_password 	 = $c->request->params->{reg_oldpassword};
    
    $c->log->debug("about to update");
    
    $c->user->update({
					firstname => $firstname,
					lastname  => $lastname, 
					dob 	  =>  $dob,
    });
    
    if($old_password) {
		$c->log->debug("\n inside old pass ");
			    
		if($old_password eq $c->user->password) {
			$c->log->debug("\n pass check pass");
			if( $confirm_password eq $password ) {
				  $c->user->update({
					password => $password,
				});
			}
			else {
				$c->log->debug("\n passwords do not match ");
				$c->res->redirect($c->uri_for('/userbase/myprofile', { mid => $c->set_status_msg("Passwords do not match.") } ));
				$c->detach();
			}
		}
		else {
			$c->log->debug("\n old pass is wrong ");
			$c->res->redirect($c->uri_for('/userbase/myprofile', { mid => $c->set_status_msg("Old password is wrong.") } ));
			$c->detach();	
		}
	}
	
	$c->res->redirect($c->uri_for('/userbase/myprofile', { mid => $c->set_status_msg("Profile Updated!") } ));
	$c->detach();
}

sub addcomment: Path : Args(0) {
	my ( $self, $c) = @_;
	
	my $article_id = $c->request->params->{article_id};
	my $comment    = $c->request->params->{comment};
	
	
	$c->model('DB::Comment')->create( {
				comment 	=> $comment,
				article_id 	=> $article_id,
				user_id     => $c->user->id,		
	});
	
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
