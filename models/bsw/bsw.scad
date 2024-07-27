use <../../lib/shapes.scad>
$fa = $preview ? 1 : .1;
$fs = $preview ? 1 : .1;

/*
 * Boring storage wall: inspired by HSW by RostaP, of course!
 * I wanted a square grid instead of a honeycomb, and I can also easily
 * align it with gridfinity bins this way (21mm wall units to align with
 * the 42mm gridfinity units).
 *
 * For a minute I was trying to make this general for any n, but of
 * course only a few shapes can easily be tiled.
 */

cols = 10; // [1:1:20]
rows = 8; // [1:1:20]
width = 21;
depth = 8;

/* Hidden */
thick_wall = 1.8;
thin_wall = 0.8;
chamfer=2;
 
module unit(n) {
  render()
  difference() {
    ngon(n, side=width, z=depth, on="z+");
    ngon(n, side=width-2*thick_wall, z=depth, on="z+");
    translate([0, 0, depth*3/4 - chamfer])
      ngon(n, side=width-2*thin_wall, z=depth, on="z+", chamfer=chamfer);
  }
}

for (i=[0:cols-1]) {
  for (j=[0:rows-1]) {
    translate([i*width, j*width, 0])
      unit(4);
  }
}

