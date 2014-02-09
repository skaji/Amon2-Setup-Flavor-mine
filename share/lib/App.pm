package <?= $arg->{module} ?>;
use strict;
use warnings;
use utf8;
use 5.018;
use <?= $arg->{module} ?>::DB::Schema;
use <?= $arg->{module} ?>::DB;

use parent qw(Amon2);

# Enable project local mode.
__PACKAGE__->make_local_context();

sub mode_name {
    $ENV{PLACK_ENV} || 'development';
}

my $schema = <?= $arg->{module} ?>::DB::Schema->instance;

sub db {
    my $c = shift;
    if (!exists $c->{db}) {
        my $conf = $c->config->{DBI} or die "Missing configuration about DBI";

        my $on_connect_do = $conf->[0] =~ /mysql/i  ? ['SET SESSION sql_mode=STRICT_TRANS_TABLES;']
                          : $conf->[0] =~ /sqlite/i ? []
                          : die "ERROR support only mysql or sqlite";
        $c->{db} = <?= $arg->{module} ?>::DB->new(
            schema       => $schema,
            connect_info => [@$conf],
            on_connect_do => $on_connect_do,
        );
    }
    $c->{db};
}

1;
