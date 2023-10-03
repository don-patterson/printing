use <props.scad>

$fn = $preview ? 30 : 128;


module fins(
  start,
  end,
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
  // kinda don't care about length and heigth for the cutout margin

  for (i=[0:count - 1])
    translate([0, 0, start + i * (end - w - start) / (count - 1)])
      linear_extrude(w) {
        translate([0, -h/2, 0])
          polygon([[0,0], [0, h], [l, h], [l - (h / tan(a)), 0]]);
        circle(d=d);
      }
}


module pin(
  start,
  end,
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


fins(start=5, end=55);
pin(start=0, end=60);
%pin(start=0, end=60, mode="margin");
%fins(start=5, end=55, mode="margin");