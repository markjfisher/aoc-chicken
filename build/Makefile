# -*- MakeFile -*-

# This makefile is inspired by https://github.com/bintracker/bintracker/blob/master/build/Makefile

CSC = csc
CSI = csi
DOCGEN = scm2wiki
LIBFLAGS = -s -d3
ifdef RELEASE
  LIBFLAGS += -O3
endif
IMPORTFLAGS = -s -d0
INCLUDE_FLAGS = -I ../

ADVENTS_SRC = ../advents/
A_2015 = $(ADVENTS_SRC)2015/
MODS_SRC = ../
ifdef ETAGS
  DO_TAGS = TAGS
endif

# Start of targets

all: advent2015

# advent years
advent2015: $(ADVENTS_SRC)2015/day01.scm aoc-files.so
	$(CSC) $(INCLUDE_FLAGS) $< -d3 -O2 -compile-syntax -o $@

# Shared code module
aoc-files.so: $(MODS_SRC)aoc-files.scm $(DO_TAGS)
	$(CSC) $(INCLUDE_FLAGS) $(LIBFLAGS) $< -j aoc-files -emit-types-file aoc-files.types -o $@
	$(CSC) $(INCLUDE_FLAGS) $(IMPORTFLAGS) aoc-files.import.scm

aoc-files.import.so: advents.so
	$(CSC) $(INCLUDE_FLAGS) $(IMPORTFLAGS) aoc-files.import.scm

# docs
gendoc/generated/%.md: $(MODS_SRC)%.scm
	$(DOCGEN) -a -i $< -o $@ -m

# 2015 docs
gendoc/generated/2015/%.md: $(A_2015)%.scm
	$(DOCGEN) -a -i $< -o $@ -m

docs: gendoc-dirs \
 gendoc/generated/aoc-files.md \
 gendoc/generated/2015/day01.md
	for file in ../docs/*.md; do cp $$file gendoc/; done
	cp -r ../docs/assets/ gendoc/
	cd .. && mkdocs build

#	cp -r ../docs/images/ gendoc/

gendoc-dirs:
	mkdir -p gendoc/
	mkdir -p gendoc/generated/2015

TAGS: $(MODS_SRC)aoc-files.scm\
 $(ADVENTS_SRC)/2015/day01.scm
	cd .. && etags -r '"  (def.*? "' aoc-files.scm\
 advents/2015/day01.scm

#.PHONY: resources
#resources:
#	mkdir -p resources/
#	cp -r $(MODS_SRC)resources resources/

.PHONY: tests
tests: advent-tests-2015

#.PHONY: module-tests
#module-tests:

# TODO: make this automatically find all tests and run them
.PHONY: advent-tests-2015
advent-tests-2015:
	cp -t ./ \
 $(ADVENTS_SRC)/2015/tests/day01.scm \
 $(ADVENTS_SRC)/2015/resources/day01.txt \
 && $(CSI) day01.scm -e

.PHONY: clean
clean:
	-rm *.so *.scm
	-rm -rf docs plugins resources documentation gendoc
