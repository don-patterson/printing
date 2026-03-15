include <BOSL2/std.scad>
$fa = $preview ? 1 : .1;
$fs = $preview ? 1 : .1;


t = 15;
m = 0.1;

foot = 12;
width = 185;
leg_height = 160;


module single(bottom=false) {
  diff()
  cube([width, t, t], anchor=CENTER) {
    // feet
    align([LEFT,RIGHT], BACK) cube([t, foot+t, t]);

    // arms
    align(LEFT+BACK) cube([t, t, t], spin=35);
    align(RIGHT+BACK) cube([t, t, t], spin=-35);

    if (bottom) {
      // cutout top
      attach(BACK, BACK, inside=true, shiftout=t/2) cube([t+2*m, t+m, t+m]);
      // add foot to bottom center
      attach(FWD, FWD) cube([t, foot, t]);
    } else {
      // cutout bottom
      attach(FWD, FWD, inside=true, shiftout=t/2) cube([t+2*m, t+m, t+m]);
    }
  }
}

module dual(h=leg_height, bottom=false) {
  diff()
  cube([width, t, t], anchor=CENTER) {
    // legs
    align([LEFT,RIGHT], BACK) cube([t, t+h, t]);

    // arms
    align(LEFT+BACK) cube([t, t, t], spin=35);
    align(RIGHT+BACK) cube([t, t, t], spin=-35);

    if (bottom) {
      // cutout, with chamfer to help when sliding things into place
      attach(FWD, TOP, inside=true, shiftout=0.01) cube([t+2*m, t+m, t/2]);
      attach(FWD, TOP, inside=true, shiftout=t/4) prismoid(size1=[t+2*m, t+m], size2=[2*t+2*m, t+m], h=t/2);
    } else {
      // cutout
      attach(BACK, TOP, inside=true, shiftout=0.01) cube([t+2*m, t+m, t/2]);

      // center post
      attach(FWD, BACK) cube([15, h, 15]);
    }

    // bottom cross bar (sort of a repeat of `single`)
    align(FWD, shiftout=h-t) cube([width, t, t]) {
      // feet
      align([LEFT,RIGHT], BACK) cube([t, foot+t, t]);
      if (bottom) {
        // cutout, with chamfer to help when sliding things into place
        attach(BACK, TOP, inside=true, shiftout=0.01) cube([t+2*m, t+m, t/2]);
        attach(BACK, TOP, inside=true, shiftout=t/4) prismoid(size1=[t+2*m, t+m], size2=[2*t+2*m, t+m], h=t/2);
        // add foot to bottom center
        attach(FWD, FWD) cube([t, foot, t]);
      } else {
        // cutout bottom
        attach(FWD, FWD, inside=true, shiftout=t/2) cube([t+2*m, t+m, t+m]);
      }
    };
  }
}

single(bottom=true);
fwd(50) single();

right(250) {
  dual(bottom=true);
  right(250) dual();
}
