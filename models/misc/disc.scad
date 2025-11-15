include <BOSL2/std.scad>
include <BOSL2/walls.scad>
$fa = $preview ? 1 : .1;
$fs = $preview ? 1 : .1;

hex_panel(shape=circle(r=40), strut=3, spacing=8, h=3, anchor=BOT);
cyl(h=20, r=14, anchor=BOT);
