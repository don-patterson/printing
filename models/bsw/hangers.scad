// License note:
// STLs and similar physical shapes produced from this code are derivative works of Honeycomb Storage Wall by RostaP
// and must be released under the same CC-BY-NC license (or a stricter CC 4.0 version). The `stl` folder in this
// repo has that license file, so any files in and under that directory are shared with the CC-BY-NC license.
include <./bsw.scad>



back(30) socket();


diff()
tag("remove")socket()
  attach(BACK, BACK, inside=true)
    cube([v_plug_width(), 2+$v_socket_wall, v_plug_depth()]);
