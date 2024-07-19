use <../../lib/shapes.scad>
$fa = $preview ? 1 : .1;
$fs = $preview ? 1 : .1;

depth = 101;
height = 101;
width = 70;
wall = 1.6;

difference() {
  box(x=depth+2*wall, y=width+2*wall, z=height+wall, on="z-");
  box(x=depth,        y=width,        z=height,      on="z-");
  rotate([90,0,0])
    cylinder(d=height/4, h=width+2*wall+1, center=true);
}