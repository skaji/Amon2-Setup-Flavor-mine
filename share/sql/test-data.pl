#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use <?= $arg->{module} ?>;
use Data::Section::Simple;

my @table = qw(user item);

my $data = Data::Section::Simple->new;

my $c = <?= $arg->{module} ?>->bootstrap;
if ( (my $mode = $c->mode_name) eq 'production' ) {
    die "ERROR do not run in production mode.\n";
} else {
    warn "runing in $mode...\n";
}

my $db = $c->db;

for my $table (@table) {
    my ($column, @row) = split /\n/, $data->get_data_section($table);
    my @column = split /,/, $column;

    warn "inserting to $table...\n";
    do {
        my $txn = $db->txn_scope;
        for my $row (@row) {
            next if $row =~ /^\s*#/;
            next if $row =~ /^\s+$/;
            my @value = split /,/, $row;
            $db->insert( $table => {
                map { $column[$_] => $value[$_] } 0..$#column
            } );
        }
        $txn->commit;
    };
}
warn "done.\n";

__DATA__

@@ user
id,name
1,john

@@ item
user_id,name,created_at,updated_at
1,goods,1391956660,1391956660

