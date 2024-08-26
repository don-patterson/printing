use <./strings.scad>

$fa = $preview ? 1 : .1;
$fs = $preview ? 1 : .1;

// Beginnings of a 3d shapes library. I want shapes with a "margin" property
// and possibly specific overrides for margins in a particular direction.
// The idea is to add a thickness around the outside of the entire shape
// without changing the center of the shape. This can be used with
// `difference` to carve out space for shapes to fit, with adjustable
// tolerance.

// accept an int or 3d vector and return 3d vector
function _vec(arg) = is_num(arg) ? [arg, arg, arg] : arg;

// given on="x+,y+" or whatever, figure out the translation vector
function _t(on, x=0, y=0, z=0) = 
  let(t = split(on, ","))
  (contains(t, "x+") ? [ x, 0, 0] : [0, 0, 0]) +
  (contains(t, "x-") ? [-x, 0, 0] : [0, 0, 0]) +
  (contains(t, "y+") ? [0,  y, 0] : [0, 0, 0]) +
  (contains(t, "y-") ? [0, -y, 0] : [0, 0, 0]) +
  (contains(t, "z+") ? [0, 0,  z] : [0, 0, 0]) +
  (contains(t, "z-") ? [0, 0, -z] : [0, 0, 0]);

module prism(
  n=undef,
  r=undef, side=undef, // must specify one of r or side length
  z=undef, // thickness (in z direction)
  on="origin", // placement: origin | x+ | z+,y- | etc
  margin=0,       // global margin
  margin_r=undef, margin_side=undef, // override r margin
  margin_z=undef, // override z margin
  chamfer=0,
) {
  a = 180/n;
  margin_side = margin_side == undef ? margin : margin_side;
  margin_r = margin_r == undef ? margin_side/cos(a) : margin_r;
  margin_z = margin_z == undef ? margin : margin_z;
  r = r == undef ? side/(2*sin(a)) : r;
  translate(_t(on, y=r*cos(a), z=z/2))
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



//difference() {
//  %prism(n=5, r=8, z=4, chamfer=1, on="y+,z-", margin=1);
//  prism(n=5, r=8, z=4, chamfer=1, on="y+,z-");
//}

module box(
  x=undef, y=undef, z=undef,  // 3 ways to specify size
  on="origin", // placement: origin | x+ | z+,y- | etc
  margin=0, // global margin
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

  translate(_t(on, x=s.x/2, y=s.y/2, z=s.z/2))
    if (chamfer > 0) {
      // This looks pretty wild, but I just want to maintain a minimum margin
      // in each of the specified directions from the chamfer, so to keep the
      // chamfer angles all at 45, you need take the smallest chamfer out of
      // the big shape (box + margins) that maintains the right margin
      // distance in each direction.
      cyz = 2*(min(m.y, m.z) + chamfer);
      cxz = 2*(min(m.x, m.z) + chamfer);
      cxy = 2*(min(m.x, m.y) + chamfer);
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

//box(1, chamfer=.1, on="z+,x-");
//%box(x=10, y=10, z=.1, on="z+,x-");


// Here's an idea I had to make chamfers easy, by defining the box by its
// 6 panels and taking the hull to fill in the chamfers. It's simpler than
// my original chamfer box, so I think I'll drop this in as a replacement.
// It also allows different margins and chamfers for each dimension.
eps=.001;
module _chamfer_box(
  x, y, z,          // dimensions
  cx=0, cy=0, cz=0, // chamfers
  mx=0, my=0, mz=0, // margins
) {
  t = [
    mx + (x - eps)/2,
    my + (y - eps)/2,
    mz + (z - eps)/2
  ];
  s = [
    x - cx + 2*mx,
    y - cy + 2*my,
    z - cz + 2*mz
  ];
  hull() {
    // top and bottom
    translate([0, 0,  t.z]) cube([s.x, s.y, eps], center=true);
    translate([0, 0, -t.z]) cube([s.x, s.y, eps], center=true);
    // left and right
    translate([0,  t.y, 0]) cube([s.x, eps, s.z], center=true);
    translate([0, -t.y, 0]) cube([s.x, eps, s.z], center=true);
    // back and front
    translate([ t.x, 0, 0]) cube([eps, s.y, s.z], center=true);
    translate([-t.x, 0, 0]) cube([eps, s.y, s.z], center=true);
  }
}
%_chamfer_box(x=10, y=20, z=8, cx=3, cy=1, cz=2, mx=1, my=2, mz=10);
_chamfer_box(x=10, y=20, z=8, cx=3, cy=1, cz=2);
