CITIES=athens-350 rome-200 rome300 constantinople500 changan700 hangzhou1200 milan1200 cairo1300 london1300 lisbon1400 paris1400 seoul1400 beijing1500 naples1500 seville1500 tenochtitlan1500 moscow1600 beijing1800

all: index.html $(CITIES:0=0.svg.gz) $(CITIES:0=0-rt.svg.gz)

%.svg.gz : %.svg
	~/timelines/scripts/round.py < $< > $<.tmp
	mv $<.tmp $<
	gzip -f --keep $<

%0.svg: ../%0.svg
	sed -e's/808080/c0c0c0/' $< > $@

athens-350-rt.svg: athens-350.svg ../../timelines/ath/2025.svg 
rome-200-rt.svg: rome-200.svg ../../timelines/rom/2025.svg
rome300-rt.svg: rome300.svg ../../timelines/rom/2025.svg
constantinople500-rt.svg: constantinople500.svg ../../timelines/ist/2025.svg
changan700-rt.svg: changan700.svg ../../timelines/xiy/2025.svg
hangzhou1200-rt.svg: hangzhou1200.svg ../../timelines/hgh/2025.svg
milan1200-rt.svg: milan1200.svg ../../timelines/mil/2025.svg
cairo1300-rt.svg: cairo1300.svg ../../timelines/cai/2025.svg
london1300-rt.svg: london1300.svg ../../timelines/lon/2025.svg
lisbon1400-rt.svg: lisbon1400.svg ../../timelines/lis/2025.svg
paris1400-rt.svg: paris1400.svg ../../timelines/par/2025.svg
seoul1400-rt.svg: seoul1400.svg ../../timelines/sel/2025.svg
beijing1500-rt.svg: beijing1500.svg ../../timelines/bjs/2025.svg
naples1500-rt.svg: naples1500.svg ../../timelines/nap/2025.svg
seville1500-rt.svg: seville1500.svg ../../timelines/svq/2025.svg
tenochtitlan1500-rt.svg: tenochtitlan1500.svg ../../timelines/mex/2025.svg
moscow1600-rt.svg: moscow1600.svg ../../timelines/mow/2025.svg
beijing1800-rt.svg: beijing1800.svg ../../timelines/bjs/2025.svg

$(CITIES:0=0-rt.svg):
	~/timelines/scripts/rtoverlay.pl $^ > $@

index.html: names sources ../makeindex.sh $(CITIES:0=0.svg) $(CITIES:0=0-rt.svg)
	../makeindex.sh $(CITIES:0=0.svg) | grep -v '<meta.*image' > $@
