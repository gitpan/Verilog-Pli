# $Id: Makefile.PL,v 1.8 2002/08/30 14:46:09 wsnyder Exp $
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

clean::
	(cd example ; make clean)

test::
	(cd example ; make)

## Maintainer use:
tag:
	cvs tag -F \$(DISTNAME)_\$(VERSION_SYM) .

maintainer-dist: dist tag
	cp \$(DISTVNAME).tar.gz \$(HOME)/src/kits
	mv \$(DISTVNAME).tar.gz \$(HOME)/backpack

maintainer-clean: distclean
	-rm README Makefile

dist: distcheck README

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
