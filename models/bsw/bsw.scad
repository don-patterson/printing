use <../../lib/props.scad>
use <../../lib/shapes.scad>
include <BOSL2/std.scad>
$fa = $preview ? .5 : .1;
$fs = $preview ? .5 : .1;

prop_map = [
  // main parameters
  ["socket.width", 21],
  ["socket.depth", 8],
  ["socket.wall.thick", 1.8],
  ["socket.wall.thin", 1.0],
  ["socket.chamfer.start", 1], // min 0.75 for current (arbitrary) bump size
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
      // I think this 2-sided variant could be handy, with cutouts only on the vertical walls
      // to make the horizonal part (think shelf hooks) extra sturdy
      cuboid([width-2*thin_wall, width-2*thick_wall, chamfer_start + chamfer],
             chamfer=chamfer, edges=[BOT+LEFT, BOT+RIGHT]);
}

// TODO: could turn all these arbitrary values into properties
// or computed properties, but I just found something that works
module plug(
  width=prop("plug.width"),
  depth=prop("plug.depth"),
  tab_width=prop("plug.tab.width"),
  plate_width=prop("plug.plate.width"),
) {
  diff() // for the "attached" cutouts
  cuboid([width, width, depth], anchor=BOT) {
    // face plate
    position(BOTTOM) cuboid([plate_width, plate_width, 2], anchor=TOP)
      // cutout for a flat screwdriver to pop out the plug
      attach(FRONT, FRONT, inside=true, shiftout=0.01, align=TOP)
        cuboid([5, (plate_width-width)/2, 0.8]);

    // bumps to stick out and snap fit in the chamfered part of the wall
    position(TOP+LEFT) right(0.3) down(.25) ycyl(l=tab_width, r=0.8, anchor=TOP);
    position(TOP+RIGHT) left(0.3) down(.25) ycyl(l=tab_width, r=0.8, anchor=TOP);

    // cut around the bumps to leave a thing filament spring for the bumps
    attach(TOP, TOP, inside=true, shiftout=0.01, align=[LEFT,RIGHT], inset=0.8)
      cuboid([0.8, 2*tab_width, 2.8]);
    attach(TOP, TOP, inside=true, shiftout=0.01, align=[LEFT,RIGHT], overlap=-2.1)
      cuboid([1.6, 2*tab_width, 0.8]);

    children();
  }
}

module hsw_plug() {
  plug()
    attach(TOP, TOP, inside=true, shiftout=0.01)
      regular_prism(6, d=13.4, h=30);
}


// example:
cols=3; // [1:1:20]
rows=2;  // [1:1:20]
width=prop("socket.width");
// Note that orientation matters. This is a `cols` wide by `rows` high wall
for (i=[0:cols-1]) {
  for (j=[0:rows-1]) {
    right(i*width) back(j*width) socket();
  }
}
left(24) up(2) plug();

fwd(24) up(2) hsw_plug();
