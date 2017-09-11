# to run a dc program, type 'dc <program>', or 'make -B <program>'
# to compile the mdc source code, type 'make mdc'

# source file extensions
SRC = dc oz pl

%.dc:
	dc $@

mdc: mdc.oz $(foreach part,lexemize tokenize interpret,mdc-$(part).oz)
	ozc -x $<

mdc-tokenize.oz: mdc-tokenize-map.oz
	ln -sf $$(pwd)/$< $@

# remove all non-source files
clean:
	$(RM) $(filter-out $(addprefix %., $(SRC)) makefile, $(wildcard *)) mdc-tokenize.oz
