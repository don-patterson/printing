include <BOSL2/std.scad>
$fa = $preview ? .5 : .1;
$fs = $preview ? .5 : .1;

module orig_box() {
  up(20) rotate([0, 180, 0]) import("./original/box.stl");
}

// different slices of the original box
module back() {
  projection(cut=true) orig_box();
}

module wall() {
  projection(cut=true) down(2) orig_box();
}

module inset_wall() {
  projection(cut=true) down(40) orig_box();
}

// extrude the sections of the original box so the holes are filled in
module filled_box() {
  linear_extrude(1) back();
  up(1) linear_extrude(38) wall();
  up(39) linear_extrude(1) inset_wall();
}

module orig_cutout() {
  fwd(100) up(20) ycyl(r=15, h=100);
}

module square_cutout(size=23) {
  fwd(130) up((40-sqrt(2)*size)/2) cube([size, 100, size], orient=UP+LEFT);
}

module square_base(size=23) {
  up(100) rect_tube(h=30, size=size-0.1, wall=4, rounding=1);
  rect_tube(h=100, wall=4, size2=size-0.1, rounding2=1, size1=55, rounding1=27.5);
}

// filled box with cutout
difference() {
  filled_box();
  square_cutout(); // or orig_cutout();
}
