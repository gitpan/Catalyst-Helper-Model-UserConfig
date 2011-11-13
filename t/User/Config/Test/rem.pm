package User::Config::Test::rem;

use User::Config;

has_option "remote" => ( references => 'User::Config::Test::setting' );

no Moose;
__PACKAGE__->meta->make_immutable;
1;
