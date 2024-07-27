use <../../lib/shapes.scad>;

/* This model has been a total failure so far, but
   has given me an idea or two. The main faults/problems
   to solve in future versions are:
   - zip tie isn't held into the tabs! lol
   - it tends to crease right before the rung (and break)
   - the tabs aren't that strong, and can shear along the layer line

   One of the ideas is the `box` model should take a list of `on`
   values, like `on=["x+","y+"]` or `on="x+,y+"`
*/
rung_span = 6;
rung_gap = 2;
wall = 2;
t = 1;
tol=.4;
c = .4;

module rung(gap=rung_gap, span=rung_span, tab=false) {
  translate([0, span/2+wall/2, 0])
    box(wall+gap, wall, t, on="z+");
  translate([wall/2, 0, 0])
    box(wall, span, t, on="z+");
  translate([0, -span/2-wall/2, 0])
    box(wall+gap, wall, t, on="z+");

  if (tab) {
    translate([wall/2, 0, t])
      difference() {
        box(wall, span-tol, t-tol, on="z+");
        translate([0, 0, (t-tol)/2])
          rotate([0, -45, 0])
            box(100, on="z+");
      }
  }
}

for (i=[0:20])
  translate([(rung_gap+wall)/2 + (rung_gap+wall)*i, 0, 0])
    rung(tab=false); // tab=(i<2)

// head
//difference() {
//  translate([0, 0, 2*t])
//    box(10, rung_span+4*wall, 4*t, on="x-");
//  translate([0, 0, t+(t+tol)/2])
//    box(10, rung_span+2*wall+tol, t+tol, on="x-");
//}

// catch
translate([0,0,t/2])
  box(wall, rung_span+4*wall+tol, t, on="x-");
translate([-3*wall,0,t/2])
 box(wall, rung_span+4*wall+tol, t, on="x-");

