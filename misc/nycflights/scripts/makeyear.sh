#!/bin/bash

cp scripts/head.svg ${1}.svg
for i in `cat routes${1} | sed -e's/^...-//' | sort | uniq`; do scripts/path.pl ${i}; done >> ${1}.svg
for i in `cat routes${1} | sed -e's/^...-//' | sort | uniq`; do scripts/circ.pl ${i}; done >> ${1}.svg
echo '<text x="89.453125" y="206.96094" id="yearlabel" style="font-style:normal;font-weight:normal;font-size:144px;line-height:125%;font-family:Sans;-inkscape-font-specification:Sans;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none">' >> ${1}.svg
echo '<tspan x="89.453125" y="206.96094" id="tspan1">'${1}'</tspan></text>' >> ${1}.svg
echo '</svg>' >> ${1}.svg
