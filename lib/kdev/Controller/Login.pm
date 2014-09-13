package kdev::Controller::Login;
use Moose;
use namespace::autoclean;
use Data::Dumper;
use DateTime;

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
    my $math		 = $c->request->params->{reg_math};
   
    warn "\n proceeding to registration";  
      
    if ($email ne $confirm_email) {
		 warn "\n emails id's are not matching"; 
		 $c->flash->{reg_error} = 'Emails are not matching. :(';
		 $c->res->redirect($c->uri_for('/blog/home'));
		 $c->detach();
	}
    if($password ne $confirm_password) { 
		warn "\n passwords do not match";
		 $c->flash->{reg_error} = 'Passwords do not match. :(';
		 $c->res->redirect($c->uri_for('/blog/home'));
		 $c->detach();
	}
    
    if($math != 29) { 
		warn "\n Hmmm..it's a bot!";
		 $c->flash->{reg_error} = 'Math error?..Hmm..what do we have here..(o.O)';
		 $c->res->redirect($c->uri_for('/blog/home'));
		 $c->detach();
	}
	
	my $username_exists = $c->model('DB::User')->search( { username => $username  } );
	
	if($username_exists != 0) {
		warn "\n username exists! $username_exists";
		$c->flash->{reg_error} = 'Username already exists, somebody beat you to it :p';
		$c->res->redirect($c->uri_for('/blog/home'));
		$c->detach();
	}
    
    my @newuser = $c->model('DB::User')->create({ 
						firstname => $firstname,
						lastname  => $lastname,
						dob 	  => $dob,
						email	  => $email,
						username  => $username,
						password  => $password,
						active    => 1,						 
	   });
    
	#time to sent dem mails :p
	#forward to private mailer in admin with user object
	if(@newuser) {
		$c->stash( email_template => 'email_welcome.tt' );
		my $mid = $c->forward('/admin/send_mail_now', \@newuser);
		unless($mid) { $c->log->debug('There was an error while trying to send mail'); }
	}	
    
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

sub forgot_password :Global :Args(0) {
	my ( $self, $c ) = @_;
	
	$c->stash( template => 'forgot_password.tt' , showform => 1 );
	
}

sub rec_password : Path('/forgot_password/rec_password') :Args(0) {
	my ( $self, $c ) = @_;
	
	#if all else fails , show the user the regular password recovery form
	#why put all data in one template? because i feel lazy about building more templates.
	my $formcode = 1;
	
	my $email = $c->request->params->{rec_email};
	
	my $email_exists = $c->model('DB::User')->search( { email => $email  } )->single;

	print STDERR "\n\n it's an array" if( ref($email_exists) eq 'ARRAY') ;

	if( $email_exists ) {
		$c->log->debug("Initiating Password Recovery for : $email");
		
		my $salt = DateTime->now();
		my $rec_hash = crypt($email,$salt);
		
		$c->log->debug("Created rec hash : $salt : $rec_hash :".$email_exists->id);
		
		#disable old records if any.
		my  $old_records = $c->model('DB::RecPass')->search({ user_id => $email_exists->id });
		if( $old_records) { $old_records->update({ active => 0 }); }
		
		my $recpass =   $c->model('DB::RecPass')->create ({
							user_id 	=> $email_exists->id,
							saltedhash  => $rec_hash,
							salt 		=> $salt,
						});
		
		
		if ( $recpass ) {
			
			#forward to mailer if the db entry was made
			# set email_template & rec_hash
			$c->stash( email_template => 'email_password.tt' , rec_hash => $rec_hash );
			my $mid = $c->forward('/admin/send_mail_now',[ $email_exists ]);
		
			if($mid) {
				$c->stash( status_msg => "Recovery email sent." );
				$formcode = 2;	
			}
			else {
				$c->stash( status_msg => "owwh nooo...there is a problem with the mail server. Please try again later. :(" );
				$formcode = 0;
			}
		}
		else {
		   	$c->stash( status_msg => "Our recovery Wizard's is asleep. Please try again later." ); 
		   	$formcode = 0;
		}
	}
			
	else {	
		$c->stash( status_msg => "Ouch, the entered email address doesn't exist in my system." );	
		$formcode = 0;
	}
	
	$c->stash( template => 'forgot_password.tt' , showform => $formcode );
}

sub set_new_password :Path('/forgot_password/set_new_password') :Args(1) {
	my  ( $self, $c, $rec_hash ) = @_;
	my $formcode = 1;
	
	#load status messages 
	$c->load_status_msgs;
	
	#Salted hash check
	my $recpass =   $c->model('DB::RecPass')->search({ saltedhash => $rec_hash, active => 1 })->single; 
	
	if( $recpass) {
		#allow them to reset password.
		#i need to make a new form...argh..but if i move the password change code in my profile to a private method
		#i might be able to achieve greatness.
		$c->log->debug('Allowing user to reset password: '.$recpass->user_id);
		$formcode = 3; 
		$c->stash( rec_hash => $rec_hash );
	}
	else {
		$c->stash( status_msg => "I have no record of this recovery attempt. Please try again." );
		$formcode = 4;
	}
	$c->stash( template => 'forgot_password.tt' , showform => $formcode );
} 

sub change_password :Path('/forgot_password/change_password') :Args(0) {
	my ( $self, $c ) = @_;
	my $mid;
	
	my $password 	     = $c->request->params->{reg_password};
    my $confirm_password = $c->request->params->{reg_confirmpassword};
    my $rec_hash		 = $c->request->params->{rec_hash};
    
    #fetch user
    my $recpass =   $c->model('DB::RecPass')->search({ saltedhash => $rec_hash, active => 1 })->single; 
    
    if( $password && $confirm_password ) {
		$c->log->debug("\n changing password ");
			    
		if( $confirm_password eq $password ) {
			my $pwd_update =	  $recpass->user->update({
									password => $password,
							   });
			if($pwd_update) { 
				#disable salt & redirect to home
				$recpass->update({ active => 0 });
				$c->res->redirect($c->uri_for('/blog/home', { mid => $c->set_status_msg("Password changed successfully. Please log in.") } ));
				$c->detach();
			}
			else {
				#attempt failed
				$mid = $c->set_status_msg("Update attempt failed. Please try again later.");			
			}	
		}	
		else {
				$c->log->debug("\n passwords do not match ");
				$mid = $c->set_status_msg("Passwords do not match.");
		}
	}
	else {
		$c->log->debug("\n Blank fields..");
		$mid = $c->set_status_msg("Opps you left blank fields in the form.");
	}
		
	$c->res->redirect($c->uri_for('/forgot_passsword/set_new_password/', $rec_hash, { mid => $mid } ));
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
