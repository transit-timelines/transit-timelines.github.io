all: $(patsubst %.svg,%.png,$(wildcard *.svg))

%.png: %.svg
	~/timelines/scripts/round.py < $< > $<.tmp
	mv $<.tmp $<
	inkscape -b ffffff -y 255 -d `( grep $< dpis || echo 20.87 ) | sed -e's/.*\t//'` -o $<.png $<
	convert $<.png -type palette PNG8:$@
	rm $<.png

rsync: all
	rsync -4Pav *.png *.svg arapp_arapp@ssh.nyc1.nearlyfreespeech.net:fantasymaps/

.PHONY: all rsync
