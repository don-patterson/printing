use <../../lib/util.scad>

// smoothing
$fn = 256;
$bn = 256;

// main points that define this thing
p0 = [0,0];
p1 = [6, 0];
p2 = [19.5, 16];
p3 = [14, 20];

// variables
height = 26;
thickness = 3;
cap_h = 2.7;
cap_r = 11;
groove_w = 2.2;
groove_d = 3.3;
groove_a = 51;
post_h = 3;
post_r = 6;
overlap = 0.5;

path = concat(
  bezier([p0, p1], count=$bn),
  bezier([p1, p1 + [6,0], p2 + [0, -8], p2], count=$bn),
  bezier([p2, p2 + [0,2], p3 + [6, 0], p3], count=$bn)
);

module arm(path) {
  difference() {
    offset(r=thickness)
      polygon(path);
    polygon(path);
    polygon([[-10,0], [0, 0], 2*p3]);
  }
}

// clip
linear_extrude(height) {
  arm(path);
  mirror([1,0,0]) arm(path);
}

// post
translate([0, overlap - thickness, height/2])
  rotate([90, 0, 0])
    cylinder(h=post_h + 2*overlap, r=post_r);

module groove() {
  translate([-groove_w/2, cap_r - groove_d, -overlap])
    cube([groove_w, groove_d + 100, 100]);
}
// cap with grooves
translate([0, -(post_h + thickness), height/2])
  rotate([90, 0, 0])
    difference() {
      cylinder(h=cap_h, r=cap_r);
      rotate([0, 0, groove_a]) groove();
      rotate([0, 0, -groove_a]) groove();
      rotate([0, 0, 180+groove_a]) groove();
      rotate([0, 0, 180-groove_a]) groove();
    }
    
