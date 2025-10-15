all: index.html $(patsubst %.svg,%.svg.gz,$(wildcard *.svg))

%.svg.gz : %.svg
	~/timelines/scripts/round.py < $< > $<.tmp
	mv $<.tmp $<
	gzip -f --keep $<

index.html: names sources ../makeindex.sh $(wildcard *.svg)
	../makeindex.sh $(wildcard *.svg) | grep -v '<meta.*image' > $@
