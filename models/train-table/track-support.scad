include <BOSL2/std.scad>   // https://github.com/BelfrySCAD/BOSL2
include <BOSL2/threading.scad>
$fa = $preview ? .5 : .1;
$fs = $preview ? .5 : .1;

step_height = 62;

post_x = 16;
post_y = 24;

foot_margin = 12;
foot_x = post_x + 2*foot_margin;
foot_y = post_y + 2*foot_margin;

module foot() {
  prismoid([foot_x, foot_y], [post_x, post_y], h=foot_margin)
    children();
}

module cutout() {
  difference() {
    cube(99, anchor=BOT);
    back(20) cyl(h=99, d=170, anchor=FWD+BOT);
    fwd(20) cyl(h=99, d=170, anchor=BACK+BOT);
  }
}

module post(steps=1) {
  difference() {
    cube([post_x, post_y, steps*step_height], anchor=CENTER+BOT) {
      attach(BOT, BOT, inside=true) foot();
      attach(TOP, BOT, inside=true) foot() {
        attach(BOT, BOT, align=[BACK, FWD]) cube([foot_x, 4, 8]);
      };
    }

    up(steps*step_height) cutout();
  }
}

post(2);
