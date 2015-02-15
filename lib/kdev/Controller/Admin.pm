package kdev::Controller::Admin;
use Moose;
use namespace::autoclean;
use Data::Dumper;

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

sub admin :Chained('/') :PathPart('admin') :CaptureArgs(0) {
	my ($self, $c) = @_;
	
	if($c->user->role != 0) {
		$c->res->redirect($c->uri_for('/blog/home', { mid => $c->set_status_msg("You don't have the required permissions. Good try though.") } ));
		$c->detach();
	}
	$c->load_status_msgs;
	$c->stash( wrapper => 'article/article_wrap.tt' ); 
} 


sub userslist :Chained('admin') :PathPart('users_list') :Args(0) {
    my ($self, $c) = @_;
   
    #my @userdata = $c->model('DB')->resultset('User')->all; 

    $c->log->debug("\n fetching list of users") if $debug;

    $c->stash(users => [$c->model('DB::User')->all], template=> 'userslist.tt', rightpanel => 'rightpanel.tt');

}

sub delete_user:Chained('admin') :PathPart('delete_user') :Args(1) {
	my ($self, $c, $user_id) = @_;
	
	$c->log->debug("\n call to delete user - $user_id") if $debug;
	if(!defined($user_id)) {
		warn "\n undefined id";
	}
	
	#TODO - move this to an AJAX post call!
	$c->forward('/userbase/getuserdata',$user_id);
	$c->log->debug("\n Deletig user - $user_id") if $debug;
	$c->stash->{profile}->delete;
	
	#redirect back to users list
	$c->res->redirect($c->uri_for('users_list', {status_msg => 'User account deleted.'}));
	$c->detach();	 	
}

sub mailer :Chained('admin') :PathPart('mailer') :Args(0)  {
	my ($self, $c) = @_;
	
	my $users = [$c->model('DB::User')->all] ;
	
	$c->stash( template => 'mailer.tt', users => $users );
}
	


sub send_email :Chained('admin') :PathPart('send_email') :Args(0) {
	my ($self, $c) = @_;
	
	my $user_ids = $c->request->params->{user_id};
	
	if( ref($user_ids) ne "ARRAY" ) {
		$user_ids = [ $user_ids ];
	}
	
	$c->log->debug('sending mail to :'.Dumper($user_ids));
	
	my $users_list = [$c->model('DB::User')->search( { id => { '-in' => $user_ids } } )->all()];
	
	#error handling is done inside send_mail
	#encountered some issues when i passed template as a parameter along with users
	#need to look in to it later
	$c->stash( email_template => 'email_test.tt', email_subject => 'Dev Test Email' );
	my $mid = $c->forward('send_mail_now', $users_list);
	
	$c->res->redirect($c->uri_for('/admin/mailer', { mid => $mid }));

}

sub send_mail_now :private :args(1) {
	my ( $self, $c, @users_list ) = @_;
	
	my ($to, $from, $cc, $bcc, $mid);
	
	#print STDERR "\n dumping users list --- ".Dumper(@users_list)." :: $template";
	
	#check why bcc is not working.	
	$from = 'noreply@ksankar.in';
	$bcc = 'kailash.sankar@outlook.com';
	$cc = 'dev@ksankar.in';

	#mail content must never have the 'wrapper' (-.-) 
	#it would be good to create another view with nowrap
	#and set it as default for mailer 
	$c->stash( no_wrapper => 1 ); 

	foreach (@users_list) {	
		
		$to = $_->email;
	
		$c->stash->{email_send} = {
			from        =>  $from,	
			to          =>  $to,
			cc 			=>  $cc, 
			bcc         =>  $bcc,
			subject     =>  $c->stash->{email_subject},  
			template    =>  $c->stash->{email_template},
		#	body => '<br><br> <span>Test Email</span> <br><br> ksankar',
			content_type => 'text/html', 
			charset         => 'utf-8',
            encoding        => 'quoted-printable',
		};
	
		#TODO: The whole dev sever crahsed when the mail server didn't respond. The eval is to prevent that from happening.
		# if the remote server doesn't respond eval will catch it and throw and error.
		eval {
			$c->forward($c->view('Email::Template'));
		};
		
		if($@) {  
			$c->log->debug("Mail server is not responding..."); 
			$mid = $c->set_status_msg("Mail server is not responding."); 
			last;
		}
		
		$c->log->debug('mailing - '.$_->email);
	}	
	
			
	unless( $@ && @users_list ) {
		if (not scalar @{$c->error}) {
			$c->log->debug("=== Email sent!");	
			$mid = $c->set_status_msg("Mail Sent!");
		}
		else {
			$c->log->debug("=== Mailing error!");
			$mid = $c->set_status_msg("Could not send mail.");
		}	
	}
	
	#re enable the wrapper
	$c->stash( no_wrapper => 0 ); 
	return $mid;
}

sub drafts :Chained('admin') :Local :Args(0) {
	my ( $self, $c ) = @_;
	
	my $posts;
	
	#this can be used if user wants to see all posts in one page	
	$posts = [$c->model("DB::Article")->search( { draft => 1 }, {			
		'+select' => [ { count => 'comment', -as => 'no_of_comments' } ],
		'+as' => [ qw/ comment_count / ], 		
		join => 'comments', 
		group_by => [qw/me.id author_id title content created_on updated_on /],
		order_by => 'created_on DESC',				 		 
		 } )->all()];
	 	 			 
	#using accessor $posts->[0]->get_column('comment_count')
	$c->log->debug("Loading up drafts page");
		 
	$c->stash( template => 'article/content.tt', posts => $posts );
	
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
