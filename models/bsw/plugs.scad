include <./bsw.scad>

module hsw_plug(r=prop("hsw.insert.width")) {
  plug_block(horizontal_tabs=false)
    attach(TOP, TOP, inside=true, shiftout=0.01)
      regular_prism(6, id=r, h=prop("full.depth"));
}

module hollow_plug(width=prop("insert.width")) {
  plug_block()
    attach(TOP, TOP, inside=true, shiftout=0.01)
      cuboid([width,width,prop("full.depth")]);
}

// hollow_plug();
// right(25) hsw_plug();
