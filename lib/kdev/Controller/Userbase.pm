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

#all functions in here required user to be logged in :)

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
  
    $c->log->debug("\n user session -".Dumper($c->user())) if $debug;

    $c->stash(rightpanel => 'rightpanel.tt', template => 'userbase.tt');
}


#get user data and keep it in stash (this function is now only used by admin for delete feature)
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

#view user profile
sub myprofile :Local :Args(0) {
	my ($self, $c, $user_id) = @_;
	
	$c->log->debug('fetching profile');
	
	#need to check why dob is not coming as part of user.
	#i think it's because the data held in session is minimal.
	my $profile = $c->model('DB::User')->find($c->user->id);
	
	 my $pagedetails = { activetag => 2 }; 
	
	$c->load_status_msgs;
	$c->stash( wrapper => 'article/article_wrap.tt', blogindex => 'article/blogindex.tt');			
	$c->stash(template => 'profile.tt', profile => $profile, pgd => $pagedetails );
}

#update user profile
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

#add new comment
sub addcomment: Path('/blog/addcomment') : Args(1) {
	my ( $self, $c, $article_id ) = @_;
	
	my $comment 	    = $c->request->params->{comment};
	
	if ($comment) {
		$c->model('DB::Comment')->create({
			comment    => $comment,
			article_id => $article_id,
			user_id    => $c->user->id
		});
	}
	$c->res->redirect($c->uri_for('/blog/view',$article_id, { mid => $c->set_status_msg("Comment added successfully!")}));
    $c->detach();
	
}

#add new post - has to be moved to the admin controller later
sub save: Path('/blog/save') : Args(0) {
	my ( $self, $c ) = @_;
	my ( $title, $content, $author, $newentry, $created_on, $tag, $draft);
	
	if($c->user->role != 0) {
		$c->res->redirect($c->uri_for('/blog/home', { mid => $c->set_status_msg("You don't have the required permissions. Good try.") } ));
		$c->detach();
	}
	
	$title 	    = $c->request->params->{title};
	$content    = $c->request->params->{content};
	$created_on = $c->request->params->{createdon};
	$tag 		= $c->request->params->{tags};
	$author 	= $c->user();
	$draft		= $c->request->params->{draft} ? 1 : 0;	
	
	
	
	$c->log->debug("Saving new post at ".$created_on." with tag ".$tag);
	#$created_on = DateTime->now;
	
	$newentry = $c->model('DB::Article')->create( {
					author_id  => $author->id,
					title 	   => $title,
					content    => $content,
					created_on => $created_on,			
					draft	   => $draft,	
	});
	
	if ($newentry) {
		#handle multiple tags. 
		#ToDo find a better logic
		if( ref($tag) eq "ARRAY" ) {
			
			foreach (@$tag) {
			
				$c->model('DB::Tagmap')->create({
					article_id => $newentry->id,
					tag_id	   => $_
				});
			}
		}
		
		else {
			
			$c->model('DB::Tagmap')->create({
				article_id => $newentry->id,
				tag_id	   => $tag
			});
			
			
		}
	}
	
	$c->res->redirect($c->uri_for('/blog/home', { mid => $c->set_status_msg("Post successfully added!") } ));
    $c->detach();
}

#edit post - has to moved to admin controller later
sub update: Path('/blog/update') : Args(0) {
	my ( $self, $c ) = @_;
	my ( $title, $content, $author, $id, $newentry, $draft);
	
	if($c->user->role != 0) {
		$c->res->redirect($c->uri_for('/blog/home', { mid => $c->set_status_msg("You don't have the required permissions. Good try.") } ));
		$c->detach();
	}
	
	$id 	    = $c->request->params->{id};
	$title 	    = $c->request->params->{title};
	$content    = $c->request->params->{content};
	$draft      = $c->request->params->{draft} ? 1 : 0;
	#$author		= $c->user();
	
	$c->log->debug("author : ".Dumper($author));
	#$created_on = DateTime->now;
	
	$newentry = $c->model('DB::Article')->find($id)->update( {
					title 	  => $title,
					content   => $content,
					draft     => $draft,
	});
	
	$c->res->redirect($c->uri_for('/blog/home', { mid => $c->set_status_msg("Post successfully updated!")}));
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
