# DESCRIPTION: Perl ExtUtils: Automatically called by upper Makefile.PL
use Verilog::Pli::MMutil;

Verilog::Pli::MMutil::WriteMakefile
    (
     VERSION_FROM => 'Net.pm',
     NAME => "Verilog::Pli::Net",
     );
