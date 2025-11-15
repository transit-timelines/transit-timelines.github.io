#!/bin/bash

source $(dirname $0)/apikeys

if [ $# -lt 2 ]; then
    zoom=11
else
    zoom=$2
fi
if [ $# -lt 3 ]; then
    scale="30/138"
else
    scale=$3
fi
tilesize=512
file=$1
bname=`basename $file .svg`
sed -e's/></>\n</g' $file | xmllint --format - | grep -v 'path\|text\|railosm\|tspan' > ${bname}-bg.svg
osmsrc=$(grep '<image' ${bname}-bg.svg | perl -wpe's/.*xlink:href="//; s/".*//;')
if [ ! -f $osmsrc ]; then
    osmsrc="uncropped/${osmsrc}"
fi
left=$(awk '{print $2}' ${osmsrc}-cmd)
right=$(awk '{print $3}' ${osmsrc}-cmd)
top=$(awk '{print $4}' ${osmsrc}-cmd)
bottom=$(awk '{print $5}' ${osmsrc}-cmd)
if awk '{print $6}' ${osmsrc}-cmd | grep '[0-9]' >/dev/null; then
    basezoom=$(awk '{print $6}' ${osmsrc}-cmd)
else
    basezoom=14
fi
zoomfactor=$(( 2 ** ($basezoom - $zoom) ))
width=$(( ($right - $left + 1) * $tilesize / $zoomfactor))
height=$(( ($bottom - $top + 1) * $tilesize / $zoomfactor))
sl=$(( $left / $zoomfactor))
sr=$(( $right / $zoomfactor))
st=$(( $top / $zoomfactor))
sb=$(( $bottom / $zoomfactor))
lmargin=$(( ($left % $zoomfactor) * $tilesize / $zoomfactor ))
tmargin=$(( ($top % $zoomfactor) * $tilesize / $zoomfactor ))
for i in `seq $sl $sr`; do
    mkdir -p $i; cd $i
    for j in `seq $st $sb`; do
        if [ ! -f $j.png ]; then
            echo https://api.maptiler.com/maps/basic-v2/${zoom}/${i}/${j}.png?key=${MAPTILERKEY}
        fi
    done | xargs wget -T 60 -c; rename s/.key=.*// *.png*; cd ..
done
for i in `seq $sl $sr`; do
    montage -mode Concatenate -tile 1x$(($sb - $st + 1)) `seq $st $sb | sed -e"s/$/.png/; s!^!$i/!"` $i.png
done
montage -mode Concatenate -tile $(($sr - $sl + 1))x1 `seq $sl $sr | sed -e's/$/.png/'` ${bname}-bgosm.png
mogrify -crop ${width}x${height}+${lmargin}+${tmargin} ${bname}-bgosm.png
sed -e"s/xlink:href=\".*osm.png/xlink:href=\"${bname}-bgosm.png/; s/display:none/opacity:0.25/;" -i ${bname}-bg.svg
nw=$(grep '^   width=' $file | head -n1 | sed -e's/"$//; s/.*"//;')
w=$(awk "BEGIN{print int(0.5+$(grep '^   width=' $file | head -n1 | sed -e's/"$//; s/.*"//;')*$scale)}")
h=$(awk "BEGIN{print int(0.5+$(grep '^   height=' $file | head -n1 | sed -e's/"$//; s/.*"//;')*$w/$nw)}")
inkscape -b ffffff -y 255 -w $w -h $h -o ${bname}-bg24bit.png ${bname}-bg.svg
convert ${bname}-bg24bit.png -type palette PNG8:${bname}-bgi.png
pngquant --quality=50-70 ${bname}-bgi.png -f -o ${bname}-bg.png
rm -r $(seq $sl $sr)
rm ${bname}-bg24bit.png ${bname}-bgi.png ${bname}-bg.svg $(seq $sl $sr | sed -e's/$/.png/') ${bname}-bgosm.png
