package  Blog::Web::C::Admin::User;
use strict;
use warnings;
use parent qw/ Blog::Web::Controller /;
use Blog::Container;
use Blog::DB;
use Time::Piece;

__PACKAGE__->add_trigger(
    before_action => sub {
        my ($class, $c) = @_;
        my $user = $c->user;
        $c->redirect('/') unless $user;
        my $action = $c->action;
        return if $action eq 'logout';
        my $authenticated =  $user->status eq 'authenticated';
        my $register      =  grep /^$action$/, qw(register register_do confirm);
        if ( ( $authenticated && !$register ) || ( !$authenticated && !$register ) ) {
            $c->redirect('/');
        }
    }
);

sub do_index {
    my ( $class, $c ) = @_;
}

sub do_logout {
    my ( $class, $c ) = @_;
    $c->session->remove('user_id');
    my $back_to = $c->req->param('back_to') || "http://@{$c->req->uri->host}/";
    my $uri = URI->new($back_to);
    my $redirect_uri = $uri->host eq $c->req->uri->host ? $uri->as_string : "http://@{$c->req->uri->host}/";
    $c->redirect($redirect_uri);
}

1;

