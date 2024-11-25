include <BOSL2/std.scad>
$fa = $preview ? 1 : .1;
$fs = $preview ? 1 : .1;

depth = 101;
height = 101;
width = 70;
wall = 2;

diff()
cuboid([width+2*wall, depth+2*wall, height+wall], chamfer=1.8, except=TOP) {
  attach(TOP, CENTER, inside=true)
    xcyl(d=height/4, h=99);
  attach(TOP, TOP, inside=true, shiftout=0.01)
    cuboid([width,depth,height]);
}
