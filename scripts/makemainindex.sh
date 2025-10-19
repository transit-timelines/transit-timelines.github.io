#!/bin/bash
SCRIPTDIR=$(dirname $0)
cat <<HEREDOC
<!DOCTYPE HTML>
<html>
<head><title>Rapid Transit Timelines and Scale Comparison</title>
<meta http-equiv="Content-type" content="text/html;charset=UTF-8" />
<meta property="og:type" content="website" />
<meta property="og:title" content="Rapid Transit Timelines and Scale Comparison" />
<meta property="og:image" content="https://alexander.co.tz/timelines/preview.png" />
<meta property="og:description" content="Maps every 5 years, 1840-2025" />
<meta name="twitter:card" content="summary_large_image" />
<style type="text/css">
div#preloader {
    position: absolute;
    left: -9999px;
    top: -9999px;
}
div#preloader img {
    width: 1px;
    height: 1px;
    display: block;
}
a:link.map-wrap {
    text-decoration: none;
}
div#sidebar {
    float: left;
    background: #ffffff;
    border: 1px solid;
    width: 10.5em;
    max-height: calc(100% - 22px);
    top: 0;
    left: 0;
    margin: 5px;
    padding: 5px;
    position: fixed;
    display: flex;
    flex-flow: column;
    text-align: left;
}
div#form {
    flex: 1;
    overflow: auto;
}
div#button a:link {
    color: #000000;
    text-decoration: none;
}
div#button a:visited {
    color: #000000;
    text-decoration: none;
}
span {
    margin-top: 10px;
    margin-bottom: 10px;
    vertical-align: middle;
}
.map {
    border: 1px solid;
    margin-left: 10px;
    margin-right: 10px;
}
.headerfooter {
    padding-left: calc(10.5em + 22px);
    padding-right: calc(10.5em + 22px);
    white-space: nowrap;
}
body {
    text-align: center;
}
</style>
<script type="text/javascript">
HEREDOC
start=$(for city in $@; do ls $city/????.svg; done | sed -e's!^.../\(....\).svg!\1!' | sort | head -n 1)
echo "start=${start};"
echo -n "count="
expr 1 + \( \( 2025 - $start \) / 5 \) | sed -e's/$/;/'
echo -n "citylist = ["
for city in $@; do echo -n '"'$city'",'; done | tr 'a-z' 'A-Z' | sed -e's/,$/];/'
echo ''
echo -n "citystartyears = { "
for city in $@; do
  echo -n "${city}: "$(ls $city/small/????.svg | sed -e's!^.../small/\(....\).svg!\1!' | sort | head -n 1)", "
