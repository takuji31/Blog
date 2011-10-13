package  Blog::Web::Controller::Admin;
use strict;
use warnings;

use parent 'Chiffon::Web::Controller';

__PACKAGE__->add_trigger(
    before_action => sub {
        my ($class, $c) = @_;
        return if $c->controller eq 'Oauth';
        my $login = $c->session->get('login');
        unless ( $login ) {
            $c->redirect('/oauth/');
        }
    }
);

1;

