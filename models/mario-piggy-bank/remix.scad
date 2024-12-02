$fa = $preview ? .5 : .1;
$fs = $preview ? .5 : .1;


// original box side length 
s = 75;

// original magnet holes
mag_d = 6;
mag_h = 3;
mag_offset = [s/2 - 8, s/2 - 8, s/2 - 11];

// new size (scale factor) and new magnet size
new_s = 120/s;
new_mag_d = 6;
new_mag_h = 2;

module magnet(d, h) {
  translate([0, 0, -h]) cylinder(d=d, h=h);
}

module box() {
  difference() {
    scale(new_s) {
      import("./original/box.stl");
      // fill the original magnet holes
      for (a=[0:90:359]) {
        rotate([0, 0, a])
          translate(mag_offset)
            magnet(d=mag_d, h=mag_h);
      }
    }

    // cut out some new magnet holes
    for (a=[0:90:359]) {
      rotate([0, 0, a])
        translate(new_s*mag_offset + [0, 0, 0.001])
            magnet(d=new_mag_d, h=new_mag_h);
    }
  }
}

module lid() {
  lid_mag_offset = mag_offset + [0, 0, 0.2];
  rotate([180, 0, 0])
  difference() {
    scale(new_s) {
      import("./original/deksel_v3.stl");
      // fill the original magnet holes. The hull/intersection part isn't really
      // needed, but keeps the fill from interfering with the fillet.
      intersection() {
        hull() import("./original/deksel_v3.stl");
        union() {
          for (a=[0:90:359]) {
            rotate([0, 0, a])
              translate(lid_mag_offset + [0, 0, mag_h])
                magnet(d=mag_d, h=mag_h);
          }
        }
      }
    }

    // cut out some new magnet holes
    for (a=[0:90:359]) {
      rotate([0, 0, a])
        translate(new_s*lid_mag_offset + [0, 0, new_mag_h])
            magnet(d=new_mag_d, h=new_mag_h);
    }
  }
}

module accents() {
  scale([new_s, new_s, 1]) // don't scale the thickness
    rotate([0, 90, 0])
      import("./original/___.stl");
}
