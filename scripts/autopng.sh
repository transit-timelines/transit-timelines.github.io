#!/bin/bash
for i in $@; do
    b=`basename $i .svg`
    if [ $i -nt ${b}.png ]; then
        inkscape -b ffffff -y 255 -d 20.87 -o ${b}-24bit.png ${b}.svg
        convert ${b}-24bit.png -type palette PNG8:${b}.png
        rm ${b}-24bit.png
    fi
done
