include <BOSL2/std.scad>
include <BOSL2/beziers.scad>
include <don/bosl2-shapes.scad>

$fa = $preview ? 1 : .1;
$fs = $preview ? 1 : .1;

// pretend the units are inches, to get the proportions right. Then scale later
post_r = 2;
arc_r = 2;
goal_height = 4*12;
goal_width = 6*12;

f=0.8;


function flattened_circle(r) = intersection(
    circle(r),
    rect([2*r+1, 2*r*f]),
);

module frame(h, r=post_r) {
  path_sweep(
    flattened_circle(r=r),
    turtle(["left",
      "move", h - (arc_r - r),
      "arcright", arc_r,
      "move", goal_width - 2*(arc_r - r),
      "arcright", arc_r,
      "move", h - (arc_r - r),
    ])
  )
    children();
}

frame(h=goal_height);

fwd(55)
difference() {
  frame(h=goal_height/2)
    attach(["start", "end"], LEFT) 
      cuboid([3*post_r, 3*post_r, 0.8*2*post_r], rounding=1, edges="Z");

  down(post_r*f+.1) fwd(3*post_r/2) xrot(90) frame(h=goal_height, r=post_r);
}
  
    
