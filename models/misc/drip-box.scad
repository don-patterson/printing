include <BOSL2/std.scad>
$fa = $preview ? 1 : .1;
$fs = $preview ? 1 : .1;

// outer dimension
width = 150;
depth = 75;
height = 45;
wall = 2;

diff()
cuboid([width+2*wall, depth+2*wall, height+wall], chamfer=3, except=TOP) {
  attach(TOP, TOP, inside=true, shiftout=0.01)
    cuboid([width,depth,height], chamfer=2, except=TOP);
}
