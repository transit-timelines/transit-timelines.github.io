#!/usr/bin/perl

my $n;
if ($#ARGV > 0) {
    $n = $ARGV[1]+1;
} else {
    $n = 1;
}

my $gitstring = `git log $ARGV[0] | grep commit | tail -n+$n | head -n1`;
my ($commit, $hash) = split(/ /, $gitstring);
chomp($hash);

open(my $file, "<", $ARGV[0]) or die $!;

while(<$file>) {
    if (/<image/) {
        $inimage = 1;
    }
    if ($inimage && /x="(-?[0-9\.]+)"/) {
        $x = $1;
    }
    if ($inimage && /y="(-?[0-9\.]+)"/) {
        $y = $1;
    }
    if ($inimage && /height="(-?[0-9\.]+)"/) {
        $height = $1;
    }
    if ($inimage && /width="(-?[0-9\.]+)"/) {
        $width = $1;
    }
    if ($inimage && /xlink:href="(.*)"/) {
        $png = $1;
    }
    if ($inimage && />/ && !/<image/) {
        $inimage = 0;
    }
}

my $oldcmd = `git diff $hash $png-cmd | grep '^-.*sh'`;
my $newcmd = `git diff $hash $png-cmd | grep '^+.*sh'`;
my ($oldsh, $oldleft, $oldright, $oldtop, $oldbottom) = split(/ /, $oldcmd);
my ($newsh, $newleft, $newright, $newtop, $newbottom) = split(/ /, $newcmd);
my $tilesize = $width / ($oldright - $oldleft + 1);
my $newwidth = $tilesize * ($newright - $newleft + 1);
my $newheight = $tilesize * ($newbottom - $newtop + 1);
my $newx = $x - $tilesize * ($oldleft - $newleft);
my $newy = $y - $tilesize * ($oldtop - $newtop);
print ('sed -e\'s/width="'.$width.'"/width="'.$newwidth.'"/; ');
print ('s/height="'.$height.'"/height="'.$newheight.'"/; ');
print ('s/x="'.$x.'"/x="'.$newx.'"/; ');
print ('s/y="'.$y.'"/y="'.$newy.'"/;'."' -i $ARGV[0]\n");

