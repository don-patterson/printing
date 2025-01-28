include <BOSL2/std.scad>
$fa = $preview ? .5 : .1;
$fs = $preview ? .5 : .1;


module screw_tab() {
  back(4) left(3)
  difference() {
    hull() {
      cyl(d=7, h=2);
      right(10) cyl(d=7, h=2);
    }
    cyl(d=2, h=2.1);
    cyl(d=4, h=2, anchor=BOT);
  }
}

screw_tab();

cube([56.5, 32, 2], anchor=FWD+LEFT)
  attach(RIGHT, LEFT, align=[FWD, BACK], inset=4)
    fwd(.5) cube([2,3,1]);
