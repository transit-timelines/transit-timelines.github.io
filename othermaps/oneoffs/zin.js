zinseasons = ["summer", "autumn", "winter", "spring"];
zinurls = ["zin.svg", "zin10.svg", "zin01.svg", "zin04.svg"];
zinstate = 0;

function nextzinmap() {
    zinspan = document.getElementById("ZIN");
    zinstate = (zinstate + 1) % 4;
    zinspan.getElementsByClassName("map")[0].src = zinurls[zinstate];
    zinspan.getElementsByTagName("a")[0].innerHTML = zinseasons[zinstate];
}
