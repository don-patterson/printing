use <../../lib/props.scad>
use <../../lib/shapes.scad>
$fa = $preview ? 1 : .1;
$fs = $preview ? 1 : .1;

prop_map = [
  // main dimensions
  ["width", 21],
  ["depth", 8],
  ["thick_wall", 1.8],
  ["thin_wall", 0.8],

  // computed
  ["wall_chamfer", "$thick_wall - $thin_wall"],
];

function prop(key) = getprop(key, prop_map);

// Single wall board piece, with n sides. Outside wall is size `width`.
// Using n !=4 is experimental, but looks possible with triangles or
// of course hexagons!
module wall_hole(
  n=4,
  width=prop("width"),
  depth=prop("depth"),
  thick_wall=prop("thick_wall"),
  thin_wall=prop("thin_wall"),
  chamfer=prop("wall_chamfer"),
  margin=0,
) {
  render() difference() {
    // full block
    ngon(n, side=width, z=depth, on="z+", margin=margin);

    // hole for the thick walls
    ngon(n, side=width-2*thick_wall, z=2*(depth+margin), margin=-margin);

    // wider hole with chamfer
    translate([0, 0, depth*3/4 - chamfer])
      ngon(n, side=width-2*thin_wall, z=depth, on="z+", margin=-margin,
           chamfer=chamfer);
    }
}

module _plug_block(
  width=prop("width"),
  depth=prop("depth"),
  thick_wall=prop("thick_wall"),
  thin_wall=prop("thin_wall"),
  tolerance=0.15,
) {
  plug_width = width - 2*(thick_wall + tolerance);
  plug_top_width = width - 2*(thin_wall + tolerance);
  plate_width = width - 2*tolerance;
  tab_width = plug_width / 4;
  intersection() {
    // main block with tabs
    difference() {
      union() {
        box(x=plug_width, y=plug_width, z=depth, on="z+");
        box(x=width, y=tab_width, z=depth, on="z+");
        box(x=tab_width, y=width, z=depth, on="z+");
      }
      wall_hole(margin=tolerance);
    }

    // chamfer the top of the tabs
    box(x=plug_top_width, y=plug_top_width, z=depth, chamfer=thin_wall, on="z+");
  }

  // front plate
  box(x=plate_width, y=plate_width, z=thick_wall, on="z-", chamfer=thick_wall/4);
}

module plug(
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

plug();
