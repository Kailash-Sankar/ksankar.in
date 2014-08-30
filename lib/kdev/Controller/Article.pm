package kdev::Controller::Article;
use Moose;
use namespace::autoclean;
use Data::Dumper;
use DateTime;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

kdev::Controller::Article - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut


sub blog :Chained('/') :PathPart('blog') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	
	$c->load_status_msgs;
	$c->stash( wrapper => 'article/article_wrap.tt', blogindex => 'article/blogindex.tt');
}

sub home :Chained('blog') :PathPart('home') :Args(0) {
    my ( $self, $c ) = @_;
	my ($posts);
	
	$posts = [$c->model("DB::Article")->search({}, {order_by => 'created_on DESC'} )->all()];
	$c->stash( template => 'article/content.tt', posts => $posts, activetag => 1 );
}

sub view :Chained('blog') :PathPart('view') : Args(1) {
	my ( $self, $c, $id ) = @_;
	my ( $article, $comments);
	
	#todo fetch comments and no of likes
	$c->log->debug("viewing full post");
	$article = [$c->model('DB::Article')->find($id)]->[0];
	
	$comments = [$c->model('DB::Comment')->search({article_id => $id}, {order_by => 'added_on DESC'} )->all()];
	
	$c->stash( template => 'article/viewpost.tt', article => $article, comments => $comments );	
}

sub addnew :Chained('blog') :PathPart('addnew') : Args(0) {
	my ( $self, $c ) = @_;
	
	$c->stash( template => 'article/addnew.tt', action => '/blog/save' );	
}

sub edit :Chained('blog') :PathPart('edit') : Args(1) {
	my ( $self, $c, $id ) = @_;
	my $article;
	
	$c->log->debug("you have to get some sleep");
	$article = [$c->model('DB::Article')->find($id)]->[0];
	$c->stash( template => 'article/addnew.tt', action => '/blog/update', article => $article );	
}

sub save: Path('/blog/save') : Args(0) {
	my ( $self, $c ) = @_;
	my ( $title, $content, $author, $newentry, $created_on);
	
	if($c->user->role != 0) {
		$c->res->redirect($c->uri_for('/blog/home', { mid => $c->set_status_msg("You don't have the required permissions. Good try.") } ));
		$c->detach();
	}
	
	$title 	    = $c->request->params->{title};
	$content    = $c->request->params->{content};
	$created_on = $c->request->params->{createdon};
	$author 	= $c->user();
	
	$c->log->debug("current time"+$created_on);
	#$created_on = DateTime->now;
	
	$newentry = $c->model('DB::Article')->create( {
					author_id => $author->id,
					title 	  => $title,
					content   => $content,
					created_on => $created_on			
	});
	
	$c->res->redirect($c->uri_for('/blog/home', { mid => $c->set_status_msg("Post successfully added!") } ));
    $c->detach();
}

sub update: Path('/blog/update') : Args(0) {
	my ( $self, $c ) = @_;
	my ( $title, $content, $author, $id, $newentry);
	
	if($c->user->role != 0) {
		$c->res->redirect($c->uri_for('/blog/home', { mid => $c->set_status_msg("You don't have the required permissions. Good try.") } ));
		$c->detach();
	}
	
	$id 	    = $c->request->params->{id};
	$title 	    = $c->request->params->{title};
	$content    = $c->request->params->{content};
	#$author		= $c->user();
	
	$c->log->debug("author : ".Dumper($author));
	#$created_on = DateTime->now;
	
	$newentry = $c->model('DB::Article')->find($id)->update( {
					title 	  => $title,
					content   => $content,
	});
	
	$c->res->redirect($c->uri_for('/blog/home', { mid => $c->set_status_msg("Post successfully updated!")}));
    $c->detach();
}

sub addcomment: Path('/blog/addcomment') : Args(1) {
	my ( $self, $c, $article_id ) = @_;
	
	my $comment 	    = $c->request->params->{comment};
	
	$c->model('DB::Comment')->create({
			comment    => $comment,
			article_id => $article_id,
			user_id    => $c->user->id
	});
		
	$c->res->redirect($c->uri_for('/blog/view',$article_id, { mid => $c->set_status_msg("Post successfully updated!")}));
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
