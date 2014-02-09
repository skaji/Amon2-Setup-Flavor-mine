package <?= $arg->{module} ?>::DB::Row::Item;
use strict;
use warnings;
use utf8;
use parent '<?= $arg->{module} ?>::DB::Row';

use Time::Piece ();

sub fetch_user {
    my $self = shift;
    $self->handle->single('user', { id => $self->user_id });
}

sub created_at_obj {
    Time::Piece->new( shift->created_at );
}
sub updated_at_obj {
    Time::Piece->new( shift->updated_at );
}


1;

