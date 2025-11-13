#!/usr/bin/perl -w
open(my $svgfile, "<", $ARGV[0]) or die $!;

my ($imgx, $imgy, $imgheight, $imgwidth, $vbleft, $vbtop, $vbwidth, $vbheight);
my $inimage = 0;

while(<$svgfile>) {
    if (/<image/) {
        $inimage = 1;
    }
    if ($inimage && /x="(-?[0-9\.]+)"/) {
        $imgx = $1;
    }
    if ($inimage && /y="(-?[0-9\.]+)"/) {
        $imgy = $1;
    }
    if ($inimage && /height="(-?[0-9\.]+)"/) {
        $imgheight = $1;
    }
    if ($inimage && /width="(-?[0-9\.]+)"/) {
        $imgwidth = $1;
    }
    if ($inimage && />/ && !/<image/) {
        $inimage = 0;
    }
    if (/viewBox="(-?[0-9]+),? (-?[0-9]+),? ([0-9]+),? ([0-9]+),?"/) {
        $vbleft = $1;
        $vbtop = $2;
        $vbwidth = $3;
        $vbheight = $4;
    }
}

close $svgfile;

if ($vbleft < $imgx) {
    print "$ARGV[0] left edge!\n";
}
if ($vbleft + $vbwidth > $imgx + $imgwidth) {
    print "$ARGV[0] right edge!\n";
}
if ($vbtop < $imgy) {
    print "$ARGV[0] top edge!\n";
}
if ($vbtop + $vbheight > $imgy + $imgheight) {
    print "$ARGV[0] bottom edge!\n";
}
