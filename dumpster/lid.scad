use <props.scad>

$fn = $preview ? 30 : 128;

module _fins(
  start=prop("hinge.fin.start"),
  end=prop("hinge.fin.end"),
  count=prop("hinge.fin.count"),
  l=prop("hinge.fin.length"),
  w=prop("hinge.fin.width"),
  h=prop("hinge.fin.height"),
  a=prop("hinge.fin.taper.angle"),
  margin=prop("hinge.fin.margin"),
  mode="normal",
) {
  margin = mode == "normal" ? 0 : margin;
  start = start - margin;
  end = end + margin;
  w = w + 2*margin;
  d = h + 2*margin;
  // it's kinda complicated to get the length/height margin right with the angled edge
  // and also maybe not that useful, so I'm leaving it out for now.

  for (i=[0:count - 1])
    translate([0, 0, start + i * (end - w - start) / (count - 1)])
      linear_extrude(w) {
        translate([0, -h/2, 0])
          polygon([[0,0], [0, h], [l, h], [l - (h / tan(a)), 0]]);
        circle(d=d);
      }
}

module _pin(
  start=prop("hinge.pin.start"),
  end=prop("hinge.pin.end"),
  r=prop("hinge.pin.radius"),
  margin=prop("hinge.pin.margin"),
  mode="normal",
) {
  margin = mode == "normal" ? 0 : margin;
  r = r + margin;
  h = end - start + 2*margin;
  translate([0, 0, start-margin])
    cylinder(r=r, h=h);
}

module _cuff(
  start=0,
  end=prop("hinge.length"),
  r=prop("hinge.radius"),
) {
  difference() {
    translate([0, 0, start])
      cylinder(r=r, h=end-start);
    _pin(mode="margin");
    _fins(mode="margin");
  }
}

module _top(
  l=prop("lid.length"),
  w=prop("box.width"),
  h=prop("panel.thickness")
) {
  translate([0,0,prop("hinge.radius")])
    cube([w, l, h]);
}

module _assembly(mode="normal") {
  _top();
  rotate([90,0,90]) {
    _fins(mode=mode);
    _pin(mode=mode);
    _cuff();
  }
}

module lid(angle=0, mode="normal") {
  // position should be such that the hinge pin in centered on the outside
  // edge of the back wall, and so the lid is exactly touching, when the
  // hinge is rotated "lid.angle" down from horizontal. I think I did
  // the math right
  let (t=prop("panel.thickness"), a=prop("lid.angle"), r=prop("hinge.radius"), h=prop("box.back.height"))
  translate([
    0, // already starting at x=0
    -t, // move to the outside of the back wall
    h + t*tan(a) - r/cos(a) // worked it out 4 times before I got the same answer twice
  ])
    rotate([angle-a, 0, 0])
      _assembly();
  // TODO: finish swing/cutout mode
  //   else if (mode == "cutout")
  //     rotate([prop("lid.angle")-90,0,0])
  //       rotate([0,90,0])
  //         rotate_extrude(angle=180)
  //           rotate([0,0,90])
  //             square([
  //               prop("box.width"),
  //               prop("hinge.radius") + prop("panel.thickness")
  //             ]);
  //
}

lid();
