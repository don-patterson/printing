include <BOSL2/std.scad>
$fa = $preview ? 2 : .2;
$fs = $preview ? 1 : .1;
eps = 0.01;

board_t = 5;
hole_r = 2.5;
peg_r = 2.45;

module board(x=100, y=60, r=hole_r, t=board_t, spacing=40) {
  difference() {
    cube([x, y, t], anchor=CENTER);
    grid_copies(
      inside=square([x+spacing/2, y+spacing/2], anchor=CENTER),
      spacing=[spacing/2, spacing/2],
      stagger=true,
    )
      cylinder(r=r, h=t + eps, anchor=CENTER);
  }
}

module _main_peg(r, h, anchor, rounding1, cap_h, negative=false) {
  // choose between ycyl and teardrop (for cutouts)
  if (negative) {
    teardrop(r=r, h=h, anchor=anchor, cap_h=cap_h) children();
  } else {
    ycyl(r=r, h=h, anchor=anchor, rounding1=rounding1) children();
  }
}

module peg(h, r=peg_r, end_offset=1.2, end_t=1, ring_gap=board_t, ring_t=1, ring_r=1, slop=1.02, negative=false) {
  // pegboard peg that you have to print in two parts. The top half and bottom half each
  // have a circular cross section so they individually fit in the hole. The top half
  // is then slid up `stopper_gap` mm and the bottom can be inserted.

  wiggle = negative ? slop : 1;
  anchor_h = (end_t + ring_gap)*slop + ring_t;

  down(negative ? 0 : end_offset/2) // whether to center on the peg (for subtraction from a hook or shelf) or on the top/bottom printing division
  back(anchor_h)
  difference() {
        _main_peg(r=r*wiggle , h=h*wiggle + anchor_h, anchor=BACK, rounding1=r, cap_h=r, negative=negative) {
          // stopper at the end so that the peg can't get pulled out after placement
          attach(BACK, FWD, align=UP, inset=-end_offset, inside=true) ycyl(r=r, h=end_t);

          // ring to prevent sliding the peg too far in
          attach(BACK, FWD, inside=true, shiftout=-(end_t + ring_gap)*slop) ycyl(r=r+ring_r, h=ring_t, anchor=BACK);

          // bump out at the tip to snap fit attachements (TODO: make this scale properly with r)
          attach(FWD, BOT, shiftout=-(7 + (h*wiggle - h))) scale([1.15 * wiggle, 1]) cyl(r=r, h=6, chamfer=1, chamfang=70);
        }

    // cutout for snap fit tip to flex inward
    if (!negative)
    fwd(h+anchor_h+eps) cube([1.6, 10, 2*r], anchor=FRONT) attach(BACK, BOT) prismoid(size1=[1.6,2*r], size2=[0,2*r], h=1);
  }
}

module parts(shift=15) {
  top_half() children();
  right(shift) yrot(180) bottom_half() children();
}

back(30) parts() peg(15);
back(30) left(30) parts() peg(15);



// Shelf demo
w15_in = 3;
w15_out = 4;
w20_in = 3;
w20_out = 4;
w25_in = 3;
w25_out = 4;
w30_in = 4;
w30_out = 5;
w40_in = 5;
w40_out= 6.3;
w50_in = 6;
w50_out= 7.6;
w60_in = 7;
w60_out= 8.3;

module wera_cutout(in, out) {
  zrot(45) {
    xcyl(h=20, d=in*+1, anchor=RIGHT);
    zcyl(h=20, d=out+1, anchor=CENTER);
  }
}

up(3)
difference() {
  cube([87, 17, 6], anchor=BACK);
  left(40)  peg(15, negative=true);
  right(40) peg(15, negative=true);
  fwd(17/2) up(6/2) {
    xdistribute(spacing=4, sizes=[w15_out, w20_out, w25_out, w30_out, w40_out, w50_out, w60_out]) {
      wera_cutout(w15_in, w15_out);
      wera_cutout(w20_in, w20_out);
      wera_cutout(w25_in, w25_out);
      wera_cutout(w30_in, w30_out);
      wera_cutout(w40_in, w40_out);
      wera_cutout(w50_in, w50_out);
      wera_cutout(w60_in, w60_out);
    }
  }
}
