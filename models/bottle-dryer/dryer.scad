use <../../lib/shapes.scad>;

$fa = $preview ? 1 : .1;
$fs = $preview ? 1 : .1;

leg = 50;
arm = 50;
t = 3;
m = 0.1;
c=.6;

module part() {
  intersection() {
    rotate([0,0,45])
      box(x=20, y=20, z=t, chamfer=c);
    box(x=30, y=30, z=t, on="y+", chamfer=c);
  }
  box(x=2*leg, y=t, z=t, on="y+", chamfer=c);
  box(x=t, y=arm, z=t, on="y+", chamfer=c);
}

module base() {
  difference() {
    part();
    box(t, on="y+", margin=m);
  }
}

module support() {
  difference() {
    part();
    translate([0, t, 0])
      box(x=t, y=arm, z=t, on="y+", margin=m);
  }
}

support();
translate([0, 20, 0])
  base();