CITIES=athens-350 rome-200 rome300 constantinople500 changan700 hangzhou1200 milan1200 cairo1300 london1300 lisbon1400 paris1400 seoul1400 beijing1500 naples1500 seville1500 tenochtitlan1500 moscow1600 beijing1800

all: index.html $(CITIES:0=0.svg) $(CITIES:0=0-rt.svg)

%0.svg: ../%0.svg
	sed -e's/808080/c0c0c0/' $< > $@

athens-350-rt.svg: athens-350.svg ../../ath/2025.svg 
rome-200-rt.svg: rome-200.svg ../../rom/2025.svg
rome300-rt.svg: rome300.svg ../../rom/2025.svg
constantinople500-rt.svg: constantinople500.svg ../../ist/2025.svg
changan700-rt.svg: changan700.svg ../../xiy/2025.svg
hangzhou1200-rt.svg: hangzhou1200.svg ../../hgh/2025.svg
milan1200-rt.svg: milan1200.svg ../../mil/2025.svg
cairo1300-rt.svg: cairo1300.svg ../../cai/2025.svg
london1300-rt.svg: london1300.svg ../../lon/2025.svg
lisbon1400-rt.svg: lisbon1400.svg ../../lis/2025.svg
paris1400-rt.svg: paris1400.svg ../../par/2025.svg
seoul1400-rt.svg: seoul1400.svg ../../sel/2025.svg
beijing1500-rt.svg: beijing1500.svg ../../bjs/2025.svg
naples1500-rt.svg: naples1500.svg ../../nap/2025.svg
seville1500-rt.svg: seville1500.svg ../../svq/2025.svg
tenochtitlan1500-rt.svg: tenochtitlan1500.svg ../../mex/2025.svg
moscow1600-rt.svg: moscow1600.svg ../../mow/2025.svg
beijing1800-rt.svg: beijing1800.svg ../../bjs/2025.svg

$(CITIES:0=0-rt.svg):
	~/timelines/scripts/rtoverlay.pl $^ > $@

index.html: names sources ../makeindex.sh $(CITIES:0=0.svg) $(CITIES:0=0-rt.svg)
	../makeindex.sh $(CITIES:0=0.svg) | grep -v '<meta.*image' > $@

.PHONY: all
