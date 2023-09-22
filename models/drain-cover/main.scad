//
//      |<--      tile      -->|
//       ______________________
//      /____   ________   ____\
//           |_|        |_|
//           |<-- post -->|
//
inf = 300; // "infinity"
width = 200;
post = 155;

module tile(width, height) {
  d=sqrt(2)*width;
  rotate([0,0,45])
    cylinder(d1=d, d2=d-2*height, h=height, $fn=4);
}

module tile_border(width, height) {
  d=sqrt(2)*width;
  rotate([0,0,45])
    difference() {
      cylinder(d1=d, d2=d-2*height, h=height, $fn=4);
      translate([0,0,-1])
      cylinder(d=d-4*height, h=height+2, $fn=4);
    }
}

module hole_border(width, height) {
  d=sqrt(2)*width;
  translate([0,0,-height])
    rotate([0,0,45])
      difference() {
        cylinder(d=d, h=height, $fn=4);
        translate([0,0,-1])
          cylinder(d=d-height, h=height+2, $fn=4);
      }
}



module bar(width) {
  cube([width, inf, inf], center=true);    
}

module grid(width, gap, angle=0, phase=0) {
  step = width+gap;
  limit = round(inf/(2*step));
  rotate([0,0,angle])
    translate([phase*step, 0, 0])
      for (i=[-limit:limit]) {
        translate([i*(width+gap), 0, 0])
          bar(width);
      }
}


intersection() {
  union() {
    grid(3, gap=16, angle=-45);
    grid(3, gap=16, angle=45);
    tile_border(200, 6);
  }
  union() {
    tile(200, 6);
  }
}
hole_border(post, 5);