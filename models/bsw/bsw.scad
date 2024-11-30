use <prop-lib.scad>        // https://github.com/don-patterson/printing/blob/main/lib/prop-lib.scad
include <BOSL2/std.scad>   // https://github.com/BelfrySCAD/BOSL2
$fa = $preview ? .5 : .1;
$fs = $preview ? .5 : .1;

prop_map = [
  // main parameters
  ["socket.width", 21],
  ["socket.depth", 8],
  ["socket.wall.thick", 1.8],
  ["socket.wall.thin", 1.0],
  ["socket.chamfer.start", .75], // min 0.75 to make room for the tab
  ["margin", 0.1],
  ["insert.width", 12],
  ["hsw.insert.width", 13.3], // by the spec it's 13.4 but I found that was too loose
  ["plug.faceplace.thickness", 2],

  // computed values
  ["full.depth", "($socket.depth + $plug.faceplace.thickness) + 1"],
  ["socket.chamfer", "$socket.wall.thick - $socket.wall.thin"], // 45 degree chamfer
  ["plug.width", "$socket.width - ((2 * $socket.wall.thick) + $margin)"],
  ["plug.depth", "$socket.depth"], // these have to be the same
  ["plug.tab.width", "$plug.width / 3"],
  ["plug.tab.cutout.width", "$insert.width"], // don't have to be the same, but it looks nice
  ["plug.faceplate.width", "$socket.width - (2 * $margin)"],
];
function prop(key) = getprop(key, prop_map);

// the basic component of the wall board
module socket(
  width=prop("socket.width"),
  depth=prop("socket.depth"),
  thick_wall=prop("socket.wall.thick"),
  thin_wall=prop("socket.wall.thin"),
  chamfer_start=prop("socket.chamfer.start"),
  chamfer=prop("socket.chamfer"),
  variant="normal",
) {
  diff()
  rect_tube(h=depth, size=width, wall=thick_wall)
    attach(TOP, TOP, inside=true, shiftout=0.01)
      cuboid([width-2*thin_wall, width-2*thin_wall, chamfer_start + chamfer], chamfer=chamfer, edges=BOT);
}

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

// wall(8, 6);
