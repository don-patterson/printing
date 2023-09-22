use <props.scad>
use <../../lib/util.scad>

$fn = $preview ? 30 : 128;

// mode idea:
// use mode "normal" for the shape if it's free of any obstructions
// use mode "margin" to subtract space around the shape so that it can move
// use mode "cutout" to subtract interior space for a shape so that it can be inserted into a solid

module _fin(
  l=prop("hinge.fin.length"),
  w=prop("hinge.fin.width"),
  h=prop("hinge.fin.height"),
  a=prop("hinge.fin.taper.angle"),
  m=prop("hinge.fin.margin"),
  mode="normal", // "normal" or "margin"
  bump=undef, // "left", "right", or undef
) {
  // fin arm (no margins necessary)
  translate([0, 0, -w/2])
    linear_extrude(w)
      translate([0, -h/2, 0])
        polygon([[0,0], [0, h], [l, h], [l - (h / tan(a)), 0]]);

  // circular part (with optional margin)
  translate([0, 0, -w/2 - (mode == "margin" ? m : 0)])
    linear_extrude(w + (mode == "margin" ? 2*m : 0))
      circle(d=h + (mode == "margin" ? 2*m : 0));

  // latch bump
  if (bump)
    translate([l - h/tan(a) - w, 0, 0])
      intersection() {
        sphere(r=w + (mode == "margin" ? m : 0));
        translate([-w, -w, bump == "left" ? 0 : -2*w])
          cube(2*w);
      }
}

module _fins(
  // mode: normal or margin
  start=prop("hinge.fin.start"),
  end=prop("hinge.fin.end"),
  count=prop("hinge.fin.count"),
  w=prop("hinge.fin.width"),
  margin=prop("hinge.fin.margin"),
  mode="normal",
) {
  start = start + w/2;
  end = end - w/2;

  // first fin
  translate([0, 0, start])
    _fin(mode=mode, bump="right");

  // interior fins
  for (i=[1:count - 2])
    translate([0, 0, start + i * (end - start) / (count - 1)])
      _fin(mode=mode);

  // last fin
  translate([0, 0, end])
    _fin(mode=mode, bump="left");
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
  wall_thickness=prop("panel.thickness"),
  mode="normal"
) {
  _top();
  rotate([90,0,90]) {
    _fins(mode=mode == "normal" ? "normal" : "margin");
    _pin(mode=mode == "normal" ? "normal" : "margin");
    _cuff();
  }
  if (mode != "normal")
    rotate([90,0,0]) {
      r_extrude(x=120)
        square([cutout_width, cutout_radius]);
      // clear the gap between the top and the hinge cuff
      r_extrude(x=-45)
        translate([wall_thickness, 0, 0])
          square([cutout_width - 2*wall_thickness, cutout_radius]);
    }
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
