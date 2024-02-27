use <props.scad>
$fn = $preview ? 30 : 128;

module _arm(d, t) { // 3t x 4t with a 1t x 2t hole
  translate([0, -t, -2*t])
    difference() {
      cube([3*t, d+t, 4*t]);
      translate([t, -1, t])
        cube([t, d+t+2, 2*t]);
    }
}


module arms(
  box_w=prop("box.width"),
  box_h=prop("box.front.height"),
  box_d=prop("box.depth"),
  wall_t=prop("panel.thickness"),
) {
  translate([0, 0, box_h/2]) {
    translate([box_w, 0, 0])
      _arm(box_d, wall_t);
    mirror([1, 0, 0])
      _arm(box_d, wall_t);
  }
};

arms();
