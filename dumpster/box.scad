use <props.scad>

$fn = $preview ? 30 : 128;

module _front(
  width=prop("box.width"),
  height=prop("box.front.height"),
  thickness=prop("panel.thickness")
) {
  translate([0, prop("box.depth")-thickness, 0])
  difference() {
    cube([width, thickness, height]);
    // "v" cutouts, 1.2 thickness here leaves about half the thickness left
    translate([-1, 1.2*thickness, height/3])
      rotate([45, 0, 0])
        cube([width+2, thickness, thickness]);
    translate([-1, 1.2*thickness, 2*height/3])
      rotate([45, 0, 0])
        cube([width+2, thickness, thickness]);
  }
}

module _back(
  width=prop("box.width"),
  height=prop("box.back.height"),
  thickness=prop("panel.thickness"),
) {
  translate([0, -thickness, 0])
    cube([width, thickness, height]);
}

module _side(
  depth=prop("box.depth"),
  front_height=prop("box.front.height"),
  back_height=prop("box.back.height"),
  thickness=prop("panel.thickness"),
) {
  translate([thickness, 0, 0])
    rotate([0, -90, 0])
      linear_extrude(height=thickness)
        polygon([[0, 0], [0, depth], [front_height, depth], [back_height, 0]]);
}

module _bottom(
  width=prop("box.width"),
  depth=prop("box.depth"),
  thickness=prop("panel.thickness"),
) {
  cube([width, depth, thickness]);
}

module box() {
  _back();
  _front();
  _side();
  translate([prop("box.width")-prop("panel.thickness"), 0, 0])
    _side();
  _bottom();
}

box();
