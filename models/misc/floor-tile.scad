include <BOSL2/std.scad>
include <BOSL2/walls.scad>
$fa = $preview ? 1 : .1;
$fs = $preview ? 1 : .1;


hex_panel(square(185), strut=4, spacing=15, h=8, anchor=TOP);
