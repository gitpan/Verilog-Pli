use FindBin qw($RealBin);
use lib $RealBin;

use Verilog::Pli::MMutil;

sub MY::postamble {
"
README: readme.texi
	-rm \$@
	makeinfo \$< --output \$@ --no-headers --no-validate

maintainer-clean: distclean
	-rm README Makefile

dist: distcheck README
";
}

Verilog::Pli::MMutil::WriteMakefile
    (
     NAME => "Verilog::Pli",
     DISTNAME  => 'Verilog-Pli',
     'dist'    => {COMPRESS => 'gzip -9f',
		   SUFFIX   => '.gz', 
		   DIST_DEFAULT => 'README all tardist',
	       },
     );
