use <lid.scad>
use <box.scad>
use <arms.scad>

$fn = $preview ? 30 : 128;

difference() {
  box();
  lid(mode="cutout");
}
lid(angle=180); // 180*$t for animation
arms();
