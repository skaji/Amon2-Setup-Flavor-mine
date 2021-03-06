package <?= $arg->{module} ?>::Web;
use strict;
use warnings;
use utf8;
use parent qw/<?= $arg->{module} ?> Amon2::Web/;
use File::Spec;

# dispatcher
use <?= $arg->{module} ?>::Web::Dispatcher;
sub dispatch {
    return (<?= $arg->{module} ?>::Web::Dispatcher->dispatch($_[0]) or die "response is not generated");
}

# load plugins
__PACKAGE__->load_plugins(
    'Web::FillInFormLite',
    'Web::JSON',
    'Web::Text',
    '+<?= $arg->{module} ?>::Web::Plugin::Session',
);

# setup view
use <?= $arg->{module} ?>::Web::View;
{
    sub create_view {
        my $view = <?= $arg->{module} ?>::Web::View->make_instance(__PACKAGE__);
        no warnings 'redefine';
        *<?= $arg->{module} ?>::Web::create_view = sub { $view }; # Class cache.
        $view
    }
}

# for your security
__PACKAGE__->add_trigger(
    AFTER_DISPATCH => sub {
        my ( $c, $res ) = @_;

        # http://blogs.msdn.com/b/ie/archive/2008/07/02/ie8-security-part-v-comprehensive-protection.aspx
        $res->header( 'X-Content-Type-Options' => 'nosniff' );

        # http://blog.mozilla.com/security/2010/09/08/x-frame-options/
        $res->header( 'X-Frame-Options' => 'DENY' );

        # Cache control.
        $res->header( 'Cache-Control' => 'private' );
    },
);

1;
