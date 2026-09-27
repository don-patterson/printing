include <BOSL2/std.scad>
$fa = $preview ? 2 : .2;
$fs = $preview ? 1 : .1;
eps = 0.01;

module r_extrude(x=undef, y=undef, z=undef) {
  // rotation extrude about one of the axes
  assert(num_defined([x, y, z]) == 1, "Exactly one angle x,y, or z must be defined");
  if (x != undef) {
    rotate([-90,0,-90])
      rotate_extrude(angle=x)
        rotate([0,0,90])
          children();
  } else if (y != undef) {
    rotate([-90,0,180])
      rotate_extrude(angle=y)
        rotate([0,0,180])
          children();
  } else {
    rotate_extrude(angle=z)
      children();
  }
}


module board(x=100, y=60, r=2.5, t=5, spacing=40) {
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

module _cyl(r, h, anchor, rounding1, cap_h, negative=false) {
  // choose between ycyl and teardrop (for cutouts)
  if (negative) {
    teardrop(r=r, h=h, anchor=anchor, cap_h=cap_h) children();
  } else {
    ycyl(r=r, h=h, anchor=anchor, rounding1=rounding1) children();
  }
}

module pin(
  r=2.45,
  h1=8,
  h2=5.1,
  negative=false,
  snap_r=0.45,
  snap_h=1,
  snap_outer_angle=35,
  snap_inner_angle=45,
  slot_w=1.5,
  slot_h=4,
  stopper_r=2,
  stopper_h=1,
  trim=0.3,
) {

  path = turtle([
    // snap shape
    "ymove", .75*r,
    "left", snap_outer_angle, "untily", r+snap_r,
    "right", snap_outer_angle, "move", snap_h,
    "right", snap_inner_angle, "untily", r,
    "left", snap_inner_angle, "move", h1,
    
    // stopper 
    "ymove", stopper_r,
    "xmove", stopper_h,
    "ymove", -stopper_r,

    // snap shape at the other end
    "xmove", h2,
    "left", snap_inner_angle, "untily", r+snap_r,
    "right", snap_inner_angle, "move", snap_h,
    "right", snap_outer_angle, "untily", 0.75*r,
    "ymove", -0.75*r,
  ]);

  bounds = pointlist_bounds(path);
  x_max = bounds[1][0];
  r_max = bounds[1][1];
  snap_total_h = (x_max - h1 - h2 - stopper_h)/2;

  scale(negative ? [1,1.05,1.05] : 1)
  left(snap_total_h + h1 - eps)
  intersection() {
    difference() {
      // main pin
      union() {
        r_extrude(x=360) polygon(path);
        if (negative) {
          // extra gap at the end for room for the snap fit
          left(.5) xcyl(r=0.77*r, h=x_max, anchor=LEFT);
        }
      }

      if (!negative) {
        // cut out slots for snap fit
        right(         snap_total_h + slot_h - eps)  cuboid([snap_total_h + slot_h + slot_w, slot_w, 2*r_max + eps], anchor=RIGHT, rounding=slot_w/2);
        right(x_max - (snap_total_h + slot_h - eps)) cuboid([snap_total_h + slot_h + slot_w, slot_w, 2*r_max + eps], anchor=LEFT,  rounding=slot_w/2);
      }
    }

    if (negative) {
      cube([x_max, 2*r_max, 2*r_max], anchor=LEFT);
    } else {
      // cut off top and bottom for printing/space for snap fit motion
      cube([x_max, 2*r_max ,(1 - trim)*2*r], anchor=LEFT);
    }
  }
}

difference() {
  cube([15, 10, 10], anchor=RIGHT);
  pin(negative=true);
}
back(20) pin();
fwd(20) pin();
