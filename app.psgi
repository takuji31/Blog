use strict;
use warnings;

use Blog::Web;
use Plack::Builder;
use Plack::Session::Store::Cache::KyotoTycoon;

my $home = Blog::Web->base_dir;
builder {
    enable 'Static',
        path => qr{^/(img/|js/|css/|favicon\.ico)},
        root => $home->file('assets/htdocs')->stringify;
    enable 'StackTrace';
    enable 'Session',
        store => Plack::Session::Store::Cache::KyotoTycoon->new;
    Blog::Web->app;
};

