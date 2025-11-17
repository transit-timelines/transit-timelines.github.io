#!/bin/bash
cat <<HEREDOC
<!DOCTYPE HTML>
<html>
<head><title>Tramway (Streetcar & Light Rail) Scale Comparison</title>
<meta property="og:type" content="website" />
<meta property="og:title" content="Tramway (Streetcar & Light Rail) Scale Comparison" />
<meta property="og:image" content="https://transit-timelines.github.io/tramscale/preview.png" />
<meta name="twitter:card" content="summary_large_image" />
<meta name="viewport" content="width=1500" />
<style type="text/css">
body {
    margin-left: 1px;
    margin-right: 1px;
    text-align: center;
}
span {
    margin-top: 10px;
    margin-bottom: 10px;
}
.map, .bgmap {
    border: 1px solid;
    margin-left: 10px;
    margin-right: 10px;
}
div#sidebar {
    float: left;
    background: #ffffff;
    border: 1px solid;
    width: 10.5em;
    max-height: calc(100% - 17px);
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
.headerfooter {
    margin-left: calc(10.5em + 22px);
    margin-right: calc(10.5em + 22px);
    white-space: nowrap;
}
</style>
<script language="JavaScript" type="text/javascript">
function toggleshow(x) {
    span = document.getElementById(x);
    checkboxes = document.getElementsByClassName(x + "checkbox");
    if (span.style.display == 'inline-block') {
        span.style.display = 'none';
        for (var i=0; i < checkboxes.length; i++ ) { checkboxes[i].checked = false; }
    } else {
        span.style.display = 'inline-block';
        for (bgimg of span.getElementsByClassName("bgmap")) { bgimg.src = x.toLowerCase() + "-bg.png"; }
        for (var i=0; i < checkboxes.length; i++ ) { checkboxes[i].checked = true; }
    }
}
function checkboxclick(x) {
    location.replace("#");
    toggleshow(x);
}
function sidebarclick(x) {
    span = document.getElementById(x);
    if (span.style.display == 'none') {
        toggleshow(x);
    }
    span.scrollIntoView();
    location.replace("#" + (x));
}
function selectall() {
    location.replace("#showall");
    spans = document.getElementsByTagName("span");
    for (var i=0; i < spans.length; i++) {
        if (spans[i].style.display == 'none') {
            toggleshow(spans[i].id);
        }
    }
}
function deselectall() {
    location.replace("#hideall");
    spans = document.getElementsByTagName("span");
    for (var i=0; i < spans.length; i++) {
        if (spans[i].style.display == 'inline-block') {
            toggleshow(spans[i].id);
        }
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
        m.style.paddingLeft = "calc(10.5em + 17px)";
    }
}
function showbg() { 
    for (bgimg of document.getElementsByClassName("bgmap")) {
        bgimg.style.display = 'inline-block';
        bgimg.src = bgimg.parentElement.id.toLowerCase() + "-bg.png";
    }   
    bgbutton = document.getElementById("bgbutton");
    bgbutton.onclick = hidebg;
    bgbutton.innterText = "click here to hide labels and waterlines";
}           
function hidebg() {
    for (bgimg of document.getElementsByClassName("bgmap")) {
        bgimg.style.display = 'none';
    }
    bgbutton = document.getElementById("bgbutton");
    bgbutton.onclick = showbg;
    bgbutton.innterText = "click here to show labels and waterlines";
}
window.onhashchange=function() {
    location.hash.split("#").forEach(function(x) {
        if (x == "showall") {
            selectall();
        } else if (x == "hideall") {
            deselectall();
        } else if (x.length == 3) {
            sidebarclick(x);
        }
    });
}
window.onload=window.onhashchange;
</script>
<meta http-equiv="Content-type" content="text/html;charset=UTF-8">
<h3>Tramway (Streetcar & Light Rail) Scale Comparison</h3>
<div id="maps" style="padding-left: calc(10.5em + 17px);">
HEREDOC
CITIES=$(for file in $@; do grep -P "^`basename $file .svg`@?\t" names | sed -e's/<br>/ /; s/ (.*//; s/\(.*\)@*\t\(.*\)/\2 AA\1/;'; done | sort | sed -e's/.* AA//; s/@//;')
for city in $CITIES; do
    NAME=`grep -P "^$city@?\t" names | sed -e's/.*\t//'`
    SNAME=`echo $NAME | sed -e's/<br>/ /; s/ (.*//;'`
    UPPER=$(echo $city | tr 'a-z' 'A-Z')
    NATIVEW=$(grep '^   width="' ${city}.svg | head -n1 | sed -e's/.* width="\([0-9\.]*\)".*/\1/;')
    W=$(awk "BEGIN{print int(0.5+$NATIVEW*30/138)}")
    H=$(awk "BEGIN{print int(0.5+$(grep ' height=' ${city}.svg | head -n1 | sed -e's/.* height="\([0-9\.]*\)".*/\1/;')*$W/$NATIVEW)}")
    if ( grep -P "^$city@\t" names >/dev/null); then
        echo '<span id="'$UPPER'" style="display: inline-block; vertical-align: middle">'$NAME'<br>'
    else
        echo '<span id="'$UPPER'" style="display: none; vertical-align: middle">'$NAME'<br>'
    fi
    echo '    <img class="bgmap" src="data:," style="position:absolute; z-index: -1; display:none" width="'$W'" height="'$H'">'
    echo '    <img class="map" src="'${city}.svg'" title="'$SNAME'" alt="'$SNAME' map" width="'$W'" height="'$H'"></span>'
