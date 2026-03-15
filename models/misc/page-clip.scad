include <BOSL2/std.scad>
$fa = $preview ? 1 : .1;
$fs = $preview ? 1 : .1;


// print 1, way too big
w = 30;
h = 20;
r = 3;
t = 4;

// print 2
w = 15;
h = 50;
r = 1.5;
t = 2;


gap = 5;


cube([w, t, h]);
back(t-r) cyl(r=r, h=h, anchor=BOT); 
right(w) #cube([t, gap+2*t, h]);

back(gap+t) cube([w, t, h]);
back(gap+t+r) cyl(r=r, h=h, anchor=BOT); 
