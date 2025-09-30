include <BOSL2/std.scad>
$fa = $preview ? 1 : .1;
$fs = $preview ? 1 : .1;


knob_r = 6;
knob_h = 15;
cap = 2;
margin = 0.2;

// this is a cool reference chart: https://www.hockeystickman.com/blogs/hockey-stick-alerts/ccm-shaft-shapes-on-pro-stock-sticks
// I think mine is a "C"
C = [19.75, 29.75, 5.75];


difference() {
  cuboid([C.x + knob_r, C.y + knob_r, knob_h], rounding=C.z, except=[TOP, BOT], anchor=BOT);
  up(cap) {
    cuboid([C.x + margin, C.y + margin, 100], rounding=C.z-margin, except=[TOP, BOT], anchor=BOT);
    text3d("C", center=true);
  }
}
