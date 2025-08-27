include <don/bosl2-shapes.scad>


module hinge_test(t, gap=0.2) {
  end_hinge(width=15, segments=7, thickness=t, anchor=BOT, gap=gap) {
    attach(FWD, RIGHT) cube([15,15,t]);
    attach(BACK, LEFT) cube([15,15,t]);
  }
}


xdistribute(20) {
  hinge_test(2, gap=.1);
  hinge_test(2);
  hinge_test(3);
  hinge_test(4);
}

/* results:
    2: both fell apart pretty easily
    3: very sturdy
    4: The piece broke elsewhere before the hinge
*/
