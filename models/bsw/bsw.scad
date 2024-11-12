use <./common.scad>

cols=3; // [1:1:20]
rows=2;  // [1:1:20]
side=prop("socket.width");
// `cols` by `rows` Boring Storage Wall:
for (i=[0:cols-1]) {
  for (j=[0:rows-1]) {
    translate([i*side, j*side, 0])
      socket();
  }
}
