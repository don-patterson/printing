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
  ["insert.width", 12],
  ["hsw.insert.width", 13.3], // by the spec it's 13.4 but I found that was too loose
  ["plug.faceplate.depth", 1.4],
  ["spring.thickness", 0.8],
  ["spring.gap", 0.6],
  ["margin", 0.1], // TODO: do BOSL2 $slop test

  // computed values
  ["plug.width", "$socket.width - (2 * $socket.wall)"],
  ["plug.depth", "$socket.depth"],
  ["plug.faceplate.width", "$socket.width - (2 * $margin)"],
  ["tab.height", "$socket.wall / 2"],
  ["tab.width", 5],
  ["spring.height", "$socket.wall * 0.75"],
  ["spring.width", "$plug.width - (6 * $spring.thickness)"],
];
function prop(key) = getprop(key, prop_map);

// pyramid section for the chamfered section of the socket
module _wedge(
  margin_xy=0,
  margin_h=0,
  width=prop("socket.width"),
  wall=prop("socket.wall"),
  anchor=undef,
) {
  bot = width - 1.2*wall + margin_xy; // TODO make this a property
  top = width - 2*wall + margin_xy;
  h = wall/2 + margin_h;
  prismoid(size1=bot, size2=top, h=h, anchor=anchor)
    children();
}

// the basic component of the wall board
module socket(
  width=prop("socket.width"),
  depth=prop("socket.depth"),
  wall=prop("socket.wall"),
) {
  diff()
  rect_tube(h=depth, size=width, wall=wall)
    attach([TOP,BOT], BOT, inside=true, shiftout=eps)
      _wedge(margin_h=eps);
}

module _tab(
  height=prop("tab.height"),
  width=prop("tab.width"),
) {
  prismoid(size1=[height, width], size2=[0.2, width], h=0.6);
}

module plug(
  width=prop("plug.width"),
  depth=prop("plug.depth"),
  faceplate_width=prop("plug.faceplate.width"),
  faceplate_depth=prop("plug.faceplate.depth"),
  margin=prop("margin"),
  spring_gap=prop("spring.gap"),
  spring_height=prop("spring.height"),
  spring_thickness=prop("spring.thickness"),
  spring_width=prop("spring.width"),
  horizontal_tabs=true,
) {
  diff()
  cuboid([width - margin, width - margin, depth], anchor=BOT) {
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

    // TODO: do the tabs now
  }
}

// back_half() {
// socket();
plug();
// }

// The main plug shape (fully filled in) with faceplate and tabs to snap in place
module plug_block(
  width=prop("plug.width"),
  depth=prop("plug.depth"),
  tab_width=prop("plug.tab.width"),
  tab_cutout_width=prop("plug.tab.cutout.width"),
  faceplate_width=prop("plug.faceplate.width"),
  faceplate_thickness=prop("plug.faceplace.thickness"),
  horizontal_tabs=true,
) {
  diff() // for the "attached" cutouts
  cuboid([width, width, depth], anchor=BOT) {
    // face plate
    position(BOTTOM) cuboid([faceplate_width, faceplate_width, faceplate_thickness], anchor=TOP)
      // cutout for a flat screwdriver to pop out the plug
      attach([LEFT,RIGHT,FRONT,BACK], TOP, inside=true, shiftout=0.01, align=TOP)
        cuboid([6, 0.8, (faceplate_width-width)/2]);

    // tabs to stick out and snap fit in the chamfered part of the wall
    position(TOP+LEFT) right(0.3) ycyl(l=tab_width, r=0.8, anchor=TOP);
    position(TOP+RIGHT) left(0.3) ycyl(l=tab_width, r=0.8, anchor=TOP);
    if (horizontal_tabs) {
      position(TOP+FWD) back(0.3) xcyl(l=tab_width, r=0.8, anchor=TOP);
      position(TOP+BACK) fwd(0.3) xcyl(l=tab_width, r=0.8, anchor=TOP);
    }

    // cut around the tabs to leave a thin filament spring
    attach(TOP, TOP, inside=true, shiftout=0.01, align=[LEFT,RIGHT], inset=0.8) cuboid([0.8, tab_cutout_width, 2.55]);
    attach(TOP, TOP, inside=true, shiftout=0.01, align=[LEFT,RIGHT], overlap=-1.6) cuboid([1.6, tab_cutout_width, 0.8]);
    if (horizontal_tabs) {
      attach(TOP, TOP, inside=true, shiftout=0.01, align=[FWD,BACK], inset=0.8) cuboid([tab_cutout_width, 0.8, 2.55]);
      attach(TOP, TOP, inside=true, shiftout=0.01, align=[FWD,BACK], overlap=-1.6) cuboid([tab_cutout_width, 1.6, 0.8]);
    }

    children();
  }
}

module wall(x, y, width=prop("socket.width")) {
  for (i=[0:x-1]) {
    for (j=[0:y-1]) {
      right(i*width) back(j*width) socket();
    }
  }
}
