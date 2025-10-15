all: index.html $(patsubst %.svg,%.svg.gz,$(wildcard *.svg)) rtoverlay

%.svg.gz : %.svg
	~/timelines/scripts/round.py < $< > $<.tmp
	mv $<.tmp $<
	gzip -f --keep $<

index.html: names sources makeindex.sh $(wildcard *0.svg)
	./makeindex.sh $(wildcard *.svg) > $@

rtoverlay:
	$(MAKE) --directory=$@

.PHONY: all rtoverlay
