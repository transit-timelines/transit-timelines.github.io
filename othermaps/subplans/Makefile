all: large.html index.html

NYC=nyc1935a.svg nyc1939plan.svg nyc1965a.svg nyc1968plan.svg nyc2025a.svg
BOS=bos1892plan.svg bos1915a.svg bos1917plan.svg bos1945a.svg bos1945plan.svg bos2025a.svg
PIT=pit1965a.svg pit1967plan.svg pit1970plan.svg pit2025a.svg
SFO=sfo1935a.svg sfo1935plan.svg sfo1945a.svg sfo1948plan.svg sfo1956plan.svg sfo1961plan.svg sfo2025a.svg
SEA=sea1970plan.svg sea2000a.svg sea2002plan.svg sea2015a.svg sea2016plan.svg sea2025a.svg sea2026proj.svg
ZRH=zrh1973plan.svg ../../timelines/zrh/small/2025.svg
PVD=pvd1914.svg pvd1914plan.svg pvd2025.svg
CVG=cvg1920plan.svg
MSY=msy1959plan.svg
MAN=man1970a.svg man1971plan.svg man2025a.svg
BER=../../timelines/ber/small/1955.svg ber1955plan.svg ber1989.svg ber1989west.svg ber1989east.svg ../../timelines/ber/small/1995.svg ber1996plan.svg ../../timelines/ber/small/2025.svg
YMQ=ymq1961plan.svg ymq1970a.svg ymq2015a.svg ymq2016plan.svg ymq2025a.svg

SVGS=$(NYC) $(BER) $(BOS) $(PIT) $(MAN) $(SFO) $(YMQ) $(SEA) $(ZRH) $(PVD) $(CVG) $(MSY)

RECROPPED=bos1915a.svg bos1945a.svg bos2025a.svg pit1965a.svg pit2025a.svg sfo2025a.svg sea2000a.svg sea2015a.svg

nyc%a.svg : ../../timelines/nyc/small/%.svg Makefile
	~/timelines/scripts/reviewbox.pl 0 1950 500 0 $< > $@

bos%a.svg : ../../timelines/bos/small/%.svg Makefile
	~/timelines/scripts/reviewbox.pl 0 -600 0 0 $< > $@

sfo%a.svg : ../../timelines/sfo/small/%.svg Makefile
	~/timelines/scripts/reviewbox.pl -435 -150 -2235 -2350 $< > $@

pit%a.svg : ../../timelines/pit/small/%.svg Makefile
	~/timelines/scripts/reviewbox.pl 1000 -1400 1350 0 $< > $@

sea%a.svg : ../../timelines/sea/small/%.svg Makefile
	~/timelines/scripts/reviewbox.pl -720 -2465 430 2235 $< > $@

ymq%a.svg : ../../timelines/ymq/small/%.svg Makefile
	~/timelines/scripts/reviewbox.pl -2100 -100 0 100 $< > $@

man%a.svg : ../../timelines/man/small/%.svg Makefile
	~/timelines/scripts/reviewbox.pl 2565 2350 15 1550 $< > $@


index.html: names makeindex.sh $(SVGS) ~/timelines/scripts/template/part4b Makefile
	$(foreach svg,$?,if echo $(svg) | grep "svg$$" >/dev/null; then ~/timelines/scripts/round.py $(svg) < $(svg) > $(svg).tmp && mv $(svg).tmp $(svg); fi;)
	./makeindex.sh 10 $(NYC) $(BER) $(BOS) '<br>' $(PIT) $(SFO) $(MAN) '<br>' $(YMQ) $(SEA) $(ZRH) '<br>' $(PVD) $(CVG) $(MSY) > $@

large.html: names makeindex.sh $(SVGS) ~/timelines/scripts/template/part4b Makefile index.html
	./makeindex.sh 30 $(NYC) $(BER) $(BOS) $(PIT) $(SFO) $(MAN) $(YMQ) $(MAN) $(SEA) $(ZRH) $(PVD) $(CVG) $(MSY) > $@
