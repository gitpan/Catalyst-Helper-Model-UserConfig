use 5.010001;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Catalyst::Helper::Model::UserConfig',
    VERSION_FROM      => 'lib/Catalyst/Helper/Model/UserConfig.pm', # finds $VERSION
    PREREQ_PM         => {
	    'User::Config' => 0.02,
	    'User::Config::UI::HTMLFormHandler' => 0,
	    'Catalyst::Helper' => 0,
    },
    BUILD_REQUIRES    => {
	    'DBI' => 0,
    },
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (
	      ABSTRACT_FROM  => 'lib/Catalyst/Helper/Model/UserConfig.pm', # retrieve abstract from module
	      AUTHOR         => 'Benjamin Tietz <btietz@cpan.com>',
	      LICENSE		=> 'perl',
	      META_MERGE	=> {
		      no_index => {
			      directory => 't',
		      },
	      },
      ) : ()),
);
