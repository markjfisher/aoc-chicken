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
ifdef ETAGS
  DO_TAGS = TAGS
endif

# Start of targets

all: advent2015

# advent years
advent2015: $(ADVENTS_SRC)2015/advent2015.scm aoc2015day01.so aoc-files.so copy-2015-data
	$(CSC) $(INCLUDE_FLAGS) $< -d3 -O2 -compile-syntax -o $@

copy-2015-data:
	mkdir -p 2015
	cp -r $(ADVENTS_SRC)2015/resources 2015/

# individual days - TODO make this loop
aoc2015day01.so: $(ADVENTS_SRC)2015/aoc2015day01.scm aoc-files.so
	$(CSC) $(INCLUDE_FLAGS) $(LIBFLAGS) $< -j aoc2015day01 -emit-types-file aoc2015day01.types -o $@
	$(CSC) $(INCLUDE_FLAGS) $(IMPORTFLAGS) aoc2015day01.import.scm

aoc2015day01.import.so: day01-2015.so
	$(CSC) $(INCLUDE_FLAGS) $(IMPORTFLAGS) aoc2015day01.import.scm

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

docs: gendoc-dirs \
 gendoc/generated/aoc-files.md \
 gendoc/generated/2015/aoc2015day01.md
	for file in ../docs/*.md; do cp $$file gendoc/; done
	cp -r ../docs/assets/ gendoc/
	cd .. && mkdocs build

gendoc-dirs:
	mkdir -p gendoc/
	mkdir -p gendoc/generated/2015

TAGS: $(ADVENTS_SRC)aoc-files.scm\
 $(ADVENTS_SRC)/2015/aoc2015day01.scm
	cd .. && etags -r '"  (def.*? "' aoc-files.scm\
 advents/2015/aoc2015day01.scm

#.PHONY: resources
#resources:
#	mkdir -p resources/
#	cp -r $(ADVENTS_SRC)resources resources/

.PHONY: tests
tests: advent-tests-2015

#.PHONY: module-tests
#module-tests:

# TODO: make this automatically find all tests and run them
.PHONY: advent-tests-2015
advent-tests-2015:
	cp -t ./ \
 $(ADVENTS_SRC)/2015/tests/test-day01.scm \
 $(ADVENTS_SRC)/2015/resources/day01.txt \
 && $(CSI) test-day01.scm -e
	-rm test-*.scm

.PHONY: clean
clean:
	-rm *.so *.scm *.types *.txt
	-rm -rf docs plugins resources documentation gendoc
	-rm advent*
