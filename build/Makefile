# -*- MakeFile -*-

# This makefile is inspired by https://github.com/bintracker/bintracker/blob/master/build/Makefile

CSC = csc
CSI = csi
DOCGEN = scm2wiki
LIBFLAGS = -s -d3
ifdef RELEASE
  LIBFLAGS += -O3
  EXE_FLAGS = -O3
else
  EXE_FLAGS = -d3 -O2 -compile-syntax
endif
IMPORTFLAGS = -s -d0

# MULTI-PLATFORM CODE
ifeq ($(OS),Windows_NT)

ifneq ($(strip $(filter %sh,$(basename $(realpath $(SHELL))))),)
POSIXSHELL := 1
else
POSIXSHELL :=
endif

else
# not on windows:
POSIXSHELL := 1

endif

ifneq ($(POSIXSHELL),)

CMDSEP := ;
PSEP := /
CPF := cp -f
CPR := cp -r
MKDIR := mkdir -p
RM := rm
RMDIR := rm -rf

else

CMDSEP := &
PSEP := \\
CPF := copy /y
CPR := xcopy /y /i /e
MKDIR := mkdir
RM := del /q
RMDIR := rmdir /s /q

endif

INCLUDE_FLAGS = -I ..$(PSEP)

ADVENTS_SRC = ..$(PSEP)advents$(PSEP)
ifdef ETAGS
  DO_TAGS = TAGS
endif

DAYS := 01 02 03 04


# Start of targets

all: advent2015

advent2015: $(ADVENTS_SRC)2015$(PSEP)advent2015.scm \
 aoc-files.so copy-2015-data \
 $(foreach D,$(DAYS),aoc2015day$(D).so)
	$(CSC) $(INCLUDE_FLAGS) $< $(EXE_FLAGS) -o $@

copy-2015-data:
ifeq ($(POSIXSHELL),)
# annoyingly i can't get xcopy to do same as cp, i.e. whole directory and its name.
	@if not exist 2015 $(MKDIR) 2015$(PSEP)resources
	$(CPR) $(ADVENTS_SRC)2015$(PSEP)resources 2015$(PSEP)resources
else
	$(MKDIR) 2015
	$(CPR) $(ADVENTS_SRC)2015$(PSEP)resources 2015/
endif

%.so: $(ADVENTS_SRC)2015$(PSEP)%.scm aoc-files.so
	$(CSC) $(INCLUDE_FLAGS) $(LIBFLAGS) $< -j $* -emit-types-file $*.types -o $@
	$(CSC) $(INCLUDE_FLAGS) $(IMPORTFLAGS) $*.import.scm

%.import.so: %.so
	$(CSC) $(INCLUDE_FLAGS) $(IMPORTFLAGS) $*.import.scm

# Shared code modules
aoc-files.so: $(ADVENTS_SRC)aoc-files.scm $(DO_TAGS)
	$(CSC) $(INCLUDE_FLAGS) $(LIBFLAGS) $< -j aoc-files -emit-types-file aoc-files.types -o $@
	$(CSC) $(INCLUDE_FLAGS) $(IMPORTFLAGS) aoc-files.import.scm

aoc-files.import.so: aoc-files.so
	$(CSC) $(INCLUDE_FLAGS) $(IMPORTFLAGS) aoc-files.import.scm

# docs
gendoc/generated/%.md: $(ADVENTS_SRC)%.scm
	$(DOCGEN) -a -i $< -o $@ -m

# 2015 docs
gendoc/generated/2015/%.md: $(ADVENTS_SRC)2015/%.scm
	$(DOCGEN) -a -i $< -o $@ -m

# TODO: make this work with windows
docs: gendoc-dirs \
 gendoc$(PSEP)generated$(PSEP)aoc-files.md \
 $(foreach D,$(DAYS),gendoc$(PSEP)generated$(PSEP)2015$(PSEP)aoc2015day$(D).md)
	for file in ../docs/*.md; do cp $$file gendoc/; done
	$(CPR) ..$(PSEP)docs$(PSEP)assets$(PSEP) gendoc$(PSEP)
	cd .. && mkdocs build

gendoc-dirs:
	$(MKDIR) gendoc$(PSEP)generated$(PSEP)2015

TAGS: $(ADVENTS_SRC)aoc-files.scm\
 $(foreach D,$(DAYS),$(ADVENTS_SRC)2015$(PSEP)aoc2015day$(D).scm)
	cd .. && etags -r '"  (def.*? "' aoc-files.scm\
 $(foreach D,$(DAYS),advents$(PSEP)2015$(PSEP)aoc2015day$(D).scm)

.PHONY: tests
tests: advent-tests-2015

#.PHONY: module-tests
#module-tests:

# TODO: make this automatically find all tests and run them
.PHONY: advent-tests-2015
advent-tests-2015:
	$(CPF) $(ADVENTS_SRC)2015$(PSEP)tests$(PSEP)test-day*.scm .
	$(CPF) $(ADVENTS_SRC)2015$(PSEP)tests$(PSEP)resources$(PSEP)day*.txt .
	$(CSI) test-day01.scm -e
	-$(RM) test-*.scm day*.txt

# cleans build dir files
.PHONY: clean
clean:
	-$(RM) *.so *.scm *.types *.txt advent*
	-$(RMDIR) docs plugins resources documentation gendoc 2015
