include <BOSL2/std.scad>
$fa = $preview ? 1 : .1;
$fs = $preview ? 1 : .1;

blade_width = 3;
blade_heights = [
  [0, 20],
  [25, 16],
  [155, 16],
  [185, 20],
  // close it off downward:
  [185,0],
  [0,0],
];

module blade() {
  linear_extrude(blade_width)
    polygon(blade_heights);
}

minkowski() {
  blade();
  sphere(r=2);
}
