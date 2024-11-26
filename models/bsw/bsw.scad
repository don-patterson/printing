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
  ["margin.s", 0.05],
  ["margin.m", 0.1],

  // computed values
  ["socket.chamfer", "$socket.wall.thick - $socket.wall.thin"], // 45 degree chamfer
  ["plug.width", "$socket.width - (2 * ($socket.wall.thick + $margin.s))"],
  ["plug.depth", "$socket.depth"],
  ["plug.tab.width", "$plug.width / 3"],
  ["plug.plate.width", "$socket.width - (2 * $margin.m)"],
];

function prop(key) = getprop(key, prop_map);

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

// TODO: could turn all these arbitrary values into properties
// or computed properties, but I just found something that works
module plug(
  width=prop("plug.width"),
  depth=prop("plug.depth"),
  tab_width=prop("plug.tab.width"),
  plate_width=prop("plug.plate.width"),
  horizontal_tabs=true,
) {
  diff() // for the "attached" cutouts
  cuboid([width, width, depth], anchor=BOT) {
    // face plate
    position(BOTTOM) cuboid([plate_width, plate_width, 2], anchor=TOP)
      // cutout for a flat screwdriver to pop out the plug
      attach([LEFT,RIGHT,FRONT,BACK], TOP, inside=true, shiftout=0.01, align=TOP)
        cuboid([6, 0.8, (plate_width-width)/2]);

    // tabs to stick out and snap fit in the chamfered part of the wall
    position(TOP+LEFT) right(0.3) ycyl(l=tab_width, r=0.8, anchor=TOP);
    position(TOP+RIGHT) left(0.3) ycyl(l=tab_width, r=0.8, anchor=TOP);
    if (horizontal_tabs) {
      position(TOP+FWD)   back(0.3) xcyl(l=tab_width, r=0.8, anchor=TOP);
      position(TOP+BACK)   fwd(0.3) xcyl(l=tab_width, r=0.8, anchor=TOP);
    }

    // cut around the tabs to leave a thin filament spring
    attach(TOP, TOP, inside=true, shiftout=0.01, align=[LEFT,RIGHT], inset=0.8) cuboid([0.8, 12, 2.55]);
    attach(TOP, TOP, inside=true, shiftout=0.01, align=[LEFT,RIGHT], overlap=-1.6) cuboid([1.6, 12, 0.8]);
    if (horizontal_tabs) {
      attach(TOP, TOP, inside=true, shiftout=0.01, align=[FWD,BACK], inset=0.8) cuboid([12, 0.8, 2.55]);
      attach(TOP, TOP, inside=true, shiftout=0.01, align=[FWD,BACK], overlap=-1.6) cuboid([12, 1.6, 0.8]);
    }

    children();
  }
}

module hsw_plug() {
  plug(horizontal_tabs=false)
    attach(TOP, TOP, inside=true, shiftout=0.01)
      regular_prism(6, id=13.4, h=30);
}

module hollow_plug() {
  plug()
    attach(TOP, TOP, inside=true, shiftout=0.01)
      cuboid([12,12,30]);
}


// example:
width=prop("socket.width");
cols=4;
rows=3;
for (i=[0:cols-1]) {
  for (j=[0:rows-1]) {
    right(i*width) back(j*width) socket();
  }
}

up(2) fwd(24) {
  hollow_plug();
  right(22) hsw_plug();
}
