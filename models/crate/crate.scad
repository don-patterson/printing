$fa = $preview ? 1 : .1;
$fs = $preview ? 1 : .1;

depth = 101;
height = 101;
width = 70;
wall = .86;

difference() {
  translate([0,0,-0.501*wall])
    cube([width+2*wall,
          height+2*wall,
          depth+wall], center=true);
  cube([width, height, depth], center=true);
  translate([0,0,height/2])
  rotate([0,90,0])
    cylinder(d=height/4, h=width+2*wall+2, center=true);
}