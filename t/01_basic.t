use strict;
use warnings;
use utf8;
use Config qw(%Config);
use File::Spec;
use File::Temp qw(tempdir);
use FindBin qw($Bin);
use Test::More;

my $amon2_setup = sub {
    for my $bin ($Config{bin}, $Config{sitebin}, File::Spec->path) {
        my $try = File::Spec->catfile($bin, "amon2-setup.pl");
        return $try if -x $try && !-d $try;
    }
    return;
}->();

plan skip_all => "Cannot find amon2-setup.pl" unless $amon2_setup;
plan skip_all => "Cannot find blib dir"       unless -d "blib";

my $tempdir = tempdir CLEANUP => 1;

chdir $tempdir;

my $ok = !system "$^X -I$Bin/../blib/lib $amon2_setup --flavor=mine MyApp";
ok $ok;
ok -d "MyApp";
ok -f "MyApp/lib/MyApp.pm";
chdir "/";

done_testing;