done
cat <<HEREDOC
</div>
<div id="sidebar">
<div id="button" style="position: absolute; right: 5px;" onclick="togglesidebar()"><a id="collapse" href="javascript:">[&minus;]</a></div>
<div style="padding-right: 2em;">Cities to show:</div>
<div id="form" style="display: block;">
HEREDOC
for city in $CITIES; do
    perl -e'
        $city = $ARGV[0];
        $upper = $city;
        $upper =~ tr/a-z/A-Z/;
        $name = `grep -P "^$city@?\t" names`;
        $name =~ s/<br>/ /;
        $name =~ s/ \(.*//;
        $show = ($name =~ /@/);
        $name =~ s/^.*\t//;
        $name =~ s/Naberezhnye/Nab./;
        chomp $name;
        foreach ( split(/ \/ /, $name) ) {
            $sortname = $_ =~ s/(.*) ([0-9]*)/$2 $1/r;
            if ($show) {
                print "$sortname AA<input type=\"checkbox\" class=\"${upper}checkbox\" onclick=\"checkboxclick(\x27${upper}\x27)\" autocomplete=\"off\" checked><a href=\"javascript:sidebarclick(\x27${upper}\x27)\">$_</a><br>\n";
            } else {
                print "$sortname AA<input type=\"checkbox\" id=\"${upper}checkbox${id}\" class=\"${upper}checkbox\" onclick=\"checkboxclick(\x27${upper}\x27)\" autocomplete=\"off\"><a href=\"javascript:sidebarclick(\x27${upper}\x27)\">$_</a><br>\n";
            }
    }' $city
done | sort | sed -e's/.* AA<input/<input/;'
cat <<HEREDOC
</div>
<div id="showall" style="display: block;"><a href="javascript:selectall()">show all</a></div>
<div id="hideall" style="display: block;"><a href="javascript:deselectall()">hide all</a></div>
</div>
<br>
<div class="headerfooter">
<div style="white-space: normal;">
<a id="bgbutton" href="javascript:" onclick="showbg()">click here to show labels and waterlines</a><p>
Thick lines represent running in streets or with uncontrolled or light-controlled grade crossings; thin lines represent thru-running onto sections with grade-separations or crossing gates.<br>Other frequent local rail/fixed-guideway transit lines are shown in light gray, ferries in cyan.<br>All lines shown run at least every 20 minutes during the day on weekdays as of 2025.<br>
Scale: <svg width="300px" height="3px" style="vertical-align: middle; stroke-width: 0px; background-color: black;"/> = 10 km (30 CSS pixels per km)</div>
<p>
Please send any corrections or questions to threestationsquare at gmail dot com.
<p>
See also: <a href="..">rapid transit timelines</a> - <a href="../misc/">miscellaneous timelines and maps</a>
HEREDOC
sed -e's!</div>!</div></div>!; s/image/images/;' ../scripts/template/part4b
