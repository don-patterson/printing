use <prop-lib.scad>        // https://github.com/don-patterson/printing/blob/main/lib/prop-lib.scad
include <BOSL2/std.scad>   // https://github.com/BelfrySCAD/BOSL2
$fa = $preview ? .5 : .1;
$fs = $preview ? .5 : .1;
eps=0.01;
prop_map = [
  // main parameters
  ["socket.width", 21],
  ["socket.depth", 8],
  ["socket.wall", 2],
  ["socket.rounding", 0.8],
  ["insert.width", 12],
  ["hsw.insert.width", 13.3], // by the spec it's 13.4 but I found that was too loose
  ["plug.faceplate.depth", 1.8],
  ["spring.thickness", 0.8],
  ["spring.gap", 0.6],
  ["margin", 0.1], // TODO: could do BOSL2 $slop test

  // computed values
  ["socket.chamfer.w", "$socket.wall * 0.5"],
  ["socket.chamfer.d", "$socket.wall * 0.6"],
  ["plug.width", "$socket.width - (2 * $socket.wall)"],
  ["plug.depth", "$socket.depth"],
  ["plug.faceplate.width", "$socket.width - (2 * $margin)"],
  ["spring.height", "$socket.chamfer.d * 1.5"],
  ["spring.width", "$plug.width * 0.65"],
  ["tab.height", "$socket.chamfer.d"],
  ["tab.width", "$spring.width * 0.4"],
];
function prop(key) = getprop(key, prop_map);

// pyramid section for the chamfered section of the socket
module _wedge(
  margin_xy=0,
  margin_h=0,
  width=prop("socket.width"),
  wall=prop("socket.wall"),
  chamfer_w=prop("socket.chamfer.w"),
  chamfer_d=prop("socket.chamfer.d"),
  rounding=prop("socket.rounding"),
  anchor=undef,
) {
  w = width - 2*wall + margin_xy;
  prismoid(size1=w + 2*chamfer_w, size2=w, h=chamfer_d, anchor=anchor, rounding1=2*rounding, rounding2=rounding)
    children();
}

// the basic component of the wall board
module socket(
  width=prop("socket.width"),
  depth=prop("socket.depth"),
  wall=prop("socket.wall"),
  rounding=prop("socket.rounding"),
) {
  diff()
  rect_tube(h=depth, size=width, wall=wall, irounding=rounding)
    attach([TOP,BOT], BOT, inside=true, shiftout=eps)
      _wedge(margin_h=eps);
}

// pointy part that catches when the plug is fully inserted
module _tab(
  height=prop("tab.height"),
  width=prop("tab.width"),
) {
  // I just fiddled with these values until it looked ok
  prismoid(size1=[width, height], size2=[width, 0.2], h=0.4);
}
// inspect and adjust:
// back_half() socket();
// fwd(0.5) back_half() plug();

// base for all plugs that print on the face
module plug(
  width=prop("plug.width"),
  depth=prop("plug.depth"),
  faceplate_width=prop("plug.faceplate.width"),
  faceplate_depth=prop("plug.faceplate.depth"),
  margin=prop("margin"),
  rounding=prop("socket.rounding"),
  spring_gap=prop("spring.gap"),
  spring_height=prop("spring.height"),
  spring_thickness=prop("spring.thickness"),
  spring_width=prop("spring.width"),
  horizontal_tabs=true,
) {
  diff()
  cuboid([width - margin, width - margin, depth], anchor=BOT, rounding=rounding, edges="Z") {
    // pyramid shape to fit the socket
    position(BOTTOM) _wedge(margin_xy=-margin);

    // face plate
    position(BOTTOM) cuboid([faceplate_width, faceplate_width, faceplate_depth], anchor=TOP)
      // cutout for a flat screwdriver to pop out the plug
      attach([LEFT,RIGHT,FRONT,BACK], TOP, inside=true, shiftout=eps, align=TOP)
        cuboid([6, 0.6, 1.2]);

    // cut around the tabs to leave a thin filament spring
    attach(TOP, TOP, inside=true, shiftout=eps, align=[LEFT,RIGHT], inset=spring_thickness)
      cuboid([spring_gap, spring_width, spring_height+spring_gap]);
    attach(TOP, TOP, inside=true, shiftout=eps, align=[LEFT,RIGHT], overlap=-spring_height)
      cuboid([spring_thickness+spring_gap, spring_width, spring_gap]);
    if (horizontal_tabs) {
      attach(TOP, TOP, inside=true, shiftout=eps, align=[FWD,BACK], inset=spring_thickness)
        cuboid([spring_width, spring_gap, spring_height+spring_gap]);
      attach(TOP, TOP, inside=true, shiftout=eps, align=[FWD,BACK], overlap=-spring_height)
        cuboid([spring_width, spring_thickness+spring_gap, spring_gap]);
    }

    // tab to catch and snap in place
    attach([RIGHT, LEFT], BOT, align=TOP) _tab();
    if (horizontal_tabs) {
      attach([FWD, BACK], BOT, align=TOP) _tab();
    }
  }
}

module wall(x, y, width=prop("socket.width")) {
  for (i=[0:x-1]) {
    for (j=[0:y-1]) {
      right(i*width) back(j*width) socket();
    }
  }
}

// example
left(prop("socket.width") + 5)
  up(prop("plug.faceplate.depth"))
    plug();
wall(3, 2);
