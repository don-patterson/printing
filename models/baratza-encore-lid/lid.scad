include <BOSL2/std.scad>
$fa = .5;
$fs = .5;
eps = 0.01;

ring_d = 130;
ring_h = 8;
ring_t = 4;

lid_t = 3;
lid_d = ring_d + 5;

bowl_r = 80;
bowl_h = 8;

handle_w = 15;

module lid() {
  cyl(h=lid_t, d=lid_d, anchor=BOT)
    attach(BOT, TOP)
      // taper the ring a bit, to insert easier
      tube(h=ring_h, od1=ring_d-1, id1=ring_d-ring_t,
                     od2=ring_d,   id2=ring_d-ring_t);
}

// bowl shape cutout for the handle
module bowl() {
  yscale(.7) bottom_half(s=3*bowl_r) down(bowl_h) sphere(r=bowl_r, anchor=BOT);

}
xrot(180) {
  difference() {
    union() {
      lid();
      bowl();
    }

    up(lid_t+eps) bowl();
  }

  // handle to grab
  up(lid_t) intersection() {
    down(eps) bowl();
    cube([ring_d,handle_w,bowl_h], anchor=TOP);
  }

  // break away supports for the rounded part of the cap
  up(lid_t) intersection() {
    // sandwich between the normal bowl and a +.2 bowl to form a small gap
    down(eps) bowl();
    up(.2) bowl();
    difference() {
      // supports themselves
      cube([2, ring_d, bowl_h], anchor=TOP);

      // copy of the handle, slightly wider for a small gap
      cube([ring_d,handle_w+.2,bowl_h], anchor=TOP);
    }
  }
}
