#!/bin/bash
SCALE=$1
shift
cat <<HEREDOC
<!DOCTYPE HTML>
<html>
<head><title>Unrealised Rapid Transit Plans</title>
<style type="text/css">
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
.map, .bgmap {
    border: 1px solid;
    margin-left: 10px;
    margin-right: 10px;
}
</style>
<script language="JavaScript" type="text/javascript">
posdict = {};
function setsrc(x, url, pos) {
    document.getElementById(x + "map").src = url;
    posdict[x] = pos;
}
function next(x) {
    if (!(x in posdict)) { posdict[x] = 0; }
    var links = document.getElementById(x).getElementsByClassName('setsrc');
    if (posdict[x] + 1 >= links.length) {
        links[0].click();
    } else {
        links[posdict[x]+1].click();
    }
}
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
function showbg() {
    for (bgimg of document.getElementsByClassName("bgmap")) {
        bgimg.style.display = 'inline-block';
    }
    bgbutton = document.getElementById("bgbutton");
    bgbutton.onclick = hidebg;
    bgbutton.innerText = "click here to hide present-day labels and waterlines";
}
function hidebg() {
    for (bgimg of document.getElementsByClassName("bgmap")) {
        bgimg.style.display = 'none';
    }
    bgbutton = document.getElementById("bgbutton");
    bgbutton.onclick = showbg;
    bgbutton.innerText = "click here to show present-day labels and waterlines";
}

window.onload=function() {
    var spans = document.getElementsByTagName('span');
    for (var i=0; i<spans.length; i++) {
        if (document.getElementById(spans[i].id).getElementsByClassName('setsrc')[0].innerHTML.match(/actual/)) {
            next(spans[i].id);
        }
    }
}
document.onkeydown=function(keypress) {
    if(keypress.which == 65) {
        var spans = document.getElementsByTagName('span');
        for (var i=0; i<spans.length; i++) {
            var links = document.getElementById(spans[i].id).getElementsByClassName('setsrc');
            if (!(spans[i].id in posdict)) { posdict[spans[i].id] = 0; }
            if (posdict[spans[i].id] - 1 < 0) {
                links[posdict[spans[i].id] - 1 + links.length].click();
            } else {
                links[posdict[spans[i].id] - 1].click();
            }
        }
    }
    if(keypress.which == 83) {
        var spans = document.getElementsByTagName('span');
        for (var i=0; i<spans.length; i++) {
            next(spans[i].id);
        }
    }
}
</script>
<meta http-equiv="Content-type" content="text/html;charset=UTF-8">
</head><body>
<h3>Unrealised Rapid Transit Plans</h3>
HEREDOC
if [ $SCALE = 10 ]; then
    echo 'smaller versions --- <a href="large.html">larger versions</a><p>'
else
    echo '<a href=".">smaller versions</a> --- larger versions<p>'
fi
oldcity=""
br=true
for file in $@ '<p>'; do
    if [ -f $file ]; then
        city=`grep ^$file names | awk -F"\t" '{print $2}'`
        NAME=`grep ^$file names | awk -F"\t" '{print $3}'`
        SUBNAME=`grep ^$file names | awk -F"\t" '{print $4}'`
        URL=`grep ^$file names | awk -F"\t" '{print $5}'`
        if [ c$city != c$oldcity ]; then
            cities+=" "$city
            altfile=$(echo $file | sed -e's!small/!!')
            NATIVEW=$(grep '^   width="' $altfile | head -n1 | sed -e's/.* width="\([0-9\.]*\)".*/\1/;')
            W=$(awk "BEGIN{print int(0.5+$NATIVEW*$SCALE/138)}")
            H=$(awk "BEGIN{print int(0.5+$(grep ' height=' $altfile | head -n1 | sed -e's/.* height="\([0-9\.]*\)".*/\1/;')*$W/$NATIVEW)}")
            index=0
            br=true
            if [ ! -z $oldcity ]; then
                if [ -d ../../$oldcity ]; then
                    echo -n '<br>(<a href="../../'$oldcity'">timeline</a>)'
                fi
                echo "</small></span>"
            fi
            echo '<span id="'$city'" style="display: inline-block; vertical-align: middle">'$NAME'<br>'
            echo '<a href="javascript:next('\'$city\'');">'
            if [ $SCALE = 30 ]; then
                echo '<img class="bgmap" src="'$city'-bg.png" style="position:absolute; z-index: -1; display:none" width="'$W'" height="'$H'">'
            fi
            echo '<img class="map" src="'$file'" id="'$city'map" title="'$NAME'" alt="'$SNAME' map" width="'$W'" height="'$H'"></a><small>'
        fi
        if $br; then echo -n '<br>'; fi
        echo -n '<a class="setsrc" href="javascript:setsrc('\'$city\'','\'$file\'','$index');">'$SUBNAME'</a>'
        if [ ! -z "$URL" ]; then
            if [ "$URL" == "nobreak" ]; then
                if [ $br == true ]; then
                    echo -n ' ('
                    br=false
                else
                    echo -n ', '
                fi
            else
                echo ' (<a href="'$URL'">info</a>)'
            fi
        else
            if [ ! $br == true ]; then
                echo ')'
                br=true
            else
                echo ''
            fi
        fi
        oldcity=$city
        index=$(expr $index + 1)
    else
        if [ ! -z $oldcity ]; then
            if [ -d ../../$oldcity ]; then
                echo -n '<br>(<a href="../../'$oldcity'">timeline</a>)'
            fi
            echo "</small></span>"
            unset oldcity
        fi
        echo $file
    fi
done
echo '<form action="">Cities to show:'
for city in $cities; do
    NAME=`grep ^$city names | awk -F"\t" '{print $3}' | head -n1`
    echo "<div style=\"display: inline-block\"><input type=\"checkbox\" id=\"${city}checkbox\" onclick=\"toggleshow('$city')\" autocomplete=\"off\" checked>$NAME</div>"
done
cat <<HEREDOC
</form>
<a href="javascript:selectall()">show all</a>
<a href="javascript:deselectall()">hide all</a>
<p>
HEREDOC
if [ $SCALE = 30 ]; then
    echo '<a id="bgbutton" href="javascript:" onclick="showbg()">click here to show present-day labels and waterlines</a><p>'
fi
echo 'Based on planned frequent midday service (<a href="../notes.html">notes</a>).<br>'
if [ $SCALE = 10 ]; then
    echo 'Scale: <svg width="100px" height="3px" style="vertical-align: middle; stroke-width: 0px; background-color: black;"/> = 10 km (10 CSS pixels per km)'
elif [ $SCALE = 30 ]; then
    echo 'Scale: <svg width="300px" height="3px" style="vertical-align: middle; stroke-width: 0px; background-color: black;"/> = 10 km (30 CSS pixels per km)'
fi
cat <<HEREDOC
<p>
Please send any corrections or questions to threestationsquare at gmail dot com.
<p>
See also: <a href="../..">rapid transit timelines</a> - <a href="../../misc/">miscellaneous timelines and maps</a>
HEREDOC
if [ $SCALE = 30 ]; then
    sed -e's/image/images/' ~/timelines/scripts/template/part4b
else
    cat ~/timelines/scripts/template/part4
fi
