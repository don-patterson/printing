// License note:
// STLs and similar physical shapes produced from this code are derivative works of Honeycomb Storage Wall by RostaP
// and must be released under the same CC-BY-NC license (or a stricter CC 4.0 version). The `stl` folder in this
// repo has that license file, so any files in and under that directory are shared with the CC-BY-NC license.
include <./bsw.scad>

module insert(
  width=prop("insert.width"),
  depth=prop("insert.depth"),
  taper=4,
) {
  prismoid(size1=[width-taper*prop("margin"), width], size2=[width, width], h=depth, orient=FWD, anchor=TOP)
    children();
}

module peg(width=prop("insert.width"), length=40) {
  insert()
    attach(TOP, BACK)
      cube([width, length, width]);
}

peg();
