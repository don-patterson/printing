function bezier(points, count=30) =
  // Generate points along the bezier curve for a given list of control points
  len(points) == 1
  ? [for (i=[0:count-1]) points[0]]
  : let (head=bezier([for (i=[0:len(points)-2]) points[i]], count),
         tail=bezier([for (i=[1:len(points)-1]) points[i]], count))
    [for (i=[0:count-1]) head[i] + (tail[i] - head[i]) * i / (count-1)];

/*// Demo
p0 = [0, 0];
p1 = [6, 1];
p2 = [5, 5];
p3 = [2, 4];
for (i = bezier([p0, p1], count=10)) translate(i) circle(r=.1, $fn=32);
for (i = bezier([p1, p2], count=10)) translate(i) circle(r=.1, $fn=32);
for (i = bezier([p2, p3], count=10)) translate(i) circle(r=.1, $fn=32);
for (i = bezier([p0, p1, p2, p3])) color("green") translate(i) circle(r=.1, $fn=32);
//*/

module r_extrude(x=undef, y=undef) {
  // rotation extrude, without the weird z axis flip up thing
  if (x == undef)
    rotate([-90,0,180])
      rotate_extrude(angle=y)
        rotate([0,0,180])
          children();
  else
    rotate([-90,0,-90])
      rotate_extrude(angle=x)
        rotate([0,0,90])
          children();
}
