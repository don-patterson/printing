use <../../lib/props.scad>
use <../../lib/shapes.scad>
$fa = $preview ? 1 : .1;
$fs = $preview ? 1 : .1;
big = 99;

prop_map = [
  // main parameters
  ["socket.width", 21],
  ["socket.depth", 8],
  ["socket.wall.thick", 1.8],
  ["socket.wall.thin", 0.8],
  ["socket.wall.ratio", 0.85], // higher=taller thick wall
  ["tolerance", 0.1],

  // computed values
  ["socket.wall.chamfer", "$socket.wall.thick - $socket.wall.thin"],
  ["plug.width", "$socket.width - (2 * ($socket.wall.thick + $tolerance))"],
  ["plug.depth", "$socket.depth"],
  ["plug.base.width", "$socket.width - (2 * ($socket.wall.thick + $tolerance))"],
  ["plug.top.width",  "$socket.width - (2 * ($socket.wall.thin + $tolerance))"],
  ["plug.tab.width", "$socket.width / 4"],
  ["plug.tab.chamfer", "$socket.wall.chamfer"], // same as the chamfer on the bottom
];

function prop(key) = getprop(key, prop_map);


include <BOSL2/std.scad>

module socket(
  width=prop("socket.width"),
  depth=prop("socket.depth"),
  thick_wall=prop("socket.wall.thick"),
  thin_wall=prop("socket.wall.thin"),
  thick_wall_ratio=prop("socket.wall.ratio"),
) {
  cutout_chamfer = thick_wall - thin_wall;
  cutout_depth = depth * (1-thick_wall_ratio) + cutout_chamfer;
  diff()
  rect_tube(h=depth, size=width, wall=thick_wall)
    attach(TOP, TOP, inside=true, shiftout=0.01)
      cuboid([width-2*thin_wall, width-2*thick_wall, cutout_depth],
              chamfer=cutout_chamfer, edges=[BOT+LEFT, BOT+RIGHT]);
  // could do conventional version where there are cutouts in every direction by subtracting:
  //    cuboid([21-1.6, 21-1.6, 3], chamfer=1, edges=BOT);
  // but I'm thinking just having the cutouts on the sides would make attachments
  // fit better and handle more weight
}
socket();

// TOOD: convert the rest to BOSL, replace this 1000 lines with 10

/*
module _plug_tabs() {
  depth=prop("plug.depth");
  width=prop("socket.width");
  plug_base_width=prop("plug.base.width");
  plug_top_width=prop("plug.top.width");
  tab_width=prop("plug.tab.width");
  chamfer=prop("plug.tab.chamfer");
  tolerance=prop("tolerance");
  
  render() difference() {
    intersection() {
      // box with tab sections sticking out
      union() {
        box(x=plug_base_width, y=plug_base_width, z=depth, on="z+");
        box(x=width, y=tab_width, z=depth, on="z+");
        box(x=tab_width, y=width, z=depth, on="z+");
      }
      // chamfer the top of the tabs
      box(x=plug_top_width, y=plug_top_width, z=depth, on="z+", chamfer=chamfer);
    }
    // shape/chamfer the bottom of the tabs to fit the socket
    socket(margin=tolerance);
    
    // cut around the thin tab walls
    gap = 1.2;
    wall = 0.8;
    thin_gap = 0.4;
    length = depth*.8;
    for (a=[0:90:270]) rotate([0, 0, a]) {
      translate([0, -plug_base_width/2 + wall, depth])
        box(x=tab_width, y=gap, z=length, on="z-,y+");
      translate([tab_width/2, -plug_base_width/2, depth])
        box(x=thin_gap, y=gap+wall, z=length, on="z-,x+,y+");
      translate([-tab_width/2, -plug_base_width/2, depth])
        box(x=thin_gap, y=gap+wall, z=length, on="z-,x-,y+");
    }
    
    // cut a chunk out of the middle block
    mid = plug_base_width - 4*wall - 2*gap;
    box(mid, on="z+");
  }
  
  // face plate
  prism(n=4, side=width, z=1.8, on="z-", chamfer=.4, margin_side=-.1);
//  box(x=width, y=width, z=1.8, on="z-", chamfer=.4);
}


module _plug_block(
  width=prop("plug.width"),
  depth=prop("plug.depth"),
  tab_width=prop("plug.tab.width"),
  tab_size=prop("plug.tab.size"),
  tolerance=prop("tolerance"),
) {
//  plug_width = width - 2*(thick_wall + tolerance);
//  plug_top_width = width - 2*(thin_wall + tolerance);
//  plate_width = width - 2*tolerance;
//  tab_width = plug_width / 4;
  render()
    // main block with tabs
    difference() {
      union() {
        box(x=width, y=width, z=depth, on="z+");
        box(x=tab_width, y=tab_size, z=depth, on="z+");
        box(x=tab_size, y=tab_width, z=depth, on="z+");
      }
      socket(margin=tolerance);
    }

}

*/
