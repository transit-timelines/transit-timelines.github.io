all: bymode regrail sandy nyctrolleys nycflights 88nv

bymode = nycbymode bosbymode sfobymode berbymode alobymode cbgbymode
bymode: $(bymode)

regrail = nerail carail gbrail
regrail: $(regrail)

define bymoderule
$(1): $(1)/index.html

$(1)/index.html: $(1)/name $(1)/key $(1)/preview.gif $(1)/bg.png $(wildcard $(1)/*.svg $(1)/seealso ~/timelines/scripts/template/*) ~/timelines/scripts/makeindex.sh
	~/timelines/scripts/makeindex.sh $(1) > $$@
endef

define regrailrule
$(1): $(1)/index.html $(1)/large.html

$(1)/index.html: $(1)/name $(1)/cities $(1)/preview.gif $(1)/bg.png $(wildcard $(1)/*.svg) ~/timelines/scripts/makerailindex.sh ~/timelines/scripts/template/part4
	~/timelines/scripts/makerailindex.sh $(1) 2 > $$@

$(1)/large.html: $(1)/name $(1)/cities $(1)/preview.gif $(1)/large-bg.png $(wildcard $(1)/*.svg) ~/timelines/scripts/makerailindex.sh ~/timelines/scripts/template/part4
	~/timelines/scripts/makerailindex.sh $(1) 5 > $$@
endef

$(foreach dir, $(bymode), $(eval $(call bymoderule, $(dir))))
$(foreach dir, $(regrail), $(eval $(call regrailrule, $(dir))))

sandy: sandy/preview.gif

nyctrolleys: nyctrolleys/preview.gif

nycflights 88nv:
	$(MAKE) --directory=$@

.SECONDEXPANSION:
%/preview.gif: $$(wildcard %/*.svg) ~/timelines/scripts/previewgif.sh
	$(foreach svg,$?,if echo $(svg) | grep "svg$$" >/dev/null; then ~/timelines/scripts/round.py $(svg) < $(svg) > $(svg).tmp && mv $(svg).tmp $(svg); fi;)
	~/timelines/scripts/previewgif.sh `dirname $@`

.PHONY: all bymode $(bymode) regrail $(regrail) nyctrolleys nycflights 88nv
