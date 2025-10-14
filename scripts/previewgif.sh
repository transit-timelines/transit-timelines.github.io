#!/bin/bash
pushd $1
mkdir -p anim
nonempty=false
for i in [0-9]*.svg; do
  if grep 'stroke-width:[2-5]' $i | grep -v 'stroke:none' >/dev/null; then nonempty=true; fi
  if $nonempty; then
    if [ -f anim/`basename $i` ]; then
      rm anim/`basename $i`
    fi
    if [ -f water.svg ]; then
      sed -e's!</svg>!!' water.svg > anim/`basename $i`
    fi
    ~/timelines/scripts/hideyear.pl $i >> anim/`basename $i`
  fi
done
cd anim
for i in `ls *.svg | sort -g`; do
  echo -n "$1/$i "
  width=$(grep '^   width=' $i | sed -e's/   width="\(.*\)"/\1/')
  height=$(grep '^   height=' $i | sed -e's/   height="\(.*\)"/\1/')
  sed -e's!href=".*osm.png"!href="/dev/null"!' $i > osmless-${i}
  inkscape -b '#ffffff' -y 255 -w 600 -o ${i}.png osmless-${i} >/dev/null 2>&1
  convert ${i}.png ${i}.gif
done
echo ""
if [ `ls *.svg.gif | wc -l` -gt 1 ]; then
  gifsicle -l -d 100 --colors 256 `ls *.svg.gif | tail -n1` *.svg.gif > ../preview.gif
else
  mv *.svg.gif ../preview.gif
fi
cd ..
rm -r anim
popd
