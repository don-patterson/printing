include <BOSL2/std.scad>   // https://github.com/BelfrySCAD/BOSL2
$fa = $preview ? .5 : .1;
$fs = $preview ? .5 : .1;

// filler to make my 5/8" deep socket a 1/2" deep socket for a few minutes
difference() {
  regular_prism(n=6, id=16, h=20); // good fit, but would increase next time to press fit so it doesn't fall out
  regular_prism(n=6, id=13, h=20.01); // great fit
}
