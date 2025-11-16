all: index.html

index.html: names makeindex.sh $(wildcard ???.svg) ~/timelines/scripts/template/part4b
	$(foreach svg,$?,if echo $(svg) | grep "svg$$" >/dev/null; then ~/timelines/scripts/round.py $(svg) < $(svg) > $(svg).tmp && mv $(svg).tmp $(svg); fi;)
	./makeindex.sh $(wildcard ???.svg) > $@

.PHONY: all
