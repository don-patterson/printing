use <props.scad>
use <../util.scad>

$fn = $preview ? 30 : 128;

// mode idea:
// use mode "normal" for the shape if it's free of any obstructions
// use mode "margin" to subtract space around the shape so that it can move
// use mode "cutout" to subtract interior space for a shape so that it can be inserted into a solid

module _fins(
  // mode: normal or margin
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
  // mode: normal or margin
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
  // mode: normal or margin
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


module _top() {
  // lid length has to be slightly increased because of where the radius
  // from the hinge hits at 90 degrees
  let (
    l=prop("lid.length"),
    t=prop("panel.thickness"),
    r=prop("hinge.radius"),
    a=prop("lid.angle"),
    w=prop("box.width")
  )
  translate([0,0,r-.001]) // fixes a warning with the hinge overlap
    cube([w, l + (t - r*sin(a))/cos(a), t]);
}

module _assembly(
  // mode: normal or cutout
  // note that right now cutout is mostly about the hinge, not the fins
  cutout_radius=prop("lid.cutout.radius"),
  cutout_width=prop("hinge.length"),
  mode="normal"
) {
  _top();
  rotate([90,0,90]) {
    _fins(mode=mode == "normal" ? "normal" : "margin");
    _pin(mode=mode == "normal" ? "normal" : "margin");
    _cuff();
  }
  if (mode != "normal")
    rotate([90,0,0])
      r_extrude(x=120)
        square([cutout_width, cutout_radius]);
}

module lid(angle=0, mode="normal") {
  // mode: normal or cutout

  // position should be such that the hinge pin in centered on the outside
  // edge of the back wall, and so the lid is exactly touching, when the
  // hinge is rotated "lid.angle" down from horizontal. I think I did
  // the math right...after the 4th time!
  let (t=prop("panel.thickness"), a=prop("lid.angle"), r=prop("hinge.radius"), h=prop("box.back.height"))
  translate([
    0, // already starting at x=0
    -t, // move to the outside of the back wall
    h + t*tan(a) - r/cos(a) // extension of the lid along angle a
  ])
    rotate([angle-a, 0, 0])
      _assembly(mode=mode);
}

lid();
