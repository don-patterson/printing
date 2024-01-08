use <lid.scad>
use <box.scad>

$fn = $preview ? 30 : 128;

box();
%lid();
#lid(mode="cutout");
// TODO there's a small issue where the fully opened lid would hit the
// back panel, so I might have to carve out a section or play with
// the other sizes so that the lid can open 180 degrees (for its print position)
