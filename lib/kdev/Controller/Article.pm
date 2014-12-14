package kdev::Controller::Article;
use Moose;
use namespace::autoclean;
use Data::Dumper;

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
	
	$c->log->debug("blog base - loading tags");
	
	$c->load_status_msgs;
	my $tags = [ $c->model('DB::Tag')->all ];
	
	$c->stash( wrapper => 'article/article_wrap.tt', blogindex => 'article/blogindex.tt', tags => $tags);
}

#home sweet home.
sub home :Chained('blog') :PathPart('home') :Args(0) {
    my ( $self, $c ) = @_;

	#  testing the numerous possibilites of code that i am yet to explore.
	#my $ksan = $c->model('ResultSet::Article');
	#$ksan->get_article_details();

	$c->log->debug("blog home");

	#redirect to pagination function with page as 1
	$c->stash({ activepage => 1 });
	$c->forward('/article/pagination');
	$c->detach();
		
=head 
#this can be used if user wants to see all posts in one page	
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
=cut
	
}

sub pager :Chained('blog') :PathPart('home/page') :Args(1) {
	my ($self, $c, $page) = @_;
	
	$c->stash({ activepage => $page });
	$c->forward('/article/pagination');
	$c->detach();
}	


#pagination supreme. 
#each page will have 5 posts.
sub pagination :Private {
	my ($self, $c) = @_;
	
	my $page = $c->stash->{activepage};
	my $posts;
	
	#get all the post ids
	my @nop = $c->model("DB::Article")->search( { 'draft' => 0 }, { 'select' =>['id'] , order_by => 'created_on DESC'})->get_column('id')->all();
	
	$c->log->debug('fetching articles'.Dumper(\@nop));
	
	#now to fetch the posts based on page
	if( $page ) {
		
		#calculate index based on page
		my $index = (5 * $page) - 1; 
		my $start_id = $index - 4;
		my $end_id = ( $index  < (scalar @nop - 1) )? $index : (scalar @nop - 1) ;
		
		$c->log->debug("Start id: $start_id , End_id : $end_id");
	
		#list of ids to fetch
		my @ids = @nop[$start_id .. $end_id];
		
		$c->log->debug("fetching posts for page: $page ID's: ".Dumper(\@ids));
		
		#fetch details of the post with count of comments
		$posts = [$c->model("DB::Article")->search( 
			{ 
				'me.id' => { -in => \@ids }		
			},
			{			
			'+select' => [ { count => 'comment', -as => 'no_of_comments' } ],
			'+as' => [ qw/ comment_count / ], 		
			join => 'comments', 
			group_by => [qw/me.id author_id title content created_on updated_on /],
			order_by => 'created_on DESC',				 		 
			})->all()];
	
    }
    
    #total no of comments was including draft comments. Fixed with join. Is it worth the db join cost?
    my $nofcom =  $c->model("DB::Comment")->search( { 'article.draft' => 0 } , { 'select' => ['id'], join => 'article' })->count;
    
    $c->log->debug("Total Posts: ".scalar @nop." , Total Comments: $nofcom");
    
    my $pagedetails = { activetag => 1, 
						nop => (scalar @nop)/ 5,
						activepage => $page, 
					    nofcom => $nofcom,
					    nofpos => scalar @nop,
					  };
	
	$c->stash( template => 'article/content.tt' , posts => $posts, pgd => $pagedetails );
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
	
	my $pagedetails = { activetag => 5, searchid => $tag_id };
	
	$c->stash( template => 'article/content.tt', posts => $posts, pgd => $pagedetails );	 
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
