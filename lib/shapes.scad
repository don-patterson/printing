use <./strings.scad>

$fa = $preview ? 1 : .1;
$fs = $preview ? 1 : .1;

// Beginnings of a 3d shapes library. I want shapes with a "margin" property
// and possibly specific overrides for margins in a particular direction.
// The idea is to add a thickness around the outside of the entire shape
// without changing the center of the shape. This can be used with
// `difference` to carve out space for shapes to fit, with adjustable
// tolerance.

module ngon(
  n=undef,
  r=undef, side=undef, // must specify one of r or side length
  z=undef, // thickness (in z direction)
  on="origin", // placement: origin | y+
  margin=0,       // global margin
  margin_r=undef, // override r margin
  margin_z=undef, // override depth margin
  chamfer=0,
) {
  margin_r = margin_r == undef ? margin : margin_r;
  margin_z = margin_z == undef ? margin : margin_z;
  a = 180/n;
  r = r == undef ? side/(2*sin(a)) : r;
  t = on == "y+" ? [0, r*cos(a),   0]
    : on == "z+" ? [0,        0, z/2]
    :              [0,        0,   0];
  translate(t)
    rotate([0, 0, 90 - (n%2 == 0 ? a : 0)])
      if (chamfer > 0) {
        // chamfer should be measured in distance perpendicular to the side, which is at
        // angle `a` from `r` (i.e. the same angle we have to rotate if n is odd.
        cz = chamfer;
        cr = chamfer/cos(a);
        // TODO chamfer should depend on the margin, but it's pretty tedious
        // for a small gain
        translate([0, 0, (z + 2*margin_z - cz)/2])
          cylinder(h=cz, r1=r + margin_r, r2=r + margin_r - cr, $fn=n, center=true);
        cylinder(h=z + 2*margin_z - 2*cz, r=r + margin_r, $fn=n, center=true);
        translate([0, 0, -(z + 2*margin_z - cz)/2])
          cylinder(h=cz, r2=r + margin_r, r1=r + margin_r - cr, $fn=n, center=true);
      } else {
        cylinder(h=z + 2*margin_z, r=r + margin_r, $fn=n, center=true);
      }
}


ngon(4, side=21-2*0.8, z=8, on="z+", chamfer=1);

//difference() {
//  %ngon(n=5, r=8, z=4, chamfer=1, on="y+", margin=1);
//  ngon(n=5, r=8, z=4, chamfer=1, on="y+");
//}

module box(
  x=undef, y=undef, z=undef,  // 3 ways to specify size
  on="origin",    // placement: origin | x+ | y+ | z+
  margin=0,  // global margin
  margin_x=undef,  // override margins
  margin_y=undef,
  margin_z=undef,
  chamfer=0, // flatten the corners
) {
  s = is_num(z)  ? [x, y, z]  // size: x=num, y=num, z=num
    : is_list(x) ? x          //   or: x=[num, num, num]
    : [x, x, x];              //   or: x=num
  m = [
    margin_x == undef ? margin : margin_x,
    margin_y == undef ? margin : margin_y,
    margin_z == undef ? margin : margin_z
  ];

  translate(on == "x+" ? [ s.x/2,      0,      0]
          : on == "x-" ? [-s.x/2,      0,      0]
          : on == "y+" ? [     0,  s.y/2,      0]
          : on == "y-" ? [     0, -s.y/2,      0]
          : on == "z+" ? [     0,      0,  s.z/2]
          : on == "z-" ? [     0,      0, -s.z/2]
          :              [     0,      0,      0])
    if (chamfer > 0) {
      // This looks pretty wild, but I just want to maintain a minimum margin
      // in each of the specified directions from the chamfer, so to keep the
      // chamfer angles all at 45, you need take the smallest chamfer out of
      // the big shape (box + margins) that maintains the right margin
      // distance in each direction.
      cyz = 2*min(m.y, m.z) + chamfer;
      cxz = 2*min(m.x, m.z) + chamfer;
      cxy = 2*min(m.x, m.y) + chamfer;
      intersection() {
        cube(s + 2*m, center=true);
        rotate([45,0,0])
          cube([
            s.x + 2*m.x + 1,
            (s.y + 2*m.y + s.z + 2*m.z - cyz)/sqrt(2),
            (s.y + 2*m.y + s.z + 2*m.z - cyz)/sqrt(2)
          ], center=true);
        rotate([0,45,0])
          cube([
            (s.x + 2*m.x + s.z + 2*m.z - cxz)/sqrt(2),
            s.y + 2*m.y + 1,
            (s.x + 2*m.x + s.z + 2*m.z - cxz)/sqrt(2)
          ], center=true);
        rotate([0,0,45])
          cube([
            (s.x + 2*m.x + s.y + 2*m.y - cxy)/sqrt(2),
            (s.x + 2*m.x + s.y + 2*m.y - cxy)/sqrt(2),
            s.z + 2*m.z + 1
          ], center=true);
      }
    } else {
      cube(s + 2*m, center=true);
    }
}

//difference() {
//  box(10, 20, 30, chamfer=4, margin=1, margin_x=2);
//  box(10, 20, 30, chamfer=4);
//  // see through to the chamfer on different margins
//  color("red") box(100, on="z+");
//}