package Amon2::Setup::Flavor::mine;
use 5.014;
use strict;
use warnings;
use parent qw(Amon2::Setup::Flavor);
use File::Basename qw(fileparse);
use File::ShareDir qw(dist_dir);
use Path::Maker;
use Amon2::Util qw(random_string);

our $VERSION = "0.001";

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);
    my $share = dist_dir $class =~ s/::/-/gr;
    my $maker = Path::Maker->new(
        template_dir    => $share,
        template_header => "? my \$arg = shift;\n",
    );
    $self->{maker} = $maker;
    $self->{httpd} = lc( $self->{dist} . "-httpd" );
    $self->{random_string} = sub { random_string(@_) };
    $self->{db_name} = lc( $self->{dist} =~ s/-/_/gr );
    $self;
}

sub run {
    my $self = shift;
    my $maker = $self->{maker};

    $maker->render_to_file("script/httpd", "script/$self->{httpd}", $self);

    my @file = qw(
        README.md
        cpanfile _gitignore _rc
        db/_gitignore logs/_gitignore
    );
    push @file, map { "config/$_.pl" } qw(development production test);
    push @file, map { "sql/$_"       } qw(sqlite.sql mysql.sql test-data.pl);
    push @file, map { "tmpl/$_"      } qw(index.tx layout/main.tx);
    push @file, map { "t/$_"         } qw(
        00_compile.t 01_root.t 02_mech.t 03_assets.t 06_jshint.t
        Util.pm
    );
    push @file, map { "static/$_"    } qw(
        404.html 500.html 502.html 503.html 504.html
        css/main.css js/main.js
        img/_gitignore
    );

    for my $file (@file) {
        my ($basename, $dirname) = fileparse $file;
        $basename =~ s/^_/./;
        my $dest = "$dirname/$basename";
        $maker->render_to_file($file => $dest, $self);
    }

    my @pm = qw(
        App.pm
        App/DB.pm
        App/DB/Row.pm
        App/DB/Row/User.pm
        App/DB/Row/Item.pm
        App/DB/Schema.pm
        App/Web.pm
        App/Web/Dispatcher.pm
        App/Web/Plugin/Session.pm
        App/Web/View.pm
        App/Web/ViewFunctions.pm
    );
    for my $pm (@pm) {
        my $name = $pm =~ s/^App//r;
        my $dest = $self->{path} . $name;
        $maker->render_to_file("lib/$pm", "lib/$dest", $self);
    }
    symlink "../lib/$self->{path}/DB/Schema.pm" => "sql/Schema.pm";
    symlink "../lib/$self->{path}/DB/Row.pm"    => "sql/Row.pm";
    symlink "../lib/$self->{path}/DB/Row"       => "sql/Row";

    $self->write_assets;
}


1;
__END__

=for stopwords amon2

=encoding utf-8

=head1 NAME

Amon2::Setup::Flavor::mine - my amon2 application setup

=head1 SYNOPSIS

    > amon2-setup.pl --flavor=mine MyApp

=head1 SEE ALSO

L<Amon2::Setup::Flavor>

L<Amon2::Setup::Flavor::Basic>

=head1 LICENSE

Copyright (C) Shoichi Kaji.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Shoichi Kaji E<lt>skaji@outlook.comE<gt>

=cut

