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

// translate([0, 45, 0]) {
//   _fins();
//   %_fins(mode="margin");
// }
// translate([0, 30, 0]) {
//   _pin();
//   %_pin(mode="margin");
// }
// translate([0, 15, 0]) {
//   _cuff();
// }
// _fins();
// _pin();
// _cuff();


module lid(angle=prop("lid.angle")) {
  rotate([angle-90, 0, 0]) {
    _top();
    rotate([90, 0, 90]) {
      _fins();
      _pin();
      _cuff();
    }
  }
}

lid();
