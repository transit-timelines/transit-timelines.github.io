#!/usr/bin/perl -w
use strict;

sub acos { atan2( sqrt(1 - $_[0] * $_[0]), $_[0] ) }
my $pi = 3.14159265;

my $iata=shift;

open(my $afile, "scripts/airports.dat") or die "couldn't open file!";

my $lat; my $long;
while (<$afile>) {
    if (/^$iata/) {
        (undef, $lat, $long, undef) = split(/\t/, $_);
        last;
    }
}
if (!$lat) {
  die "airport $iata not found!";
}

$lat = $lat * $pi/180;
$long = $long * $pi/180;
my $lat0 = 40.71 * $pi/180;
my $long0 = -74.01 * $pi/180;

my $rho = acos( sin($lat0)*sin($lat)+cos($lat0)*cos($lat)*cos($long-$long0) );
my $theta = atan2( cos($lat)*sin($long-$long0),
                   cos($lat0)*sin($lat) - sin($lat0)*cos($lat)*cos($long-$long0) );

my $x=637*$rho*sin($theta);
my $y=-637*$rho*cos($theta);
print '<circle ';
print 'style="opacity:1;fill:#000000;fill-opacity:1;fill-rule:nonzero;stroke:none" ';
print "id=\"dot$iata\" ";
print 'r="3" ';
printf('cx="%.3f" cy="%.3f" />'."\n", 2000+$x, 2000+$y);
