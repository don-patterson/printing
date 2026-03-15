include <BOSL2/std.scad>
$fa = $preview ? 1 : .1;
$fs = $preview ? 1 : .1;


// original
path = turtle([
  "ymove", -1.4,
  "xmove", -2.5,
  "ymove", -6.1,
  "setdir", -45, "untily", -9.5,
  "xmove", 16.5,
  "setdir", 40, "untilx", 21.8,
  "setdir", 90, "untily", -1.5,
  "xmove", -2,
  "ymove", 1.5,
  "jump", [0,0],
]);
bounds = pointlist_bounds(path);
xmin = bounds[0][0];
xmax = bounds[1][0];
ymin = bounds[0][1];
ymax = bounds[1][1];


difference() {
  cube([xmax - xmin + 4, ymax-ymin, 15+4]); 

  right(-xmin + 2) back(-ymin) up(2)
    linear_extrude(h=15)
      polygon(path);
}

