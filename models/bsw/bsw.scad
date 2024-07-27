use <./common.scad>

cols=10; // [1:1:20]
rows=8;  // [1:1:20]

// `cols` by `rows` Boring Storage Wall:
for (i=[0:cols-1]) {
  for (j=[0:rows-1]) {
    translate([i*prop("width"), j*prop("width"), 0])
      wall_unit();
  }
}
