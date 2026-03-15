include <BOSL2/std.scad>
$fa = $preview ? 1 : .1;
$fs = $preview ? 1 : .1;


knob_r = 2;
knob_h = 15;
cap = 2;
margin = 0.2;
hook_h = 4;  // height of finger hook
hook_d = 12; // depth of finger hook
hook_r = 3;  // radius of hook rounding

// this is a cool reference chart: https://www.hockeystickman.com/blogs/hockey-stick-alerts/ccm-shaft-shapes-on-pro-stock-sticks
// I think mine is a "C"
C = [19.75, 29.75, 5.75];


diff() {
  intersection() {
    cuboid([C.x + knob_r, C.y + knob_r, knob_h], rounding=C.z, except=[TOP, BOT], anchor=BOT);
    cuboid([C.x + knob_r, C.y + knob_r, knob_h], chamfer=2,    except=TOP,        anchor=BOT);
  }
  tag("remove") up(cap) {
    cuboid([C.x + margin, C.y + margin, 100], rounding=C.z-margin, except=[TOP, BOT], anchor=BOT);
    text3d("C", center=true);
  }
}
// Finger hook on the front bottom edge
fwd(C.y/2 + hook_d/2) cuboid([C.x -1.5*C.z, hook_d, hook_h], anchor=BOT);


// Still working this one out haha
