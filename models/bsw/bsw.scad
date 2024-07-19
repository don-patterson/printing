use <../../lib/shapes.scad>
$fa = $preview ? 1 : .1;
$fs = $preview ? 1 : .1;

side = 22;
depth = 8;
thick_wall = 1.8;
thin_wall = 0.8;
c=2;

module unit(n) {
  render()
  difference() {
    ngon(n, side=side, z=depth, on="z+");
    ngon(n, side=side-2*thick_wall, z=depth, on="z+");
    translate([0, 0, depth*3/4 - c])
      ngon(n, side=side-2*thin_wall, z=depth, on="z+", chamfer=c);
  }
}

for (i=[0:8]) {
  for (j=[0:8]) {
    translate([i*side, j*side, 0])
      unit(4);
  }
}


