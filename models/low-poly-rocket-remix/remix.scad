include <BOSL2/std.scad>   // https://github.com/BelfrySCAD/BOSL2
include <BOSL2/threading.scad>
$fa = $preview ? .5 : .1;
$fs = $preview ? .5 : .1;

z_offset = 20.936;
z_top_begin = 110;
slice_r = 33.8;

module posts(margin=0) {
  up(z_top_begin) 
    for (r=[0:120:359]) {
      zrot(30+r)
        right(slice_r)
          cyl(r=1.2+margin, h=2, anchor=BOT);
    }
  
}

module body() {
  intersection() {
    up(z_top_begin) cube(999, anchor=TOP);
    down(z_offset) import("./original/BodyMain-LowPoly.stl");
  }
  posts();
}

module top() {
  difference() {
    intersection() {
      up(z_top_begin) cube(999, anchor=BOT);
      down(z_offset) import("./original/BodyMain-LowPoly.stl");
    }
    posts(.1);
  }
}

module wing() {
  difference() {
    import("./original/Wing-Print-x3-LowPoly.stl");
    left(43.11) up(30) yrot(55) cube(10, anchor=BOT+LEFT);
  }
}

module foot() {
  scale([.9, .9, 1])
    difference() {
      import("./original/WingThruster-Print-x3-LowPoly.stl");
      left(62.5) up(11) cyl(r=99, h=99, anchor=BOT);
    }
}


top();
// body();
// wing();
// foot();
