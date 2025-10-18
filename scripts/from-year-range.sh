#!/bin/bash
scriptdir=$(dirname $0)
smalldir=$1/small
if [ -L $smalldir ]; then
    exit
fi
infile=`ls $1/*.svg | head -n1`
if grep '>....-....</tspan>' $infile >/dev/null; then
    a=`grep '>....-....</tspan>' $infile | head -n1 | sed -e's/.*>\(....\)-.*/\1/'`
    b=`grep '>....-....</tspan>' $infile | head -n1 | sed -e's/.*>....-\(....\).*/\1/'`
    echo $infile $smalldir $a $b
    for k in `seq $a 5 $b`; do
        ${scriptdir}/hideyear.pl $infile | sed -e"s!>....-....</tspan>!>$k</tspan>!" > ${smalldir}/$k.svg
        gzip -f --keep ${smalldir}/$k.svg
    done
fi
