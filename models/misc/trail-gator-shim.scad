include <BOSL2/std.scad>
$fa = $preview ? .5 : .1;
$fs = $preview ? .5 : .1;

width = 64;
height = 24;

difference() {
  cube([width, height, .8]);
  back(height/2) {
    hull() {
      right(width-8) cyl(h=10, d=10);
      right(width) cyl(h=10, d=10);
    }

    hull() {
      right(8) cyl(h=10, d=10);
      cyl(h=10, d=10);
    }
  }
}
