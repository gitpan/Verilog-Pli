package Verilog::Pli::MMutil;
use ExtUtils::MakeMaker;

$VCS_HOME = $ENV{VCS_HOME};
(defined $VCS_HOME) or die "%Error: VCS_HOME must be defined to find vcs include files\n";

sub WriteMakefile {
    my %params = (
		  VERSION => '1.2',
		  INC => ("-I$VCS_HOME/sun_sparc_solaris_5.4/lib"
			  ." -I$::RealBin"),
		  @_);
    ExtUtils::MakeMaker::WriteMakefile (%params);
}

1;
