include <BOSL2/std.scad>
$fa = .5;
$fs = .5;
eps = 0.01;

/* basic pot:
 *   __________ 
 *  |    r_top |
 *  |          |  h_top
 *  \          /
 *   \        /
 *    \      /    h_bowl
 *     \____/
 *        r_bowl
 */

wall = 2;
r_top = 65;
h_top = 25;
h_bowl = 90;
r_bowl = 45;
tabs = true;

tube(or=r_top, h=h_top, wall=wall, anchor=TOP)
  attach(BOT, TOP)
    tube(or2=r_top, or1=r_bowl, h=h_bowl, wall=wall)
      attach(BOT, BOT, inside=true)
        cyl(r=r_bowl, h=wall);

if (tabs) {
  // can't figure out how to put this inside the above with attach/position/whatever
  intersection() {
    cyl(r=r_top, h=h_top, anchor=TOP);

    tube(or=r_top, h=h_top, wall=wall, anchor=TOP)
      position([RIGHT+TOP, LEFT+TOP])
        cube(10, anchor=CENTER, orient=BOT+LEFT);
  }
}
