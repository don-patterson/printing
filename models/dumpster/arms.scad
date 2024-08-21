use <../../lib/shapes.scad>
use <props.scad>

module arms(
  w=prop("bin.width"),
  fh=prop("bin.front.height"),
  d=prop("bin.depth"),
  t=prop("panel.thickness"),
) {
  translate([0, 0, fh/2]) {
    difference() {
      box(x=3*t, y=d, z=4*t, on="x-,y+");
      box(x=3*t, y=d, z=4*t, on="x-,y+", margin=-t, margin_y=1);
    }
    translate([w, 0, 0])
      difference() {
        box(x=3*t, y=d, z=4*t, on="x+,y+");
        box(x=3*t, y=d, z=4*t, on="x+,y+", margin=-t, margin_y=1);
      }
  }
};

arms();
