use <lid.scad>
use <bin.scad>
use <arms.scad>
$fa = $preview ? 1 : .1;
$fs = $preview ? 1 : .1;

bin();
arms();
