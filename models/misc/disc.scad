include <BOSL2/std.scad>
include <BOSL2/walls.scad>
$fa = $preview ? 1 : .1;
$fs = $preview ? 1 : .1;

hex_panel(circle(75/2), 2.5, 10.5, h = 1.6, frame=3);
