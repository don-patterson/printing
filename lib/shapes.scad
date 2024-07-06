$fa = $preview ? 1 : .1;
$fs = $preview ? 1 : .1;

// Beginnings of a shapes library. I want shapes with a "margin" property
// and possibly specific overrides for margins in a particular direction.
// The idea is to add a thickness around the outside of the entire shape
// without changing the center of the shape. This can be used with
// `difference` to carve out space for shapes to fit, with adjustable
// tolerance.

module triangle_equilateral(
  r=undef, base=undef, // must specify one of r or base for side length
  d, // depth/thickness
  on="center", // origin at "center" or "base"
  margin=0,       // global margin
  margin_r=undef, // override r margin
  margin_d=undef  // override depth margin
) {
  margin_r = margin_r == undef ? margin : margin_r;
  margin_d = margin_d == undef ? margin : margin_d;
  r = r == undef ? (base/sqrt(3)) : r;
  ty = on == "center" ? 0 :
      on == "base" ? r/2 :
      assert(false, "invalid on");
  translate([0, ty, 0])
    rotate([0,0,-30])
      cylinder(h=d+2*margin_d, r=r+margin_r, $fn=3, center=true);
}


difference() {
  %triangle_equilateral(base=8, d=2, on="base", margin=2, margin_d=.4);
   triangle_equilateral(base=8, d=2, on="base");
}