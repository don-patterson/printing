include <BOSL2/std.scad>
$fa = $preview ? 1 : .1;
$fs = $preview ? 1 : .1;


t = 15;
m = 0.1;

foot = 12;
width = 195;


module base_low() {
  diff()
  cube([width, t, t], anchor=CENTER) {
    // feet
    align([LEFT,RIGHT], BACK) cube([t, foot+t, t]);

    // arms
    align(LEFT+BACK) cube([t, t, t], spin=35);
    align(RIGHT+BACK) cube([t, t, t], spin=-35);

    // cutouts, etc
    children();
  }
}


base_low()
  attach(FWD, FWD, inside=true, shiftout=t/2) cube([t+2*m, t+m, t+m]);

fwd(3*t) base_low() {
  attach(BACK, BACK, inside=true, shiftout=t/2) cube([t+2*m, t+m, t+m]);
  attach(FWD, FWD) cube([t, foot, t]);
}
