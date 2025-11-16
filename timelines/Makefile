all: $(wildcard ???) index.html misc

define WriteRules
ifeq ($(wildcard $(1)/crop.pl),$(1)/crop.pl)
$(1)/small/%.svg: ;
$(1)/%.svg:: $(1)/uncropped/%.svg $(1)/crop.pl
	$(1)/crop.pl $$< > $$@

$(1)/index.html: $(subst uncropped/,,$(wildcard $(1)/uncropped/*.svg)) $(wildcard ~/timelines/scripts/template/* $(1)/seealso) $(1)/name $(1)/bg.png $(1)/preview.gif ~/timelines/scripts/makeindex.sh
	~/timelines/scripts/makeindex.sh $(1) > $$@


$(1): $(1)/uncropped $(subst uncropped/,,$(wildcard $(1)/uncropped/*.svg)) $(1)/index.html $(1)/preview.gif;

else
$(1)/small/%.svg: $(1)/%.svg $(wildcard $(1)/cropsmall.pl)
	mkdir -p $(1)/small
	if [ -f $(1)/cropsmall.pl ]; then $(1)/cropsmall.pl $$<; else cat $$<; fi | ~/timelines/scripts/hideyear.pl > $$@
	~/timelines/scripts/from-year-range.sh $(1)

$(1)/index.html: $(wildcard $(1)/name $(1)/../name $(1)/seealso $(1)/*.svg ~/timelines/scripts/template/*) $(1)/bg.png $(1)/preview.gif ~/timelines/scripts/makeindex.sh
	~/timelines/scripts/makeindex.sh $(1) > $$@

$(1): $(subst $(1),$(1)/small, $(wildcard $(1)/*.svg)) $(1)/index.html $(1)/preview.gif;

endif
endef

.SECONDEXPANSION:
%/preview.gif: $$(wildcard %/*.svg) ~/timelines/scripts/previewgif.sh
	$(foreach svg,$?,if echo $(svg) | grep "svg$$" >/dev/null; then ~/timelines/scripts/round.py $(svg) < $(svg) > $(svg).tmp && mv $(svg).tmp $(svg); fi;)
	~/timelines/scripts/previewgif.sh `dirname $@`

$(foreach dir, $(wildcard ??? ???/uncropped), $(eval $(call WriteRules, $(dir))))

misc:
	$(MAKE) --directory=$@

index.html: $(wildcard ???/small/2025.svg) $(wildcard ???/s) $(wildcard ???/name) ../scripts/makemainindex.sh ../scripts/template/part4 opening-dates
	~/timelines/scripts/makemainindex.sh `awk -F'\t' '{print $$2}' opening-dates` > $@

.PHONY: all $(wildcard ???) $(wildcard ???/uncropped) misc
