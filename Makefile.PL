# $Id: Makefile.PL,v 1.7 2001/02/13 15:11:16 wsnyder Exp $
# DESCRIPTION: Perl ExtUtils: Type 'perl Makefile.PL' to create a Makefile for this package

use FindBin qw($RealBin);
use lib $RealBin;

use Verilog::Pli::MMutil;
use Config;

($Config{usemymalloc} eq "n") or die "%Error: Simulators require perl to be built with mymalloc=n, stopped";
# Specifically, VCS on solaris uses the system's 64-bit capable malloc,
# which conflicts with the one that comes with perl.  This is discovered by
# a core dump right after perl boots inside the simulator.

sub MY::postamble {
"
README: readme.texi
	-rm \$@
	makeinfo \$< --output \$@ --no-headers --no-validate

maintainer-clean: distclean
	-rm README Makefile

dist: distcheck README

clean::
	(cd example ; make clean)

test::
	(cd example ; make)

";
}

Verilog::Pli::MMutil::WriteMakefile
    (
     NAME => "Verilog::Pli",
     DISTNAME  => 'Verilog-Pli',
     AUTHOR	=> 'Wilson Snyder <wsnyder@wsnyder.org>',
     VERSION_FROM => 'Pli.pm',
     ABSTRACT_FROM => 'Pli.pm',
     'dist'    => {COMPRESS => 'gzip -9f',
		   SUFFIX   => '.gz', 
		   DIST_DEFAULT => 'README all tardist',
	       },
     );
