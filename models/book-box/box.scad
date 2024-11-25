include <BOSL2/std.scad>
$fa = $preview ? 1 : .1;
$fs = $preview ? 1 : .1;

depth = 101;
height = 101;
width = 70;
wall = 2;

diff()
rect_tube(h=height+wall, isize=[width, depth], wall=wall) {
  tag("keep") attach(BOT, BOT, inside=true) cube([width, depth, wall]);
  tag("remove") attach(TOP) xcyl(d=height/4, h=99);
}
