#!/bin/bash
source $(dirname $0)/apikeys

if [ $# -lt 5 ]; then
    zoom=14
else
    zoom=$5
fi
for i in `seq $1 $2`; do
    mkdir -p $i; cd $i
    for j in `seq $3 $4`; do
        if [ ! -f $j.png ]; then
            echo https://a.tile.thunderforest.com/transport/${zoom}/${i}/${j}.png?${TFORESTKEY}
        fi
    done | xargs wget -T 60 -c; rename s/.apikey=.*// *.png*; cd ..
done
for i in `seq $1 $2`; do
    montage -mode Concatenate -tile 1x`expr $4 - $3 + 1` `seq $3 $4 | sed -e's/$/.png/' | sed -e"s!^!$i/!"` $i.png
done
montage -mode Concatenate -tile `expr $2 - $1 + 1`x1 `seq $1 $2 | sed -e's/$/.png/'` osm.png
