include <BOSL2/std.scad>   // https://github.com/BelfrySCAD/BOSL2
include <BOSL2/gears.scad>
$fa = $preview ? .5 : .1;
$fs = $preview ? .5 : .1;
eps = 0.01;

// fixed constants (should stay the same between revisions to all gears are compatible)
tooth_size = 4; // not exactly, but this affects the size of the teeth
thickness = 6;

// parameters
magnet_diameter = 3;
magnet_thickness = 2;

module gear(teeth) {
  diff()
  spur_gear(circ_pitch=tooth_size, thickness=thickness, teeth=teeth)
    attach(BOTTOM, BOTTOM, inside=true, shiftout=eps) cyl(h=magnet_thickness, d=magnet_diameter);
}
right(20) back(20) gear(teeth=17);
back(50) gear(teeth=29);

module mag_cutout(wall=0.1) {
  tube(id1=4, id2=8, h=2, wall=wall)
    attach(TOP, BOT) tube(id1=8, id2=2, h=3, wall=wall)
      attach(TOP, TOP, inside=true) cyl(h=wall, d=2+2*wall);
}

mag_cutout();
