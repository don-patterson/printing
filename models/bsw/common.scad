use <../../lib/props.scad>
use <../../lib/shapes.scad>
$fa = $preview ? 1 : .1;
$fs = $preview ? 1 : .1;

prop_map = [
  ["width", 21],
  ["depth", 8],
  ["thick_wall", 1.8],
  ["thin_wall", 0.8],
];

function prop(key) = getprop(key, prop_map);

// Single wall board piece, with n sides. Outside wall is size `width`.
// Using n !=4 is experimental, but looks possible with triangles or
// of course hexagons!
module wall_unit(
  n=4,
  width=prop("width"),
  depth=prop("depth"),
  thick_wall=prop("thick_wall"),
  thin_wall=prop("thin_wall"),
  margin=0,
) {
  chamfer = thick_wall - thin_wall;
  render() difference() {
    // full block
    ngon(n, side=width, z=depth, on="z+", margin=margin);

    // hole for the thick walls
    ngon(n, side=width-2*thick_wall, z=depth, on="z+", margin=-margin);

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
  tolerance=0.2,
) {
  // main block
  plug_width = width - 2*(thick_wall + tolerance);
  box(x=plug_width, y=plug_width, z=depth, on="z+");

  // tabs
  tab_width = plug_width / 3;
  difference() {
    union() {
      box(x=width, y=tab_width, z=depth, on="z+");
      box(x=tab_width, y=width, z=depth, on="z+");
    }
    wall_unit(margin=tolerance);
  }

  // front plate
  plate_width = width - 2*tolerance;
  box(x=plate_width, y=plate_width, z=thin_wall, on="z-", chamfer=thin_wall/4);
}

module plug(
  width=prop("width"),
  depth=prop("depth"),
  thick_wall=prop("thick_wall"),
  thin_wall=prop("thin_wall"),
  tolerance=0.2,
) {
  plug_width = width - 2*(thick_wall + tolerance);
  // cutouts
  render()
  difference() {
    _plug_block();
    translate([0, 1.5-plug_width/2, depth])
      box(x=plug_width*.7, y=1, z=depth/4+thick_wall-thin_wall, on="z-");
  }
}

plug();