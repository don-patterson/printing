// This file explores how special variables behave if/when they get reassigned within a scope.
// Note that one could make functions backed by special variables to form computed values
// that stay up to date when you assign to a special variable. You could probably do getters
// and setters if you really wanted to go crazy and not expose the names of the special vars.

$fa=.1;
$fs=.1;

// special var
$cube_side = 4;

// computed value
$sphere_d = $cube_side / 2;

// computed function
function f_sphere_d() = $cube_side / 2;


module basic_cube(side=$cube_side) {
  cube([side, 2*side, side]);
}

module basic_sphere(d=$sphere_d) {
  sphere(r = d/2);
}

module basic_sphere_func(d=f_sphere_d()) {
  sphere(r = d/2);
}



module test_1_override() {
  // override the special var
  $cube_side = 8;
  basic_cube();

  // $sphere_d does not get recomputed
  basic_sphere();
}

module test_2_func() {
  // override the special var
  $cube_side = 8;
  basic_cube();

  // f_sphere_d() gets the updated value!
  basic_sphere_func();
}

module test_3_arg() {
  // just set the value in basic_cube
  basic_cube(8);
  // couldn't expect this to be anything but the default, but had to try
  basic_sphere_func();
}

module test_4_env_arg($cube_side=$cube_side) {
  // special var is set by argument
  basic_cube();
  basic_sphere_func();
}

module test_5_env_alias(s=$cube_side) {
  // default to the special var, but reassign here in case you get a value passed in
  $cube_side = s;
  basic_cube();
  basic_sphere_func();
}


translate([0, -20, 0]) {
  // original unscaled
  basic_cube();
  basic_sphere();
}

translate([0,0,0]) color("red") {
  test_1_override();
}

translate([10,0,0]) color("blue") {
  test_2_func();
}

translate([20,0,0]) color("green") {
  test_3_arg();
}

translate([30,0,0]) color("orange") {
  test_4_env_arg(8);
}

translate([40,0,0]) color("purple") {
  test_5_env_alias(s=8);
}
