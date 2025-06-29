include <BOSL2/std.scad>
include <BOSL2/hinges.scad>
$fs = .1;
$fa = .1;

module end_hinge(width, segments, thickness, anchor=CENTER, spin=0, orient=UP) {
  attachable(anchor=anchor, spin=spin, orient=orient, size=[width, thickness, thickness]) {
    // to make an attachable object, put the pieces as the first child of this attachable module,
    // oriented in the CENTER and filling the cube `size`, then this takes care of all the
    // other spins, orients, etc, and all the anchor points.

    union() {
      for (inner=[false,true])
        rot(inner ? 0 : 180)
        xrot(90)
        translate([0, thickness/2, -thickness/2]) 
        knuckle_hinge(
          length=width,  // I think of it as width, hopefully this isn't confusing
          segs=segments,
          inner=inner,
          in_place=true,
          arm_angle=45,  // for printing without a big overhang on the rounded part
          knuckle_diam=thickness,
          offset=thickness/2,
          clearance=-thickness/2,
          clip=thickness/2,
        );
    }
    children();
  }
}


end_hinge(width=25, segments=9, thickness=3)
  show_anchors(s=1);
