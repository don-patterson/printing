use <../../lib/props.scad>
use <../../lib/shapes.scad>
include <BOSL2/std.scad>
$fa = $preview ? .5 : .1;
$fs = $preview ? .5 : .1;
big = 99;

prop_map = [
  // main parameters
  ["socket.width", 21],
  ["socket.depth", 8],
  ["socket.wall.thick", 1.8],
  ["socket.wall.thin", 1.0],
  ["socket.chamfer.start", 0.75],
  ["tolerance", 0.1],

  // computed values
  ["socket.chamfer", "$socket.wall.thick - $socket.wall.thin"], // 45 degree chamfer
  ["plug.width", "$socket.width - (2 * ($socket.wall.thick + $tolerance))"],
  ["plug.depth", "$socket.depth"],
  ["plug.base.width", "$socket.width - (2 * ($socket.wall.thick + $tolerance))"],
  ["plug.top.width",  "$socket.width - (2 * ($socket.wall.thin + $tolerance))"],
  ["plug.tab.width", "$plug.top.width / 3"],
  ["plug.tab.chamfer", "$socket.chamfer"], // same as the chamfer on the bottom
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

module _plug_block(
  width=prop("plug.width"),
  depth=prop("plug.depth"),
  tab_width=prop("plug.tab.width"),
) {
  cuboid([width, width, depth], anchor=BOT) {
    position(LEFT+TOP) right(0.3) ycyl(l=tab_width, r=0.8, anchor=TOP);
    position(RIGHT+TOP) left(0.3) ycyl(l=tab_width, r=0.8, anchor=TOP);
  }

}

// test fit with print
socket();
right(24) _plug_block();
