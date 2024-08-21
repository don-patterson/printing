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
  ["socket.wall.ratio", 0.75], // higher=taller thick wall
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

// Single wall board piece, with n sides. Outside wall is size `width`.
// Using n !=4 is experimental, but looks possible with triangles or
// of course hexagons!
// TODO/known issue: these values kinda depend on each other, so they're not
// quite parameters to the function...
module socket(
  n=4,
  width=prop("socket.width"),
  depth=prop("socket.depth"),
  thick_wall=prop("socket.wall.thick"),
  thin_wall=prop("socket.wall.thin"),
  wall_ratio=prop("socket.wall.ratio"),
  chamfer=prop("socket.wall.chamfer"),
  margin=0,
) {
  render() difference() {
    // full block
    prism(n, side=width, z=depth, on="z+", margin=margin);

    // hole for the thick walls
    prism(n, side=width-2*thick_wall, z=big, margin=-margin);

    // chamfer to the thin wall. Note: margin_z is ignored here
    // for a tight fit in the "depth" direction
    translate([0, 0, depth*wall_ratio - chamfer])
      prism(n, side=width-2*thin_wall, z=big, on="z+", chamfer=chamfer,
           margin_side=-margin);
    }
}

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

_plug_tabs();

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

  // front plate
//  box(x=plate_width, y=plate_width, z=thick_wall, on="z-", chamfer=thick_wall/4);
}



/*
module plugv2(
  width=prop("width"),
  depth=prop("depth"),
  thick_wall=prop("thick_wall"),
  thin_wall=prop("thin_wall"),
  tolerance=0.15,
) {
  plug_width = width - 2*(thick_wall + tolerance);

  hole_depth = depth/4 + thick_wall - thin_wall;
  hole_length = plug_width * 0.7;
  hole_width = thin_wall;
  hole_t = (hole_width*3 - plug_width)/2;

  // holes to let the tabs flex inward
  render()
  difference() {
    _plug_block(tolerance=tolerance);

    // vertical gap
    translate([0, hole_t, depth])
      box(x=hole_length, y=hole_width, z=hole_depth, on="z-");
    // horiontal gap
    translate([0, hole_t-hole_width/2, depth-hole_depth])
      box(x=hole_length, y=2*hole_width, z=hole_width, on="z-");

    translate([0, -hole_t, depth])
      box(x=hole_length, y=hole_width, z=hole_depth, on="z-");
    translate([0, -hole_t+hole_width/2, depth-hole_depth])
      box(x=hole_length, y=2*hole_width, z=hole_width, on="z-");

    translate([hole_t, 0, depth])
      box(x=hole_width, y=hole_length, z=hole_depth, on="z-");
    translate([hole_t-hole_width/2, 0, depth-hole_depth])
      box(y=hole_length, x=2*hole_width, z=hole_width, on="z-");

    translate([-hole_t, 0, depth])
      box(x=hole_width, y=hole_length, z=hole_depth, on="z-");
    translate([-hole_t+hole_width/2, 0, depth-hole_depth])
      box(y=hole_length, x=2*hole_width, z=hole_width, on="z-");
  }
}

module plugv3(
  width=prop("width"),
  depth=prop("depth"),
  thick_wall=prop("thick_wall"),
  thin_wall=prop("thin_wall"),
  tolerance=0.1,
) {
  plug_width = width - 2*(thick_wall + tolerance);

  hole_depth = depth*3/4;
  hole_length = plug_width * 0.7;
  hole_width = thin_wall;
  hole_t = (hole_width*3 - plug_width)/2;

  // holes to let the tabs flex inward
  render()
  difference() {
    _plug_block(tolerance=tolerance);

    // vertical gap
    translate([0, hole_t, depth])
      box(x=hole_length, y=hole_width, z=hole_depth, on="z-");
    // horiontal gap
    translate([0, hole_t-hole_width/2, depth-hole_depth])
      box(x=hole_length, y=2*hole_width, z=hole_width, on="z-");

    translate([0, -hole_t, depth])
      box(x=hole_length, y=hole_width, z=hole_depth, on="z-");
    translate([0, -hole_t+hole_width/2, depth-hole_depth])
      box(x=hole_length, y=2*hole_width, z=hole_width, on="z-");

    translate([hole_t, 0, depth])
      box(x=hole_width, y=hole_length, z=hole_depth, on="z-");
    translate([hole_t-hole_width/2, 0, depth-hole_depth])
      box(y=hole_length, x=2*hole_width, z=hole_width, on="z-");

    translate([-hole_t, 0, depth])
      box(x=hole_width, y=hole_length, z=hole_depth, on="z-");
    translate([-hole_t+hole_width/2, 0, depth-hole_depth])
      box(y=hole_length, x=2*hole_width, z=hole_width, on="z-");
  }
}
*/
