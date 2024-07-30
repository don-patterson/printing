use <../../lib/props.scad>
use <../../lib/shapes.scad>
$fa = $preview ? 1 : .1;
$fs = $preview ? 1 : .1;

prop_map = [
  ["width", 21],
  ["depth", 8],
  ["wall_thickness", 1.8],
  ["wall_cutout", 1],
  ["wall_chamfer", 2], // kinda arbitrary right now
];

function prop(key) = getprop(key, prop_map);

// Single wall board piece, with n sides. Outside wall is size `width`.
// Using n !=4 is experimental, but looks possible with triangles or
// of course hexagons!
module wall_unit(
  n=4,
  width=prop("width"),
  depth=prop("depth"),
  thick_wall=prop("wall_thickness"),
  thin_wall=prop("wall_thickness") - prop("wall_cutout"),
  wall_chamfer=prop("wall_chamfer"),
  margin=0,
) {
  render()
  difference() {
    ngon(n, side=width, z=depth, on="z+", margin=margin);
    translate([0, 0, -50])
      ngon(n, side=width-2*thick_wall, z=depth+100, on="z+", margin=-margin);
    translate([0, 0, depth*3/4 - wall_chamfer])
      ngon(n, side=width-2*thin_wall, z=depth+100, on="z+", margin=-margin,
           chamfer=wall_chamfer);
  }
}

module plug(
  n=4,
  width=prop("width"),
  depth=prop("depth"),
  thick_wall=prop("wall_thickness"),
  thin_wall=prop("wall_thickness") - prop("wall_cutout"),
  wall_chamfer=prop("wall_chamfer"),
  margin=0.25,
) {
  // main block
  translate([0,0,-margin])
    %box(x=width-2*thick_wall-2*margin, y=width-2*thick_wall-2*margin, z=10, on="z+");
    ngon(n, side=width-2*thick_wall, z=depth+2*margin, on="z+", margin=-margin);

  // front plate
//  %ngon(n, side=width-2*thin_wall, z=thin_wall, on="z-", chamfer=thin_wall/4);
}

//translate([0, 0, 15])
//  wall_unit();
plug();