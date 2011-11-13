use Test::More;
use Catalyst::Helper;
use DBI;

use lib 't';
use lib '.';

my $generator_tests;
BEGIN {
	$generator_tests = 3;
	eval { require Catalyst::Devel };
	plan skip_all => "No Catalyst::Devel present" if $@;
	plan tests => 2 + 5 * $generator_tests;
}

my $module;
BEGIN { $module = 'Catalyst::Helper::Model::UserConfig'};
BEGIN { use_ok($module) };

my $dbic_dbi =  "dbi:SQLite:dbic.db";
my $keyed_dbi = "dbi:SQLite:keyed.db";

sub create_db {
	my ($dbi, $table, $coldef) = @_;
	my $dbh = DBI->connect($dbi);
	$dbh->do("CREATE TABLE IF NOT EXISTS $table ( $coldef )");
	$dbh->disconnect;
}
create_db($dbic_dbi, "test" => "uid text primary key, User_Config_Test_setting text"); 
create_db($keyed_dbi, "test" => "uid text, item text, value text"); 

sub test_generator {
	my ( $type, @args ) = @_;
	SKIP: {
		eval "require User::Config::DB::$type";
		skip "User::Config::DB::$type isn't installed", $generator_tests if $@;
		my $cls = "UserConfigTest$type";
		my $fn = "$cls.pm";
		unlink $fn if -f $fn;
		my $helper = bless({
				file => $fn,
				app => "TestApp",
				class => $cls,
			}, 'Catalyst::Helper');
		$module->mk_compclass($helper, $type, @args);
		require_ok($cls);
		my $testcls = $cls->new;
		$testcls->build_per_context_instance({ user => 'foo' });

		is(ref User::Config->instance->db, "User::Config::DB::$type",
			"set correct database for $type");
		SKIP: {
			eval "use Test::Pod 1.00";
			skip "Test::Pod required to test POD", 1 if $@;
			Test::Pod::pod_file_ok($fn, "created valid POD for $type");
		}
		unlink $fn if -f $fn and not $ENV{LEAVE_GENERATED};
	}
}
test_generator("Mem");
test_generator("DBIC", $dbic_dbi, "User::Config::Test::Schema", "Test");
test_generator("Ldap", "ldap://localhost", "dc=localhost");
test_generator("Keyed", $keyed_dbi, "test");
test_generator("Ldap");
is(ref UserConfigTestMem::form(User::Config->instance), "User::Config::UI::HTMLFormHandler", "embedded UI handler");
