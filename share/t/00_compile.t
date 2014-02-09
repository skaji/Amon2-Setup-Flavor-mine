use strict;
use warnings;
use Test::More;
use File::Find qw(find);

my @module;
find sub {
    my $name = $File::Find::name;
    return unless -f;
    return unless $name =~ s/\.pm$//;
    $name =~ s{lib/}{};
    $name =~ s{/}{::}g;
    push @module, $name;
}, qw(lib);

use_ok $_ for sort @module;

ok system("$^X -wc script/<?= $arg->{httpd} ?>") == 0;

done_testing;
