package User::Config::Test::Schema::Result::Test;

use base qw/DBIx::Class::Core/;

__PACKAGE__->table('test');
__PACKAGE__->add_columns(qw/ uid User_Config_Test_setting /);
__PACKAGE__->set_primary_key('uid');

1;
