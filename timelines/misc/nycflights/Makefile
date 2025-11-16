all: $(patsubst routes%,%.svg,$(wildcard routes????)) index.html preview.gif

%.svg : routes% scripts/makeyear.sh scripts/path.pl scripts/circ.pl
	scripts/makeyear.sh $*

preview.gif: $(wildcard *.svg)
	~/timelines/scripts/previewgif.sh .

.PHONY: all
