include <BOSL2/std.scad>   // https://github.com/BelfrySCAD/BOSL2
include <BOSL2/threading.scad>
$fa = $preview ? .5 : .1;
$fs = $preview ? .5 : .1;

// dimensions
collar_od = 34.1;
thread_od = 24.5;
spacer_l = 70;


difference() {
  cyl(h=spacer_l, d=collar_od);
  trapezoidal_threaded_rod(d=thread_od, l=spacer_l+20, pitch=(1/4)*INCH, thread_depth=1.4, thread_angle=40, internal=true);
}
up((spacer_l+3)/2)
  difference() {
    cyl(h=3, d=collar_od);
    cyl(h=4, d=thread_od);
  }

