#!/bin/bash
INDEX=0
for i in $@; do
    if [ $INDEX == 0 ]; then
        WIDTH=$i
    else
        inkscape -b ffffff -y 255 -w $WIDTH -o `basename $i .svg`.png $i
    fi
    INDEX=`expr $INDEX + 1`
done
