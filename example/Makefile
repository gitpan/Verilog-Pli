# $Id: Makefile,v 1.9 2003/09/22 19:30:51 wsnyder Exp $
# DESCRIPTION: Verilog::PLI: Example Makefile for trivial PLI use under VCS.
# This file ONLY is placed into the Public Domain, for any use,
# without warranty, 2003 by Wilson Snyder.
######################################################################

# This section may need tuning

# Path to VCS
VCS = $(VCS_HOME)/bin/vcs
OSTYPE := $(shell uname -s)
# Returns something like '/usr/local/lib/perl5/5.00503/sun4-solaris'
PERL := perl
PERL_ARCHLIBEXP := `$(PERL) -MConfig -e 'print $$Config{archlibexp}'`
CFLAGS += -I$(VCS_HOME)/include
ifeq ($(OSTYPE),Linux)
	CFLAGS += -I$(VCS_HOME)/intel_i686_linux_2.2
else
	CFLAGS += -I$(VCS_HOME)/sun_sparc_solaris_5.4/lib \
		  -I$(VCS_HOME)/sun_sparc_solaris_5.5.1/lib
endif

# Which compiler
CC = gcc

# Use this command to get the libraries to put here:
#	perl -MExtUtils::Embed -e ldopts
# We should be able to use a rule like:
# PERL_OPTS = $(shell perl -MExtUtils::Embed -e ldopts)
# But VCS has a brain damaged linker specification.
# Also note we cheat and statically link in the dynamic Verilog library
# this is not strictly needed, but makes packaging simpler
PERL_OPTS = \
	$(PERL_ARCHLIBEXP)/auto/DynaLoader/DynaLoader.a \
	$(PERL_ARCHLIBEXP)/CORE/libperl.a \
	$(OS_COPT) -lnsl -ldl -lm -lc -lcrypt

#	../blib/arch/auto/Verilog/Pli/Pli.so \

VERILOG_TOP_FILE = hello.v

######################################################################

MODEL = simv

CLI_OPTS = +cli
CFLAGS += `perl -MExtUtils::Embed -e ccopts`
# Below is needed only for solaris 5.6's GCC and newer:
PLI_LINK_FLAGS += -Wl,-export-dynamic
PLI_SRC_FILES = pli_hello.c cmd.c perlxsi.c
PLI_TABLE = pli.tab

all:	run
test:   all

$(MODEL):	$(VERILOG_TOP_FILE) $(PLI_SRC_FILES) $(PLI_TABLE)
	$(VCS) -ld "$(CC) $(PLI_LINK_FLAGS)" -cc $(CC) $(CLI_OPTS) -CFLAGS "$(CFLAGS)" \
		$(VERILOG_TOP_FILE) -P $(PLI_TABLE) $(PLI_SRC_FILES) \
		-Mupdate $(PERL_OPTS) -o $(MODEL)

run:	$(MODEL)
	./$(MODEL)

perlxsi.c:
	perl -MExtUtils::Embed -e xsinit -- -o perlxsi.c

clean::
	rm -f -r $(MODEL) *.o *.daidir perlxsi.c csrc
