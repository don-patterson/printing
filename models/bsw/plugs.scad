// License note:
// STLs and similar physical shapes produced from this code are derivative works of Honeycomb Storage Wall by RostaP
// and must be released under the same CC-BY-NC license (or a stricter CC 4.0 version). The `stl` folder in this
// repo has that license file, so any files in and under that directory are shared with the CC-BY-NC license.
include <don/bosl2-shapes.scad>
include <./bsw.scad>

module plug(insert=$v_insert_width, slots=[LEFT,RIGHT,FWD,BACK]) {
  base_plug(slots=slots)
    attach(TOP, TOP, inside=true, shiftout=eps)
      cuboid([insert, insert, 99]);
}

module hsw_plug(r=$v_hsw_insert_width) {
  base_plug()
    attach(TOP, TOP, inside=true, shiftout=eps)
      regular_prism(6, id=r, h=99);
}

module plug_2x(
  insert=$v_insert_width,
  dx=$v_socket_width,
  faceplate_depth=$v_plug_faceplate_depth,
  faceplate_width=v_plug_faceplate_width(),
) {
  plug();
  right(dx) plug();
  // fill the gap between them
  right(dx/2) cuboid([3, faceplate_width, faceplate_depth], anchor=TOP);
}

module inside_corner_plug_2x(
  insert=$v_insert_width,
  dx=$v_socket_width,
  fd=$v_plug_faceplate_depth,
  fw=v_plug_faceplate_width(),
  sw=$v_socket_width,
  sd=$v_socket_depth,
) {
  yrot(45) {
    right(sw/2) plug();
    right(fd) down(sw) yrot(-90) right(sw/2) up(fd) plug();
    // fill the gap between them
    cuboid([3, fw, fd], anchor=TOP+LEFT);
  }
}

module hinge_plug() {
  $v_plug_faceplate_depth = 3;
  difference() {
    union() {
      plug(slots=[LEFT,FWD,BACK]);
      right($v_socket_width) plug(slots=[RIGHT,FWD,BACK]);
    }
    right($v_socket_width/2) bounding_box() end_hinge(width=v_plug_faceplate_width()+eps, segments=10, thickness=3, end_gap=0.1, anchor=TOP, spin=90);
  }
  right($v_socket_width/2) end_hinge(width=v_plug_faceplate_width(), segments=10, thickness=3, end_gap=0.1, anchor=TOP, spin=90);
}

hinge_plug();
