#!/bin/bash
if [ $(basename $(pwd)) = 'rtoverlay' ]; then
    TITLE='Pre-Industrial Walled City \& Modern Rapid Transit Scale Comparison'
else
    TITLE='Pre-Industrial Walled City Scale Comparison'
fi
sed -e"s/TITLE/$TITLE/" <<HEREDOC
<!DOCTYPE HTML>
<html>
<head><title>TITLE</title>
<meta http-equiv="Content-type" content="text/html;charset=UTF-8" />
<meta property="og:type" content="website" />
<meta property="og:title" content="TITLE" />
<meta property="og:image" content="https://transit-timelines.github.io/walledcityscale/preview.png" />
<meta name="twitter:card" content="summary_large_image" />
<meta name="viewport" content="width=device-width, initial-scale=0.3, minimum-scale=0.3" />
<style type="text/css">
* {
    max-height: 999999px;
}
body {
    text-align: center;
    margin-left: 1px;
    margin-right: 1px;
}
span {
    margin-top: 10px;
    margin-bottom: 10px;
}
p, form {
    margin-left: 10px;
    margin-right: 10px;
}
input {
}
span {
    vertical-align: middle;
}
div {
    font-size: medium;
    display: inline-block;
}
.map, .rtmap {
    border: 1px solid;
    margin-left: 10px;
    margin-right: 10px;
}
</style>
<script language="JavaScript" type="text/javascript">
function toggleshow(x) {
    if(document.getElementById(x).style.display=='inline-block') document.getElementById(x).style.display = 'none';
    else document.getElementById(x).style.display = 'inline-block';
}
function selectall() {
    spans = document.getElementsByTagName("span");
    for (var i=0; i < spans.length; i++) {
        if (spans[i].style.display == 'none') {
            document.getElementById(spans[i].id + "checkbox").click();
        }
    }
}
function deselectall() {
    spans = document.getElementsByTagName("span");
    for (var i=0; i < spans.length; i++) {
        if (spans[i].style.display == 'inline-block') {
            document.getElementById(spans[i].id + "checkbox").click();
        }
    }
}
</script>
<meta http-equiv="Content-type" content="text/html;charset=UTF-8"></head><body>
<h3>TITLE</h3>
HEREDOC
sortedcities=`echo $@ | perl -wpe's/([a-z]+)(-?[0-9]+).svg ?/$2 $1\n/g' | sort -g | awk '{print $2$1}'`
for city in $sortedcities; do
    NAME=`grep ^$city names | sed -e's/.*\t//'`
    SNAME=`echo $NAME | sed -e's/<br>.*//; s/,//'`
    UPPER=$(echo $city | tr 'a-z' 'A-Z')
    NATIVEW=$(grep '^   width="' ${city}.svg | head -n1 | sed -e's/.* width="\([0-9\.]*\)".*/\1/;')
    W=$(awk "BEGIN{print int(0.5+$NATIVEW*0.6)}")
    H=$(awk "BEGIN{print int(0.5+$(grep ' height=' ${city}.svg | head -n1 | sed -e's/.* height="\([0-9\.]*\)".*/\1/;')*$W/$NATIVEW)}")
    if ( grep ^$city~ names >/dev/null ); then 
        echo '<span id="'$UPPER'" style="display: none;">'$NAME'<br>'
    else
        echo '<span id="'$UPPER'" style="display: inline-block;">'$NAME'<br>'
    fi
    if [ -f ${city}-rt.svg ]; then
        echo '    <img class="rtmap" src="'${city}'-rt.svg" width="'$W'" height="'$H'" style="position: absolute; z-index: 2;">'
    fi
    echo '    <img class="map" src="'${city}'.svg" title="'$SNAME'" alt="'$SNAME' map" width="'$W'" height="'$H'"></span>'
done
echo '<p>'
if [ $(basename $(pwd)) = 'rtoverlay' ]; then
    echo '<a href="..">versions without rapid transit lines overlaid (with additional cities)</a>'
else
    echo '<a href="rtoverlay">versions with modern rapid transit lines overlaid (where applicable)</a>'
fi
echo '<p>'
echo '<form action="" style="font-size: medium;">Cities to show:'
for city in $sortedcities; do
    NAME=`grep ^$city names | sed -e's/.*\t//; s/<br>.*//; s/,//;'`
    UPPER=$(echo $city | tr 'a-z' 'A-Z')
    if ( grep ^$city~ names >/dev/null ); then 
        echo "<div><input type=\"checkbox\" id=\"${UPPER}checkbox\" onclick=\"toggleshow('$UPPER')\" autocomplete=\"off\">$NAME</div>"
    else
        echo "<div><input type=\"checkbox\" id=\"${UPPER}checkbox\" onclick=\"toggleshow('$UPPER')\" autocomplete=\"off\" checked>$NAME</div>"
    fi
done
cat <<HEREDOC
</form>
<a href="javascript:selectall()">show all</a>
<a href="javascript:deselectall()">hide all</a>
<p>
Scale: <svg width="60px" height="3px" style="vertical-align: middle; stroke-width: 0px; background-color: black;"/> = 1 km (60 CSS pixels per km)
<p>
Population estimates extremely approximate. Please send any corrections or questions to threestationsquare at gmail dot com.
<p>
See also: <a href="..">rapid transit timelines</a> - <a href="../misc/">miscellaneous timelines and maps</a>
<p>
<div style="font-size: x-small;">By <a href="https://alexander.co.tz/">Alexander Rapp</a> (<a rel="license" href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>) based on map data by <a href="http://www.openstreetmap.org">OpenStreetMap</a> and Wikimedia
HEREDOC
echo -n '('
i=1
for src in `cat sources`; do
    echo -n '<a href="'$src'">'$i'</a>,'
    i=`expr $i + 1`
done | sed -e's!,$!) contributors and historical sources.</div></body></html>!'
echo ''
