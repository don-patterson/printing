include <BOSL2/std.scad>
$fa = $preview ? 1 : .1;
$fs = $preview ? 1 : .1;

fob_w = 37.7;
side_clip_w = 20;
plug_w = 4;

fob_section = [
  [0,0], [0,12], [fob_w/2, 13.5], [fob_w, 12], [fob_w, 0], [fob_w/2, -1.5]
];

difference() {
  cube([42, 16, 0.6]);
  down(.01) back(2) right(2)
    linear_extrude(1) 
      polygon(
        smooth_path(fob_section, method="corners", closed=true)
      );
}


// difference() {
//   cube([25, 25, 4], anchor=CENTER);
//   cube([23.4, 55, 2.2], anchor=CENTER);
// }
