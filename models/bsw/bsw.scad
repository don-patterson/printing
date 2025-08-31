// License note:
// STLs and similar physical shapes produced from this code are derivative works of Honeycomb Storage Wall by RostaP
// and must be released under the same CC-BY-NC license (or a stricter CC 4.0 version). The `stl` folder in this
// repo has that license file, so any files in and under that directory are shared with the CC-BY-NC license.

include <BOSL2/std.scad>   // https://github.com/BelfrySCAD/BOSL2
$fa = $preview ? .5 : .1;
$fs = $preview ? .5 : .1;
eps=0.01;

// main parameters
$v_socket_width         = 21;
$v_socket_depth         = 8;
$v_socket_wall          = 2;
$v_socket_rounding      = 0.8;
$v_insert_width         = 12;
$v_hsw_insert_width     = 13.3; // by the spec it's 13.4 but I found that was too loose
$v_plug_faceplate_depth = 1.8;
$v_spring_thickness     = 0.8;
$v_spring_gap           = 0.6;
$v_margin               = 0.1; // TODO: could do BOSL2 $slop test

// computed values
function v_socket_chamfer_w()     = $v_socket_wall * 0.5;
function v_socket_chamfer_d()     = $v_socket_wall * 0.6;
function v_plug_width()           = $v_socket_width - 2 * $v_socket_wall;
function v_plug_depth ()          = $v_socket_depth;
function v_plug_faceplate_width() = $v_socket_width - 2 * $v_margin;
function v_insert_depth()         = $v_socket_depth + $v_plug_faceplate_depth;
function v_spring_height()        = v_socket_chamfer_d() * 1.5;
function v_spring_width()         = v_plug_width() * 0.65;
function v_tab_height()           = v_socket_chamfer_d();
function v_tab_width()            = v_spring_width() * 0.4;


// pyramid section for the chamfered section of the socket
module _wedge(
  margin_xy=0,
  margin_h=0,
  width=$v_socket_width,
  wall=$v_socket_wall,
  chamfer_w=v_socket_chamfer_w(),
  chamfer_d=v_socket_chamfer_d(),
  rounding=$v_socket_rounding,
  anchor=undef,
) {
  w = width - 2*wall + margin_xy;
  prismoid(size1=w + 2*chamfer_w, size2=w, h=chamfer_d, anchor=anchor, rounding1=2*rounding, rounding2=rounding)
    children();
}

// the basic component of the wall board
module socket(
  width=$v_socket_width,
  depth=$v_socket_depth,
  wall=$v_socket_wall,
  rounding=$v_socket_rounding,
) {
  diff()
  rect_tube(h=depth, size=width, wall=wall, irounding=rounding)
    attach([TOP,BOT], BOT, inside=true, shiftout=eps)
      _wedge(margin_h=eps);
}

// pointy part that catches when the plug is fully inserted
module _tab(
  height=v_tab_height(),
  width=v_tab_width(),
) {
  // I just fiddled with these values until it looked ok
  // h=0.4 is snug, but not super tight
  // h=0.5 is very tight but maybe too hard to remove
  prismoid(size1=[width, height], size2=[width, 0.2], h=0.5);
}

// base for all plugs that print on the face
module base_plug(
  width=v_plug_width(),
  depth=v_plug_depth(),
  faceplate_width=v_plug_faceplate_width(),
  faceplate_depth=$v_plug_faceplate_depth,
  margin=$v_margin,
  rounding=$v_socket_rounding,
  spring_gap=$v_spring_gap,
  spring_height=v_spring_height(),
  spring_thickness=$v_spring_thickness,
  spring_width=v_spring_width(),
  tabs=[LEFT,RIGHT,FWD,BACK],  // springy tabs that stick out to snap the plug in place
  slots=[LEFT,RIGHT,FWD,BACK], // cutouts for a flat screwdriver to help pop out the plug
) {
  diff()
  cuboid([width - margin, width - margin, depth], anchor=BOT, rounding=rounding, edges="Z") {
    // pyramid shape to fit the socket
    position(BOTTOM) _wedge(margin_xy=-margin);

    // face plate
    position(BOTTOM) cuboid([faceplate_width, faceplate_width, faceplate_depth], anchor=TOP)
      // cutout for a flat screwdriver to pop out the plug
      attach(slots, TOP, inside=true, shiftout=eps, align=TOP)
        cuboid([6, 0.6, 1.2]);

    // TODO: probably can do this all in one loop but I couldn't figure out how to make
    // the left/right cutouts behave the same as the fwd/back ones
    for (direction=[LEFT, RIGHT]) {
      if (in_list(direction, tabs)) {
        // cut around the tabs to leave a thin filament spring
        attach(TOP, TOP, inside=true, shiftout=eps, align=direction, inset=spring_thickness)
          cuboid([spring_gap, spring_width, spring_height+spring_gap]);
        attach(TOP, TOP, inside=true, shiftout=eps, align=direction, overlap=-spring_height)
          cuboid([spring_thickness+spring_gap, spring_width, spring_gap]);

        attach(direction, BOT, align=TOP) _tab();
      }
    }
    for (direction=[FWD, BACK]) {
      if (in_list(direction, tabs)) {
        // cut around the tabs to leave a thin filament spring
        attach(TOP, TOP, inside=true, shiftout=eps, align=direction, inset=spring_thickness)
          cuboid([spring_width, spring_gap, spring_height+spring_gap]);
        attach(TOP, TOP, inside=true, shiftout=eps, align=direction, overlap=-spring_height)
          cuboid([spring_width, spring_thickness+spring_gap, spring_gap]);

        attach(direction, BOT, align=TOP) _tab();
      }
    }
    down(faceplate_depth) children();
  }
}
