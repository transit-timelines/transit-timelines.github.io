all: index.html rtoverlay

index.html: names sources makeindex.sh $(wildcard *.svg) ~/timelines/scripts/template/part4b
	$(foreach svg,$?,if echo $(svg) | grep "svg$$" >/dev/null; then ~/timelines/scripts/round.py $(svg) < $(svg) > $(svg).tmp && mv $(svg).tmp $(svg); fi;)
	./makeindex.sh $(wildcard *.svg) > $@

rtoverlay:
	$(MAKE) --directory=$@

.PHONY: all rtoverlay
