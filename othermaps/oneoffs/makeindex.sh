SCALE=$1
shift
cat <<HEREDOC
<!DOCTYPE HTML>
<html>
<head><title>One-off Rapid Transit Map Scale Comparison</title>
<style type="text/css">
span {
    margin-top: 10px;
    margin-bottom: 10px;
}
.map, .bgmap {
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
</script>
<meta http-equiv="Content-type" content="text/html;charset=UTF-8">
<center>
<h3>One-off Rapid Transit Maps for Scale Comparison with <a href="../..">Timelines</a></h3>
HEREDOC
if [ $SCALE = 10 ]; then
    echo 'smaller versions --- <a href="large.html">larger versions</a><p>'
else
    echo '<a href=".">smaller versions</a> --- larger versions<p>'
fi
for file in $@; do
    if [ -f $file ]; then
        city=`basename $file .svg`
        NAME=`grep ^$city names | awk -F"\t" '{print $3}'`
        NOTE=`grep ^$city names | awk -F"\t" '{print $4}'`
        URL=`grep ^$city names | awk -F"\t" '{print $5}'`
        UPPER=$(echo $city | tr 'a-z' 'A-Z')
        NATIVEW=$(grep '^   width="' $file | head -n1 | sed -e's/.* width="\([0-9\.]*\)".*/\1/;')
        W=$(awk "BEGIN{print int(0.5+$NATIVEW*$SCALE/138)}")
        H=$(awk "BEGIN{print int(0.5+$(grep ' height=' $file | head -n1 | sed -e's/.* height="\([0-9\.]*\)".*/\1/;')*$W/$NATIVEW)}")
        echo -n '<span id="'$UPPER'" style="display: inline-block; vertical-align: middle">'
        if [ ! -z "$URL" ]; then
            if [ ! -z "$NOTE" ]; then
                echo '<a href="'$URL'">'$NAME'</a><br><small>'$NOTE'</small><br><a href="'$URL'">'
            else
                echo '<a href="'$URL'">'$NAME'<br>'
            fi
        else
            if [ ! -z "$NOTE" ]; then
                echo $NAME'<br><small>'$NOTE'</small><br>'
            else
                echo $NAME'<br>'
            fi
        fi
        if [ $SCALE = 30 ]; then
            echo '    <img class="bgmap" src="'$city'-bg.png" style="position:absolute; z-index: -1; display:none" width="'$W'" height="'$H'">'
        fi
        echo -n '    <img class="map" src="'$file'" title="'$NAME'" alt="'$NAME' map" width="'$W'" height="'$H'">'
        if [ ! -z "$URL" ]; then
            echo '</a></span>'
        else
            echo '</span>'
        fi
    else
        echo '<h4>'$file'</h4>'
    fi
done
echo '<p>'
echo '<!--<form action="">Cities to show:'
for file in $@; do
    if [ -f $file ]; then
        city=`basename $file .svg`
        NAME=`grep ^$city names | awk -F"\t" '{print $3}' | sed -e's/<br>.*//'`
        UPPER=$(echo $city | tr 'a-z' 'A-Z')
        echo "<div style=\"display: inline-block\"><input type=\"checkbox\" id=\"${UPPER}checkbox\" onclick=\"toggleshow('$UPPER')\" autocomplete=\"off\" checked>$NAME</div>"
    fi
done
if [ $SCALE = 10 ]; then
    cat <<HEREDOC
</form><p>-->
Based on frequent midday service at the end of the year in question (<a href="../../notes.html">notes</a>) except as noted.<br>
Scale: <svg width="100px" height="3px" style="vertical-align: middle; stroke-width: 0px; background-color: black;"/> = 10 km (10 CSS pixels per km)
<p>
Please send any corrections or questions to threestationsquare at gmail dot com.
<p>
See also: <a href="../..">rapid transit timelines</a> - <a href="../../misc/">miscellaneous timelines and maps</a>
HEREDOC
elif [ $SCALE = 30 ]; then
    cat <<HEREDOC
</form><p>-->
<a id="bgbutton" href="javascript:" onclick="showbg()">click here to show present-day labels and waterlines</a><p>
Based on frequent midday service at the end of the year in question (<a href="../../notes.html">notes</a>) except as noted.<br>
Scale: <svg width="300px" height="3px" style="vertical-align: middle; stroke-width: 0px; background-color: black;"/> = 10 km (30 CSS pixels per km)
<p>
Please send any corrections or questions to threestationsquare at gmail dot com.
<p>
See also: <a href="../..">rapid transit timelines</a> - <a href="../../misc/">miscellaneous timelines and maps</a>
HEREDOC
fi
if [ $SCALE = 30 ]; then
    sed -e's/image/images/' ~/timelines/scripts/template/part4b
else
    cat ~/timelines/scripts/template/part4
fi
