#!/bin/bash
pushd $1 >/dev/null

SCRIPTDIR=$(dirname $0)
START=$(basename $(grep -l 'stroke-width:5' [0-9]*.svg | sort -g | head -n1) .svg)
END=$(basename $(grep -l 'stroke-width:5' [0-9]*.svg | sort -g | tail -n1) .svg)
STEP=25
FINALSTEP=$((($END - $START) % $STEP))
if [ $FINALSTEP -gt 0 ] && [ $END != $START ]; then
    COUNT=$((2 + ( $END - $FINALSTEP - $START ) / $STEP))
else    
    COUNT=$((1 + ( $END - $START ) / $STEP))
fi
INDEX="count-1"
DISPLAY=$END
NAME=`cat name | sed -e's/<br>/ /'`
SCALE=$2
NATIVEW=$(grep '^   width=' ${END}.svg | head -n1 | sed -e's/"$//; s/.*"//;')
W=$(awk "BEGIN{print int(0.5+$(grep '^   width=' ${END}.svg | head -n1 | sed -e's/"$//; s/.*"//;')*${SCALE}/17.25)}")
H=$(awk "BEGIN{print int(0.5+$(grep '^   height=' ${END}.svg | head -n1 | sed -e's/"$//; s/.*"//;')*$W/$NATIVEW)}")
DIRNAME=$(basename $(realpath $1))
PREVDIM=$(file preview.gif | sed -e's/.* \([0-9]* x [0-9]*\).*/\1/')
cat <<HEREDOC | sed -e"s/START/${START}/g;
s/COUNT/${COUNT}/g; 
s!NAME!${NAME}!g;
s/DISPLAY/${DISPLAY}/g;
s/INDEX/${INDEX}/g;
s!URL!${DIRNAME}!g;
s/PREVW/${PREVDIM% x*}/g;
s/PREVH/${PREVDIM#*x }/g;
s/START/${START}/g;
s/END/${END}/g;
s/STEP/${STEP}/g;"
<!DOCTYPE HTML>
<html>
<head><title>NAME Passenger Rail Timeline</title>
<meta http-equiv="Content-type" content="text/html;charset=UTF-8">
<meta property="og:type" content="website" />
<meta property="og:title" content="NAME Passenger Rail Timeline" />
<meta property="og:image" content="https://alexander.co.tz/timelines/misc/URL/preview.gif" />
<meta property="og:image:width" content="PREVW" />
<meta property="og:image:height" content="PREVH" />
<meta property="og:url" content="https://alexander.co.tz/timelines/misc/URL/preview.gif" />
<meta property="og:description" content="Maps every STEP years, START-END" />
<meta name="twitter:card" content="summary_large_image" />
<style type="text/css">
div#preloader {
    position: absolute;
    left: -9999px;
    top:  -9999px;
}
div#preloader img {
    display: block;
}
img {
    border: 1px solid;
}
body {
    text-align: center;
}
</style>
<script language="JavaScript" type="text/javascript">
start=START;
count=COUNT;
step=STEP;
end=END;
index=count-1;
function update() {
    if (index == count - 1) {
        year = end;
    } else {
        year = start+step*index;
    }
    map = document.getElementById("map");
    map.src=year + ".svg";
    map.title=year;
    map.alt=year + " map";
    location.replace("#" + (year));
}
function nextmap() {
    index=(index+1)%count;
    update();
}
function prevmap() {
    index=(index+count-1)%count;
    update();
}
document.onkeydown=function(keypress) {
    if(keypress.which == 65) { prevmap(); }
    if(keypress.which == 83) { nextmap(); }
}
function gotoyear(x) {
    inyear = parseInt(x);
    if( start <= inyear & inyear <= start+step*count & !((inyear-start) % step) ) {
        index = (inyear-start)/step;
        update();
    }
}
intervalID=0;
function startanim() {
    intervalID = setInterval(nextmap, 1000);
    animbutton = document.getElementById("animbutton");
    animbutton.onclick = stopanim;
    animbutton.innerText = "click here to stop animation";
}
function stopanim() {
    clearInterval(intervalID);
    animbutton = document.getElementById("animbutton");
    animbutton.onclick = startanim;
    animbutton.innerText = "click here to animate";
}
function showbg() {
    bgimg = document.getElementById("bg");
    bgimg.style.display = 'inline-block'
    bgbutton = document.getElementById("bgbutton");
    bgbutton.onclick = hidebg;
    bgbutton.innerText = "click here to hide present-day labels"
}
function hidebg() {
    bgimg = document.getElementById("bg");
    bgimg.style.display = 'none'
    bgbutton = document.getElementById("bgbutton");
    bgbutton.onclick = showbg;
    bgbutton.innerText = "click here to show present-day labels"
}
window.onload=function() {
    gotoyear(location.hash.substring(1));
}
window.onhashchange=function() {
    gotoyear(location.hash.substring(1));
}
</script>
<script type="text/javascript">
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-19998781-1']);
  _gaq.push(['_trackPageview']);
  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
</script>
</head><body>
<h3>NAME Passenger Rail Timeline</h3>
HEREDOC
if [ $SCALE = 2 ]; then
  echo 'smaller version --- <a href="large.html">larger version</a>'
else
  echo '<a href=".">smaller version</a> --- larger version'
fi
cat <<HEREDOC | sed -e"s/STEP/${STEP}/g"
<p>
<a href="javascript:" onclick="prevmap()">STEP years earlier (or press a)</a> ---
<a href="javascript:" onclick="nextmap()">STEP years later (or press s)</a>
<br>
<a id="animbutton" href="javascript:" onclick="startanim()">click here to animate</a>
<p>
<a href="javascript:" onclick="nextmap()">
HEREDOC
if [ -f water.svg ]; then
    echo '<img id="water" src="water.svg" style="position:absolute; z-index: -2" width="'${W}'" height="'${H}'">'
fi
if [ -f bg.png ] && [ $SCALE = 2 ]; then
    echo '<img id="bg" src="bg.png" style="position:absolute; z-index: -1; display:none" width="'${W}'" height="'${H}'">'
elif [ -f large-bg.png ]; then
    echo '<img id="bg" src="large-bg.png" style="position:absolute; z-index: -1; display:none" width="'${W}'" height="'${H}'">'
fi
echo '<img id="map" src="'$END'.svg" title="'$END'" alt="'$END' map" width="'${W}'" height="'${H}'">'
echo '</a>'
echo '<p>'
for year in $(seq $START $STEP $END); do
    echo \<a href=\"#${year}\" onclick=\"gotoyear\(${year}\)\"\>${year}\</a\>
done
if [ $FINALSTEP -gt 0 ] && [ $END != $START ]; then
    echo \<a href=\"#${END}\" onclick=\"gotoyear\(${END}\)\"\>${END}\</a\>
fi
cat <<HEREDOC | sed -e"s/STEP/${STEP}/g"
<p>
<a href="javascript:" onclick="prevmap()">STEP years earlier (or press a)</a> --- 
<a href="javascript:" onclick="nextmap()">STEP years later (or press s)</a>
<p>
HEREDOC
if [ -f bg.png ]; then
    echo '<a id="bgbutton" href="javascript:" onclick="showbg()">click here to show present-day labels</a><p>'
fi
cat <<HEREDOC
Showing rail lines with at least three trains each weekday.  Lines coloured by operator (<a href="colours.html">key</a>).<br>
Local tramways (without priority at road crossings) and horse-drawn lines not shown.<br>
HEREDOC
echo 'Scale: <svg width="'`echo 100*${SCALE} | bc`'px" height="3px" style="vertical-align: middle; stroke-width: 0px; background-color: black;"/> ≈ 100 km (approximately '${SCALE}' CSS pixels per km)'
cat <<HEREDOC
<p>
Please send any corrections or questions to threestationsquare at gmail dot com.
<p>
<div id="preloader">
HEREDOC
for year in $(seq $START $STEP $END); do
    echo \<img src=\"${year}.svg\" width=\"1\" height=\"1\" alt=\"\"\>
done
echo '</div>'
first=1
for link in nerail carail; do
    if [ $DIRNAME = $link ]; then continue; fi
    if [ $first = 1 ]; then
        echo -n "See also: "
        first=0
    else
        echo " - "
    fi
    echo -n '<a href="../'$link'">'`cat ~/timelines/timelines/misc/${link}/name`' passenger rail timeline</a>'
done
echo ''
if [ -f seealso ]; then
  cat seealso
fi
echo '<br>'
first=1
for city in `cat cities`; do
    if [ $first = 1 ]; then
        echo -n "rapid transit timelines for "
        first=0
    else
        echo " - "
    fi
    echo -n '<a href="../../'${city}'">'$(cat ~/timelines/timelines/${city}/name)"</a>"
done
cat <<HEREDOC

<br>
<a href="../..">other rapid transit timelines</a> -
<a href="..">miscellaneous timelines and maps</a>
HEREDOC
cat ${SCRIPTDIR}/template/part4

popd >/dev/null
