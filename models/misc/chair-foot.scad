include <BOSL2/std.scad>
$fa = $preview ? 1 : .1;
$fs = $preview ? 1 : .1;

// Our dining set has these metal cylinders at the bottom and a plastic/rubbery foot attaches there.
// I'm going to replace the broken one with TPU and see how it goes.

diff()
cyl(d=20, h=6)
  attach(TOP, TOP, inside=true, shiftout=0.01)
    cyl(d=11.2, h=2.6);
