#!/bin/bash
if [ $# -lt 5 ]; then
    zoom=14
else
    zoom=$5
fi
for i in `seq $1 $2`; do
    mkdir -p $i; cd $i
    for j in `seq $3 $4`; do
    echo https://c.tiles.openrailwaymap.org/standard/$zoom/$i/$j.png
    done | xargs wget -U "base maps for https://alexander.co.tz/timelines/ contact threestationsquare@gmail.com" -T 60 -c; cd ..
done
for i in `seq $1 $2`; do
    montage -mode Concatenate -tile 1x`expr $4 - $3 + 1` `seq $3 $4 | sed -e"s!\(.*\)!$i/\1.png!"` $i.png
done
montage -mode Concatenate -tile `expr $2 - $1 + 1`x1 `seq $1 $2 | sed -e's/$/.png/'` railosm.png
