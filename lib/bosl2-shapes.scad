include <BOSL2/std.scad>
include <BOSL2/hinges.scad>
$fs = .1;
$fa = .1;

// A print-in-place hinge that sits between the pieces you attach to the LEFT and RIGHT
module end_hinge(width, segments, thickness, anchor=CENTER, spin=0, orient=UP, end_gap=0.2, gap=0.2) {
  attachable(anchor=anchor, spin=spin, orient=orient, size=[width, thickness+2*end_gap, thickness]) {
    // to make an attachable object, put the pieces as the first child of this attachable module,
    // oriented in the CENTER and filling the cube `size`, then this takes care of all the
    // other spins, orients, etc, and all the anchor points.
    union() {
      for (inner=[false, true])
        rot(inner ? 0 : 180)
        xrot(90)
        translate([0, thickness/2, -thickness/2-end_gap])
        knuckle_hinge(
          length=width,  // I think of it as width, hopefully this isn't confusing
          segs=segments,
          inner=inner,
          in_place=true,
          arm_angle=45,  // for printing without a big overhang on the rounded part
          gap=gap,
          knuckle_diam=thickness,
          offset=thickness/2+end_gap,
          clearance=-thickness/2,
          clip=thickness/2,
        );
    }
    children();
  }
}
