use strict;
use warnings;

use Blog;

my $home = Blog->base_dir;
return +{
    app_name => 'blog',
    view => {
        'Chiffon::View::Xslate' => +{
            path   => $home->file('assets/template')->stringify,
            cache     => 1,
            cache_dir => '/tmp/blog',
            syntax    => 'Kolon',
            type      => 'html',
            suffix    => '.html',
        },
    },
    datasource => +{
        master => +{
            dsn => 'dbi:mysql:blog;user=root',
        },
    },
    hostname => +{
    },
    plugins => +{
    },
};


