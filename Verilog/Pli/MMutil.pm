# $Id: MMutil.pm,v 1.10 2003/07/21 21:32:31 wsnyder Exp $
# DESCRIPTION: Perl ExtUtils: Define VCS building rules for Makefile.PL

package Verilog::Pli::MMutil;
use ExtUtils::MakeMaker;

$PLI_INCLUDE_HOME = $ENV{PLI_INCLUDE_HOME};
if ($ENV{VCS_HOME}) {
    my $try;
    $try = "$ENV{VCS_HOME}/include";                     $PLI_INCLUDE_HOME ||= $try if -d $try;
    $try = "$ENV{VCS_HOME}/sun_sparc_solaris_5.5.1/lib"; $PLI_INCLUDE_HOME ||= $try if -d $try;
    $try = "$ENV{VCS_HOME}/sun_sparc_solaris_5.4/lib";   $PLI_INCLUDE_HOME ||= $try if -d $try;
    $try = "$ENV{VCS_HOME}/intel_i686_linux_2.2/lib";    $PLI_INCLUDE_HOME ||= $try if -d $try;
}

(defined $PLI_INCLUDE_HOME) or die "%Error: PLI_INCLUDE_HOME or VCS_HOME must be defined to find acc_user.h include files\n";

sub WriteMakefile {
    my %params = (
		  INC => (" -I$PLI_INCLUDE_HOME"
			  ." -I$::RealBin -I.."
			  .((defined $ENV{VMC_CFLAGS})?" $ENV{VMC_CFLAGS}":"")
			  ),
		  @_);
    ExtUtils::MakeMaker::WriteMakefile (%params);
}

1;
