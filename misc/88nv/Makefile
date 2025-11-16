all: index.html preview.gif

preview.gif: $(wildcard *.svg)
	$(foreach svg,$?,if echo $(svg) | grep "svg$$" >/dev/null; then ~/timelines/scripts/round.py $(svg) < $(svg) > $(svg).tmp && mv $(svg).tmp $(svg); fi;)
	~/timelines/scripts/previewgif.sh .

index.html: makeindex.sh $(wildcard *.svg) preview.gif
	./makeindex.sh > $@

.PHONY: all
