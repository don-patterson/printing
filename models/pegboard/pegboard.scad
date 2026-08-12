include <BOSL2/std.scad>
$fa = $preview ? 2 : .2;
$fs = $preview ? 1 : .1;
eps = 0.01;

board_t = 5;
hole_r = 2.5;
peg_r = 2.4;
hole_spacing = 40;

module board(x=60, y=60) {
  difference() {
    cube([x, y, board_t], anchor=CENTER);
    grid_copies(
      inside=square([1000, 1000], anchor=CENTER),
      spacing=[hole_spacing/2, hole_spacing/2],
      stagger=true,
    )
      cylinder(r=hole_r, h=board_t + eps, anchor=CENTER);
  }
}

// %board();

b = 1.4;
module bump() {
  max_width = sqrt(peg_r^2 - (b/2)^2); // this is the width where the circles intersect
  intersection() {
    hull() {
      ycyl(r=peg_r, h=3, anchor=FRONT);
      up(1.4) ycyl(r=peg_r, h=3, anchor=FRONT);
    }

    cube([2*max_width, 100, 100], anchor=CENTER);
  }
}

module peg() {
  // this is the shape I want in the pegboard. It will be built in two parts so it can be inserted from the front
  ycyl(r=peg_r, h=30)
    position(BACK)
      bump();
}

top_half() down(b/2) peg();
yrot(180) right(10) bottom_half() down(b/2) peg();
