use <../../lib/shapes.scad>
use <props.scad>
$fa = $preview ? 1 : .1;
$fs = $preview ? 1 : .1;

module bin(
  width=prop("bin.width"),
  depth=prop("bin.depth"),
  front_height=prop("bin.front.height"),
  back_height=prop("bin.back.height"),
  panel_thickness=prop("panel.thickness"),
  lid_angle=prop("lid.angle"),
) {
  difference() {
    // bin-sized block
    box(x=width, y=depth, z=back_height, on="x+,y+,z+");

    // carve out interior
    box(x=width, y=depth, z=999, on="x+,y+,z+", margin=-panel_thickness);

    // slice off the top
    translate([0, 0, front_height])
      rotate([lid_angle, 0, 0])
        box(999, on="z+");

    // carve out the horizontal grooves on the front
    for (h=[1/3, 2/3]) {
      translate([0, panel_thickness/2, front_height*h])
        rotate([45, 0, 0])
          box(999, on="y-,z+");
    }
  }
}

bin();