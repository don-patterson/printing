include <BOSL2/std.scad>
$fa = .5;
$fs = .5;
eps = 0.01;

ring_d = 128;
ring_h = 5;
ring_t = 4;

lid_t = 3;
lid_d = ring_d + 5;
bowl_r = 80;
bowl_h = 8;

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

  up(lid_t) intersection() {
    down(eps) bowl();
    cube([ring_d,15,bowl_h], anchor=TOP);
  }
}
