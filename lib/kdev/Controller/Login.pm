package kdev::Controller::Login;
use Moose;
use namespace::autoclean;
use Data::Dumper;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

kdev::Controller::Login - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut
 
sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    
    my $username = $c->request->params->{username};
    my $password = $c->request->params->{password};
    
    #$c->response->redirect($c->uri_for('/userbase'));
    
    if ($username & $password) {
		#Attempt to login
		if ($c->authenticate({username => $username, password => $password })) {
			#if success then redirect to profile page
			$c->response->redirect($c->uri_for('/blog/home', { mid => $c->set_status_msg("Login Successfull! :)") } ));
			return;
		} else {
			$c->flash->{login_error} = 'Bad username or password.';
		}
	} else {
		$c->flash->{login_error} = 'Empty username or password.'; #unless ($c->user_exists);
	}
	
	#$c->log->debug("\n user session -".Dumper($c->user()));
	if ($c->user_exists) {
		$c->response->redirect($c->uri_for('/blog/home', { mid => $c->set_status_msg("Your session already exists :)")} ));
	}
	
	##if login failed, return to same page
	$c->response->redirect($c->uri_for('/blog/home'));
   
}

sub logout : Global : Args(0) {
	my($self, $c) = @_;
	
	$c->logout;
	
	$c->response->redirect($c->uri_for('/blog/home', { mid => $c->set_status_msg("You have been Logged out! :)") } ));
	
}

#matches to /register
#TODO server side validation & error handling

sub register : Global :Args(0) {
    my ( $self, $c ) = @_;
	
	
	##Retrieve values from the form
    my $firstname 	     = $c->request->params->{reg_firstname};
    my $lastname 	     = $c->request->params->{reg_lastname};
    my $dob 		     = $c->request->params->{reg_dd}.'-'.$c->request->params->{reg_mm}.'-'.$c->request->params->{reg_yyyy};
    my $email 	   	     = $c->request->params->{reg_email};
    my $confirm_email	 = $c->request->params->{reg_confirmemail};
    my $username		 = $c->request->params->{reg_username};
    my $password 	     = $c->request->params->{reg_password};
    my $confirm_password = $c->request->params->{reg_confirmpassword};
    my $rec_code		 = $c->request->params->{reg_secque};
   
    warn "\n proceeding to registration";  
      
    if ($email ne $confirm_email) {
		 warn "\n emails id's are not matching"; 
		 c->flash->{reg_error} = 'Emails are not matching. :(';
		 $c->res->redirect($c->uri_for('/blog/home'));
		 $c->detach();
	}
    if($password ne $confirm_password) { 
		warn "\n passwords do not match";
		c->flash->{reg_error} = 'Passwords do not match. :(';
		 $c->res->redirect($c->uri_for('/blog/home'));
		 $c->detach();
	}
    
    my $newuser = $c->model('DB::User')->create({ 
						firstname => $firstname,
						lastname  => $lastname,
						dob 	  => $dob,
						email	  => $email,
						username  => $username,
						password  => $password,
						active    => 1,						 
	   });
    
     #add user data to stash and forward to my profile page
     #$c->stash( profile => $newuser, status_msg => 'You have successfully registered!'); 
     #$c->detach('myprofile',$newuser->id);
     
     #Authenticate user session
     if ( $c->authenticate({username => $username, password => $password}) ) {
		 
          $c->res->redirect($c->uri_for('/blog/home', { mid => $c->set_status_msg("You have successfully registered!")}));
          $c->detach();
      } else {
		  $c->log->debug("\nI didnt expect the code to come here");
		  $c->res->redirect($c->uri_for('/blog/home', { mid => $c->set_status_msg("Sever is in a bad moood. Please try again later.")} ));
	  }

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
