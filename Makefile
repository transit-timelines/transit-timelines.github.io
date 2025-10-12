targets = timelines tramscale walledcityscale timelines/misc othermaps/oneoffs othermaps/subplans

all: $(targets)

$(targets):
	$(MAKE) --directory=$@

rsync: all
	rsync -4Pav timelines *scale othermaps --include 'preview.png' --include 'bg.png' --exclude *.swp --exclude *basemap* --include 'fantasy/*' --include 'experiments/*' --exclude '*.png' --exclude '*.svg' arapp_arapp@ssh.nyc1.nearlyfreespeech.net:.

.PHONY: all $(targets) rsync
