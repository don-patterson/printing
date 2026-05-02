include <BOSL2/std.scad>
$fa = $preview ? 5 : .5;
$fs = $preview ? 2 : .2;
eps = 0.01;

board_t = 5;
hole_r = 2.4;

h = 0.95;

// trim a bit off the circle so it lays flat on the print bed
trimmed_circle = intersection([
  square([2*hole_r + eps, 2*hole_r*h], anchor=CENTER),
  circle(r=hole_r, anchor=CENTER),
]);

// for carving off the bottom of the hook, so you have room to insert the peg in the board
cutout = intersection([
  square([2*hole_r + eps, 2*hole_r*h], anchor=LEFT),
]);

difference() {
  // hook
  path_sweep2d(
    trimmed_circle,
    turtle([
      "setdir", 180,
      "move", board_t,
      "move", 2*hole_r - 1,
      "arcright", 1,
      "move", 3,
    ])
  );

  #left(board_t + hole_r - 2)
  path_sweep2d(
    cutout,
    turtle([
      "setdir", 180,
      "move", 3,
      "arcright", 1,
      "move", 3 + eps,
    ])
  );
}

// post
path_sweep2d(
  trimmed_circle,
  turtle(["right","move",20])
);

// support
path_sweep2d(
  trimmed_circle,
  turtle([
    "move", 10 // 40,
    // "turn", -135,
    // "untilx", 0,
    // "turn", -45,
    // "move", 5+r
  ])
);
