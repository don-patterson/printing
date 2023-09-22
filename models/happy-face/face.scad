$fn=1000;
color("lightblue")
  difference() {
    linear_extrude(2)
      circle(r=45);

    translate([16,20,1])
      linear_extrude(2)
        circle(r=5);
    translate([-16,20,1])
      linear_extrude(2)
        circle(r=5);
 
    translate([0,0,1])
      linear_extrude(2) {
        intersection() {
          translate([-50, -100, 0])
            square(100);
          circle(r=30);
        }
      }
  }