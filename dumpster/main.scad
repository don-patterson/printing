use <lid.scad>
use <box.scad>

$fn = $preview ? 30 : 128;

difference() {
  box();
  lid(mode="cutout");
}
lid(angle=180);
