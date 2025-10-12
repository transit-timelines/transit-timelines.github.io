all: $(wildcard ???) index.html

define WriteRules
ifeq ($(wildcard $(1)/crop.pl),$(1)/crop.pl)
$(1)/small/%.svg: ;
$(1)/%.svg:: $(1)/uncropped/%.svg $(1)/crop.pl
	$(1)/crop.pl $$< > $$@

$(1)/index.html: $(1)/name $(subst uncropped/,,$(wildcard $(1)/uncropped/*.svg)) ~/timelines/scripts/makeindex.sh $(wildcard ~/timelines/scripts/template/* $(1)/seealso $(1)/bg.png) $(1)/preview.gif
	~/timelines/scripts/makeindex.sh $(1) > $$@


$(1): $(1)/uncropped $(subst uncropped/,,$(patsubst %.svg,%.svg.gz,$(wildcard $(1)/uncropped/*.svg)) $(wildcard $(1)/uncropped/*.svg)) $(1)/index.html $(1)/preview.gif;

else
$(1)/small/%.svg: $(1)/%.svg $1/%.svg.gz $(wildcard $(1)/cropsmall.pl)
	mkdir -p $(1)/small
	if [ -f $(1)/cropsmall.pl ]; then $(1)/cropsmall.pl $$<; else cat $$<; fi | ~/timelines/scripts/hideyear.pl > $$@
	~/timelines/scripts/from-year-range.sh $(1)

$(1)/index.html: $(wildcard $(1)/name $(1)/../name $(1)/seealso $(1)/../seealso $(1)/*.svg $(1)/bg.png ~/timelines/scripts/template/*) $(1)/preview.gif ~/timelines/scripts/makeindex.sh
	~/timelines/scripts/makeindex.sh $(1) > $$@

$(1): $(patsubst %.svg,%.svg.gz,$(wildcard $(1)/*.svg)) $(subst $(1),$(1)/small, $(wildcard $(1)/*.svg) $(patsubst %.svg,%.svg.gz,$(wildcard $(1)/*.svg))) $(1)/index.html $(1)/preview.gif;

endif
endef

%.svg.gz : %.svg
	~/timelines/scripts/round.py < $< > $<.tmp
	mv $<.tmp $<
	gzip -f --keep $<

.SECONDEXPANSION:
%/preview.gif: $$(wildcard %/*.svg) ~/timelines/scripts/previewgif.sh
	~/timelines/scripts/previewgif.sh `dirname $@`

.PHONY: all $(wildcard ???) $(wildcard ???/small) $(wildcard ???/uncropped) $(wildcard ???/uncropped/small)
$(foreach dir, $(wildcard ??? ???/uncropped), $(eval $(call WriteRules, $(dir))))

index.html: $(wildcard ???/small/2025.svg) $(wildcard ???/s) $(wildcard ???/name) ../scripts/makemainindex.sh ../scripts/template/part4 opening-dates
	~/timelines/scripts/makemainindex.sh `awk -F'\t' '{print $$2}' opening-dates` > $@
