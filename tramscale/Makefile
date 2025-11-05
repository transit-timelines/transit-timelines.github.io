all: $(patsubst %.svg,%.svg.gz,$(wildcard *.svg)) index.html

%.svg.gz : %.svg
	~/timelines/scripts/round.py < $< > $<.tmp
	mv $<.tmp $<
	gzip -f --keep $<

index.html: names makeindex.sh $(wildcard ???.svg) ~/timelines/scripts/template/part4
	./makeindex.sh $(wildcard ???.svg) > $@

.PHONY: all
