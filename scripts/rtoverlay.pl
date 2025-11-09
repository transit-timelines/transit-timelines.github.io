#!/usr/bin/perl


open(my $wcfile, "<", $ARGV[0]) or die $!;

while(<$wcfile>) {
    if (/viewBox="(-?[0-9]*),? (-?[0-9]*),? ([0-9]*),? ([0-9]*)"/) {
        $wcvbx = $1;
        $wcvby = $2;
        $wcvbw = $3;
        $wcvbh = $4;
    }
    if (/<image/) {
        $inimage = 1;
    }
    if ($inimage && /x="(-?[0-9\.]+)"/) {
        $wcix = $1;
    }
    if ($inimage && /y="(-?[0-9\.]+)"/) {
        $wciy = $1;
    }
    if ($inimage && /height="(-?[0-9\.]+)"/) {
        $wcih = $1;
    }
    if ($inimage && /width="(-?[0-9\.]+)"/) {
        $wciw = $1;
    }
    if ($inimage && />/ && !/<image/) {
        $inimage = 0;
    }
}
close($wcfile);
open(my $rtfile, "<", $ARGV[1]) or die $!;

while(<$rtfile>) {
    if (/viewBox="(-?[0-9]*),? (-?[0-9]*),? ([0-9]*),? ([0-9]*)"/) {
        $rtvbw = $3;
        $rtvbh = $4;
    }
    if (/<image/) {
        $inimage = 1;
    }
    if ($inimage && /x="(-?[0-9\.]+)"/) {
        $rtix = $1;
    }
    if ($inimage && /y="(-?[0-9\.]+)"/) {
        $rtiy = $1;
    }
    if ($inimage && /height="(-?[0-9\.]+)"/) {
        $rtih = $1;
    }
    if ($inimage && /width="(-?[0-9\.]+)"/) {
        $rtiw = $1;
    }
    if ($inimage && />/ && !/<image/) {
        $inimage = 0;
    }
}
close($rtfile);

$rtovbx = $rtix + ($rtiw/$wciw) * ($wcvbx - $wcix);
$rtovby = $rtiy + ($rtiw/$wciw) * ($wcvby - $wciy);
$rtovbw = ($rtiw/$wciw) * $wcvbw;
$rtovbh = ($rtiw/$wciw) * $wcvbh;

open($rtfile, "<", $ARGV[1]) or die $!;
while(<$rtfile>) {
    s/viewBox="(-?[0-9]*),? (-?[0-9]*),? ([0-9]*),? ([0-9]*)"/viewBox="$rtovbx $rtovby $rtovbw $rtovbh"/;
    s/width="$rtvbw"/width="$rtovbw"/;
    s/height="$rtvbh"/height="$rtovbh"/;
    print;
}
close($rtfile);
