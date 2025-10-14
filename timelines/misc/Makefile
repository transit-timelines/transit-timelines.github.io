all: hsr bymode regrail sandy nyctrolleys nycflights ivytunnels 88nv

bymode = nycbymode bosbymode sfobymode berbymode alobymode cbgbymode
bymode: $(bymode)

regrail = nerail carail gbrail
regrail: $(regrail)

define bymoderule
$(1): $(patsubst %.svg,%.svg.gz,$(wildcard $(1)/*.svg)) $(1)/preview.gif $(1)/index.html

$(1)/index.html: $(1)/name $(1)/key $(1)/preview.gif $(wildcard $(1)/*.svg $(1)/seealso $(1)/bg.png ~/timelines/scripts/template/*) ~/timelines/scripts/makeindex.sh
	~/timelines/scripts/makeindex.sh $(1) > $$@
endef

define regrailrule
$(1): $(patsubst %.svg,%.svg.gz,$(wildcard $(1)/*.svg)) $(1)/preview.gif $(1)/index.html $(1)/large.html

$(1)/index.html: $(1)/name $(1)/cities $(1)/preview.gif $(wildcard $(1)/*.svg $(1)/bg.png) ~/timelines/scripts/makerailindex.sh ~/timelines/scripts/template/part4
	~/timelines/scripts/makerailindex.sh $(1) 2 > $$@

$(1)/large.html: $(1)/name $(1)/cities $(1)/preview.gif $(wildcard $(1)/*.svg $(1)/large-bg.png) ~/timelines/scripts/makerailindex.sh ~/timelines/scripts/template/part4
	~/timelines/scripts/makerailindex.sh $(1) 5 > $$@
endef

$(foreach dir, $(bymode), $(eval $(call bymoderule, $(dir))))
$(foreach dir, $(regrail), $(eval $(call regrailrule, $(dir))))

hsr: $(patsubst %.svg,%.svg.gz,$(wildcard hsr/?/*.svg))

ivytunnels: $(patsubst %.svg,%.svg.gz,$(wildcard ivytunnels/?/*.svg))

88nv: $(patsubst %.svg,%.svg.gz,$(wildcard 88nv/*.svg)) 88nv/preview.gif

sandy: $(patsubst %.svg,%.svg.gz,$(wildcard sandy/*.svg)) sandy/preview.gif

nyctrolleys: $(patsubst %.svg,%.svg.gz,$(wildcard nyctrolleys/*.svg)) nyctrolleys/preview.gif

nycflights:
	$(MAKE) --directory=$@

%.svg.gz : %.svg
	~/timelines/scripts/round.py < $< > $<.tmp
	mv $<.tmp $<
	gzip -f --keep $<

.SECONDEXPANSION:
%/preview.gif: $$(wildcard %/*.svg) ~/timelines/scripts/previewgif.sh
	~/timelines/scripts/previewgif.sh `dirname $@`

.PHONY: all bymode $(bymode) regrail $(regrail) hsr ivytunnels nyctrolleys nycflights 88nv
