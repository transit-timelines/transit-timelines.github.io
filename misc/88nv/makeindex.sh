#!/bin/bash
START=$(basename $(ls *.svg | grep '^1\|^2' | head -n 1) .svg)
END=$(basename $(ls *.svg | grep '^1\|^2' | tail -n 1) .svg)
COUNT=$(expr 1 + \( $END - $START \))
cat <<HEREDOC | sed -e"s/START/${START}/g; s/END/${END}/g; s/COUNT/${COUNT}/g;"
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head><title>Black Rock City Layout Timeline</title>
<meta http-equiv="Content-type" content="text/html;charset=UTF-8">
<meta property="og:type" content="website" />
<meta property="og:title" content="Black Rock City Layout Timeline" />
<meta property="og:image" content="https://alexander.co.tz/timelines/misc/88nv/preview.gif" />
<meta property="og:image:width" content="600" />
<meta property="og:image:height" content="717" />
<meta property="og:url" content="https://alexander.co.tz/timelines/misc/88nv/preview.gif" />
<meta property="og:description" content="Maps every year, START-END" />
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
</style>
<script language="JavaScript" type="text/javascript">
start=START;
count=COUNT;
step=1;
index=count-1;
function update() {
    document["MAP"].src=(start+step*index) + ".svg";
    document["MAP"].title=start+step*index;
    document["MAP"].alt=start+step*index + " map";
    location.replace("#" + (start+step*index));
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
    if( start <= inyear & inyear <= start+step*count & !(inyear % step) ) {
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
window.onload=function() {
    gotoyear(location.hash.substring(1));
}
window.onhashchange=function() {
    gotoyear(location.hash.substring(1));
}
</script>
</head><body>
<center>
<a href="javascript:" onclick="prevmap()">one year earlier (or press a)</a> ---
<a href="javascript:" onclick="nextmap()">one year later (or press s)</a>
<br>
<a id="animbutton" href="javascript:" onclick="startanim()">click here to animate</a>
<p>
<a href="javascript:" onclick="nextmap()">
<img name="MAP" src="END.svg" title="END" alt="END map" width="508px" height="607px" style="border-width: 1px; border-style: solid">
</a>
<p>
HEREDOC
for y in `seq $START $END`; do
    echo "<a href=\"#${y}\" onclick=\"gotoyear(${y})\">${y}</a>"
done
cat <<HEREDOC
<p>
<a href="javascript:" onclick="prevmap()">one year earlier (or press a)</a> --- 
<a href="javascript:" onclick="nextmap()">one year later (or press s)</a>
<p>
Approach and other external roads not shown.<br>
Scale: <svg width="100px" height="3px" style="vertical-align: middle; stroke-width: 0px; background-color: black;"/> = 1 km (100 CSS pixels per km)
<p>
Please send any corrections or questions to threestationsquare at gmail dot com.
<p>
<div id="preloader">
HEREDOC
for y in `seq $START $END`; do
    echo '<img src="'${y}'.svg" width="1" height="1" alt="">'
done
cat <<HEREDOC
</div>
See also:
<a href="../..">rapid transit timelines</a> - 
<a href="..">miscellaneous timelines and maps</a>
<p>
<font size="1">By <a href="/">Alexander Rapp</a> based on maps
copyright <a href="http://www.burningman.org">black rock city llc</a>.</font>
</center>
</body></html>
HEREDOC