done
echo "};"
cat <<HEREDOC
step=5;
index=count-1;
function update(city) {
    yr = start+step*index;
    mapimg = document.getElementById(city + "map");
    if (yr < citystartyears[city.toLowerCase()]) {
        mapimg.src = encodeURI('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ' + mapimg.width + ' ' + mapimg.height + '"><text style="font-size:10.435;font-family:Sans;fill:%23000000" x="6.482" y="14.997"><tspan>' + yr + '</tspan></text></svg>');
    } else {
        mapimg.src = (city.toLowerCase() + "/small/" + (yr) + ".svg");
    }
    mapimg.setAttribute("title", yr);
    mapimg.setAttribute("alt", yr + " map");
}
function updateall() {
    citylist.forEach(function (city) {
        if (document.getElementById(city).style.display == "inline-block") {
            update(city);
        }
    });
}
function nextmap() {
    index = (index+1)%count;
    updateall();
}
function prevmap() {
    index = (index+count-1)%count;
    updateall();
}
function toggleshow(x) {
    span = document.getElementById(x);
    checkboxes = document.getElementsByClassName(x + "checkbox");
    if (span.style.display == 'inline-block') {
        mapimg = document.getElementById(x + "map");
        span.style.display = 'none';
        if (mapimg.tagName.toUpperCase() == "IMG") mapimg.src = "date:";
        prediv = document.getElementById(x + "pre");
        prediv.parentNode.removeChild(prediv);
        for (var i=0; i < checkboxes.length; i++ ) { checkboxes[i].checked = false; }
    } else {
        update(x);
        for (var i = citystartyears[x.toLowerCase()]; i < start + count*step; i+=step) {
            prediv = document.createElement("div");
            prediv.id = x + "pre";
            img = document.createElement("img");
            img.src = x.toLowerCase() + '/small/' + i + '.svg';
            img.width = "1"; img.height = "1"; img.alt = "";
            prediv.appendChild(img);
            document.getElementById("preloader").appendChild(prediv);
        }
        span.style.display = 'inline-block';
        for (var i=0; i < checkboxes.length; i++ ) { checkboxes[i].checked = true; }
    }
}
function togglesidebar() {
    f = document.getElementById("form");
    s = document.getElementById("showall");
    h = document.getElementById("hideall");
    a = document.getElementById("collapse");
    m = document.getElementById("maps");
    if (f.style.display == 'block') {
        f.style.display = 'none';
        s.style.display = 'none';
        h.style.display = 'none';
        a.innerHTML = "[+]";
        m.style.paddingLeft = "0";
    } else {
        f.style.display = 'block';
        s.style.display = 'block';
        h.style.display = 'block';
        a.innerHTML = "[&minus;]";
        m.style.paddingLeft = "calc(10.5em + 22px)";
    }
}
function selectall(i) {
    spans = document.getElementsByTagName("span");
    if (i < spans.length) {
        if (spans[i].style.display == 'none') {
            toggleshow(spans[i].id);
        }
        setTimeout(function(){ selectall(i+1) }, 1);
    }
}
function deselectall() {
    spans = document.getElementsByTagName("span");
    for (var i=0; i < spans.length; i++) {
        if (spans[i].style.display == 'inline-block') {
            toggleshow(spans[i].id);
        }
    }
}
function sidebarclick(x) {
    span = document.getElementById(x);
    if (span.style.display == 'none') {
        toggleshow(x);
    }
    span.scrollIntoView();
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

document.onkeydown=function(keypress) {
    if(keypress.which == 65) { prevmap(); }
    if(keypress.which == 83) { nextmap(); }
}
window.onload=function() {
    inyear = parseInt(location.hash.substring(1));
    if( start < inyear & inyear < start+step*count & !(inyear % step) ) {
        index = (inyear-start)/step;
        updateall();
    }
}
function clicktohide() {
    citylist.forEach(function (city) {
        imga = document.getElementById(city).getElementsByTagName("a")[1];
        imga.href = "javascript:toggleshow('" + city + "')"
    });
}
function unclicktohide() {
    citylist.forEach(function (city) {
        span = document.getElementById(city);
        span.getElementsByTagName("a")[1].href = span.getElementsByTagName("a")[0].href;
    });
}
</script>
</head><body>
<div class="headerfooter">
<h3>Rapid Transit Timelines and Scale Comparison</h3>
<a href="javascript:" onclick="prevmap()">five years earlier (or press a)</a> ---
<a href="javascript:" onclick="nextmap()">five years later (or press s)</a>
<br>
<a id="animbutton" href="javascript:" onclick="startanim()">click here to animate</a>
<br>
<small>(maps ordered by opening date; click a city name in sidebar to jump to its map)</small>
</div>
<br>
<div id="maps" style="padding-left: calc(10.5em + 22px);">
<noscript>Sorry, the maps really don't work without javascript.</noscript>
HEREDOC

for city in $@; do
    NAME=`cat $city/name`
    UPPER=$(echo $city | tr 'a-z' 'A-Z')
    NATIVEW=$(grep ' width="' $city/small/2025.svg | head -n1 | sed -e's/.* width="\([0-9\.]*\)".*/\1/;')
    W=$(awk "BEGIN{print int(0.5+$NATIVEW*10/138)}")
    H=$(awk "BEGIN{print int(0.5+$(grep ' height=' $city/small/2025.svg | head -n1 | sed -e's/.* height="\([0-9\.]*\)".*/\1/;')*$W/$NATIVEW)}")
    if [ -f $city/s ]; then
        echo '<span id="'$UPPER'" style="display: inline-block;"><a href="'$city'">'$NAME'</a><br>'
        echo '    <a href="'$city'" class="map-wrap"><img class="map" id="'$UPPER'map" src="'$city'/small/2025.svg" title="2025" alt="2025 map" width="'${W}'" height="'${H}'"></a></span>'
    else
        echo '<span id="'$UPPER'" style="display: none;"><a href="'$city'">'$NAME'</a><br>'
        echo '    <a href="'$city'" class="map-wrap"><img class="map" id="'$UPPER'map" src="data:" title="2025" alt="2025 map" width="'${W}'" height="'${H}'"></a></span>'
    fi
done

cat <<HEREDOC
</div>
<br>
<div class="headerfooter">
<a href="javascript:" onclick="prevmap()">five years earlier (or press a)</a> --- 
<a href="javascript:" onclick="nextmap()">five years later (or press s)</a>
</div>
<div id=sidebar>
<div id="button" style="position: absolute; right: 5px;" onclick="togglesidebar()"><a id="collapse" href="javascript:">[&minus;]</a></div>
<div style="padding-right: 2em;">Cities to show:</div>
<div id="form" style="display: block;">
HEREDOC
for city in $@; do
    perl -e'
        $city = $ARGV[0];
        $upper = $city;
        $upper =~ tr/a-z/A-Z/;
        $name = `cat $city/name`;
        $name =~ s/<br>/ /;
        $name =~ s/Naberezhnye/Nab./;
        chomp $name;
        foreach ( split(/ \/ /, $name) ) {
            if (-e "$city/s") {
                print "$_ AA<input type=\"checkbox\" class=\"${upper}checkbox\" onclick=\"toggleshow(\x27${upper}\x27)\" autocomplete=\"off\" checked><a href=\"javascript:sidebarclick(\x27${upper}\x27)\">$_</a><br>\n";
            } else {
                print "$_ AA<input type=\"checkbox\" class=\"${upper}checkbox\" onclick=\"toggleshow(\x27${upper}\x27)\" autocomplete=\"off\"><a href=\"javascript:sidebarclick(\x27${upper}\x27)\">$_</a><br>\n";
            }
        }' $city
done | sort | sed -e's/.* AA<input/<input/;'
cat <<HEREDOC
</div>
<div id="showall" style="display: block;"><a href="javascript:selectall(0)">show all</a></div>
<div id="hideall" style="display: block;"><a href="javascript:deselectall()">hide all</a></div>
</div>
<br>
<div class="headerfooter">
<div style="white-space: normal;">
Based on frequent midday service at the end of the year in question (<a href="notes.html">notes</a>).<br>
Scale: <svg width="100px" height="3px" style="vertical-align: middle; stroke-width: 0px; background-color: black;"/> = 10 km (10 CSS pixels per km)</div>
<p>
Please send any corrections or questions to threestationsquare at gmail dot com.
<p>
See also: <a href="misc">miscellaneous timelines and maps</a>
<div id=preloader>
HEREDOC
for city in $@; do if [ -f $city/s ]; then
    UPPER=`echo $city | tr 'a-z' 'A-Z'`
    echo '<div id="'$UPPER'pre">'
    for yr in $(seq ${start} 5 2025); do
        if [ -f $city/small/$yr.svg ]; then
            echo '<img src="'${city}'/small/'${yr}'.svg" alt="">'
        fi
    done
    echo '</div>'
fi; done
echo '</div>'
sed -e's!</div>!</div></div>!' ${SCRIPTDIR}/template/part4
