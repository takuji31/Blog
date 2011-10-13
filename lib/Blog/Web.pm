package  Blog::Web;
use strict;
use warnings;

use parent qw(Blog Chiffon::Web);

use Chiffon::Plugin::Web::Session;

__PACKAGE__->set_use_modules(
    request    => 'Blog::Web::Request',
    response   => 'Blog::Web::Response',
    router     => 'Blog::Web::Router',
    view       => 'Chiffon::View::Xslate',
);

__PACKAGE__->set_prefix_map(
    Admin => qr/^admin\./,
);


1;

