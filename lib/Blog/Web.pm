package  Blog::Web;
use strict;
use warnings;

use parent qw(Blog Chiffon::Web);

__PACKAGE__->set_use_modules(
    request    => 'Blog::Web::Request',
    response   => 'Blog::Web::Response',
    router     => 'Blog::Web::Router',
    view       => 'Chiffon::View::Xslate',
);

1;

