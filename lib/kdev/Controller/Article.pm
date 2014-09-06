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

#all functions in here can be accessed by user without logging in

sub blog :Chained('/') :PathPart('blog') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	
	$c->load_status_msgs;
	my $tags = my $tags = [ $c->model('DB::Tag')->all ];
	
	$c->stash( wrapper => 'article/article_wrap.tt', blogindex => 'article/blogindex.tt', tags => $tags);
}

sub home :Chained('blog') :PathPart('home') :Args(0) {
    my ( $self, $c ) = @_;
	my ($posts);
	
	$posts = [$c->model("DB::Article")->search(undef, {			
		'+select' => [ { count => 'comment', -as => 'no_of_comments' } ],
		'+as' => [ qw/ comment_count / ], 		
		join => 'comments', 
		group_by => [qw/me.id author_id title content created_on updated_on /],
		order_by => 'created_on DESC',				 		 
		 } )->all()];
		 
	#using accessor $posts->[0]->get_column('comment_count')
	$c->log->debug("Loading up home page.");
		 
	$c->stash( template => 'article/content.tt', posts => $posts, activetag => 1 );
}

sub view :Chained('blog') :PathPart('view') : Args(1) {
	my ( $self, $c, $id ) = @_;
	my ( $article, $comments);
	
	#todo fetch comments and no of likes
	$c->log->debug("viewing full post");
	$article = [$c->model('DB::Article')->find($id)]->[0];
	
	$comments = [$c->model('DB::Comment')->search({article_id => $id}, {order_by => 'added_on ASC'} )->all()];
	
	$c->stash( template => 'article/viewpost.tt', article => $article, comments => $comments, activetag => 4 );	
}

sub addnew :Chained('blog') :PathPart('addnew') : Args(0) {
	my ( $self, $c ) = @_;
	
	$c->stash( template => 'article/addnew.tt', action => '/blog/save', activetag => 3 );	
}

sub edit :Chained('blog') :PathPart('edit') : Args(1) {
	my ( $self, $c, $id ) = @_;
	my $article;
	
	$c->log->debug("you have to get some sleep");
	$article = [$c->model('DB::Article')->find($id)]->[0];
	$c->stash( template => 'article/addnew.tt', action => '/blog/update', article => $article );	
}

sub search_by_tags :Chained('blog') :PathPart('search') : Args(1) {
	my ( $self, $c, $tag_id ) = @_;
	
	
	my $posts = [$c->model("DB::Article")->search( 
		{  'tagmaps.tag_id' => $tag_id				
		},
	
		{	'+select' => [ { count => 'comment', -as => 'no_of_comments' } ],
			'+as' => [ qw/ comment_count / ], 		
			join => ['comments', 'tagmaps'], 
			group_by => [qw/me.id author_id title content created_on updated_on /],
			order_by => 'created_on DESC',				 		 
		 } )->all()];
	
	$c->stash( template => 'article/content.tt', posts => $posts, activetag => 5, searchid => $tag_id  );	 
}

=Active tag mapping
1 => Home
2 => My Profile
3 => Post
4 => View
5 => Search Results
=cut

=encoding utf8

=head1 AUTHOR

root

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
