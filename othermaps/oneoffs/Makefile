all: large.html index.html

maps = Past: mkc.svg lou.svg sux.svg roc.svg ct_.svg hl_.svg mem.svg ind.svg Special-Purpose: zin.svg dws.svg mgw.svg qca.svg

index.html: names makeindex.sh $(wildcard *.svg) ~/timelines/scripts/template/part4 Makefile
	$(foreach svg,$?,if echo $(svg) | grep "svg$$" >/dev/null; then ~/timelines/scripts/round.py $(svg) < $(svg) > $(svg).tmp && mv $(svg).tmp $(svg); fi;)
	./makeindex.sh 10 $(maps) > $@

large.html: names makeindex.sh $(wildcard *.svg) ~/timelines/scripts/template/part4b Makefile index.html
	./makeindex.sh 30 $(maps) > $@
