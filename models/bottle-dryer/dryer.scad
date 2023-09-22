$fa = $preview ? 1 : .1;
$fs = $preview ? 1 : .1;

w = 30;
h = 30;
t = 3;
m = 0.1;


module triangle(margin=0) {
  t=t+2*margin;
  translate([0,0,-t/2])
    linear_extrude(t)
      polygon([[-3*t,0], [0,3*t], [3*t, 0]]);
}
module leg() {
  translate([-w, 0, -t/2])
    cube([2*w, t, t]);
}
module post() {
  translate([t/2,0,-t/2])
    rotate([0,0,90])
      cube([w,t,t]);
}


module base() {
    difference() {
        union() {
            triangle();
            leg();
            post();
        }
        
        rotate([0,90,0])
            leg();
    }
}

module support() {
    difference() {
        union() {
            triangle();
            leg();
        }
        
        rotate([0,90,0])
            base();
    }
}

%triangle(margin=1);
triangle();