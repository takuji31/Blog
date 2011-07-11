use strict;
use warnings;

use Blog::Web;
use Plack::Builder;

my $home = Blog::Web->base_dir;
builder {
    enable 'Static',
        path => qr{^/(img/|js/|css/|favicon\.ico)},
        root => $home->file('assets/htdocs')->stringify;
    enable 'StackTrace';
    enable 'Session';
    Blog::Web->app;
};

