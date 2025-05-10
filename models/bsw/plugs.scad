// License note:
// STLs and similar physical shapes produced from this code are derivative works of Honeycomb Storage Wall by RostaP
// and must be released under the same CC-BY-NC license (or a stricter CC 4.0 version). The `stl` folder in this
// repo has that license file, so any files in and under that directory are shared with the CC-BY-NC license.
include <./bsw.scad>

module plug(insert=prop("insert.width")) {
  base_plug()
    attach(TOP, TOP, inside=true, shiftout=eps)
      cuboid([insert, insert, 99]);
}

module hsw_plug(r=prop("hsw.insert.width")) {
  base_plug()
    attach(TOP, TOP, inside=true, shiftout=eps)
      regular_prism(6, id=r, h=99);
}

module plug_2x(
  insert=prop("insert.width"),
  dx=prop("socket.width"),
  faceplate_depth=prop("plug.faceplate.depth"),
  faceplate_width=prop("plug.faceplate.width"),
) {
  plug();
  right(dx) plug();
  // fill the gap between them
  right(dx/2) cuboid([3, faceplate_width, faceplate_depth], anchor=TOP);
}

module inside_corner_plug_2x(
  insert=prop("insert.width"),
  dx=prop("socket.width"),
  fd=prop("plug.faceplate.depth"),
  fw=prop("plug.faceplate.width"),
  sw=prop("socket.width"),
  sd=prop("socket.depth"),
) {
  yrot(45) {
    right(sw/2) plug();
    right(fd) down(sw) yrot(-90) right(sw/2) up(fd) plug();
    // fill the gap between them
    cuboid([3, fw, fd], anchor=TOP+LEFT);
  }
}
