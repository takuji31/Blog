package  Blog::Web::C::Admin::Oauth;
use strict;
use warnings;

use parent qw/ Blog::Web::Controller /;

use Config::Pit;
use JSON;
use OAuth::Lite::Consumer;
use URI;

sub oauth_conf {pit_get('blog', require => { consumer_key => 'Twitter consumer key', consumer_secret => 'Twitter consumer secret', screen_name => 'My Twitter screen name' })}

sub get_consumer {
    my ( $class, $c ) = @_;
    my $callback = URI->new(join '','http://',$c->req->uri->host,'/oauth/callback');
    my $oauth_conf = oauth_conf();
    my $consumer = OAuth::Lite::Consumer->new(
        consumer_key => $oauth_conf->{consumer_key},
        consumer_secret => $oauth_conf->{consumer_secret},
        request_token_path => 'http://twitter.com/oauth/request_token',
        access_token_path  => 'http://twitter.com/oauth/access_token',
        authorize_path     => 'http://twitter.com/oauth/authenticate',
        callback_url => $callback->as_string,
    );
    return $consumer;
}

sub do_index {
    my ( $class, $c ) = @_;

    my $consumer = $class->get_consumer($c);
    my $request_token = $consumer->get_request_token();

    my $uri = URI->new($consumer->{authorize_path});
    $uri->query(
        $consumer->gen_auth_query("GET", 'http://twitter.com', $request_token)
    );

    $c->redirect($uri->as_string);
}

sub do_callback {
   my ( $class, $c ) = @_;

    my $consumer = $class->get_consumer($c);
    my $oauth_token    = $c->req->param('oauth_token');
    my $oauth_verifier = $c->req->param('oauth_verifier');

    my $access_token = $consumer->get_access_token(
        token    => $oauth_token,
        verifier => $oauth_verifier,
    );
    unless ($access_token) {
        $c->redirect('/oauth/failure');
    }
    my $res = $consumer->request(
        method => 'GET',
        url    => 'http://api.twitter.com/1/account/verify_credentials.json',
        token  => $access_token,
        params => {
            token => $access_token,
        },
    );
    unless ($res->is_success) {
        die "Authorization error!";
    }
    my $content = $res->decoded_content;
    my $json = decode_json($content);

    my $id = $json->{id};
    Carp::croak("Can't get Twitter id!") unless defined $id;

    unless ( $json->{screen_name} eq oauth_conf()->{screen_name} ) {
        die "You can't access this site!";
    }

    $c->session->set('login', 1);
    my $token = $access_token->token;
    my $token_secret = $access_token->secret;
    $c->session->set('twitter', {
        screen_name  => $json->{screen_name},
        token        => $token,
        token_secret => $token_secret,
    });
    $c->redirect('/');
}

1;

