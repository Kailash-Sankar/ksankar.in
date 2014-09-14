package kdev::Controller::Root;
use Moose;
use namespace::autoclean;
use Data::Dumper;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=encoding utf-8

=head1 NAME

kdev::Controller::Root - Root Controller for kdev

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut
#enable for debugging
my $debug=0;

#TODO remove later/replace with home
sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    # Hello World
    #$c->response->body( $c->welcome_message );
    
    $c->stash(no_wrapper => 1 ,  template => 'index.html');
}

sub chottu :Path('/rakesh/sindhu/nichu') :Args(0) {
    my ( $self, $c ) = @_;

    # Hello World
    #$c->response->body( $c->welcome_message );
    
    $c->stash(no_wrapper => 1 ,  template => 'aniv.html');
}

sub placeboeffect :Path('/placeboeffect') :Args(0) {
    my ($self, $c) = @_;
   
    my $rightpanel = 'simplelogin.tt'; 
    
    if ($c->user_exists) {
		$rightpanel = 'rightpanel.tt';
	}
    
    $c->stash(template => 'welcome.tt', rightpanel => $rightpanel, wrapper => 'wrapper.tt');

}

#epicenter theme
sub epicenter : Path('/epicenter'): Args(0) {
	my ($self, $c) = @_;
	
	$c->stash( wrapper => 'newhome.tt', rightpanel => 'login.tt', template => 'welcome.tt');
}

sub auto: Private {
	my ($self, $c) = @_;
	
	# rightpanel.tt is used for placebo effect theme
	my $panel = 'article/profilepane.tt';
	
	#user session found
	if ($c->user_exists) {
		if( $c->controller eq $c->controller('Article') ) {
			$panel = 'article/profilepane.tt'; 
		}		
		$c->stash( profile => $c->user(), leftpanel => $panel);
	}
		
	#Actions in Root do not require login
	if( ! ( ($c->controller eq $c->controller('Userbase')) || ($c->controller eq $c->controller('Admin')) ) ) {
	return 1;
    }
   
    #if user session is not found redirect to home   
    if(!$c->user_exists) {
		$c->log->debug("\n Root: Session not found");
		$c->response->redirect($c->uri_for('/'));
		return 0;
	}
    
    return 1;
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

root

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
