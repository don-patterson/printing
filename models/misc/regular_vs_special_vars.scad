regular  = 10;
$special = 10;

module r() {
  cube(regular);  // cannot be overridden
}

module s() {
  cube($special); // can be overridden from a parent scope calling this module
}

color("red") {
  r();
  union() {
    regular = regular + 10;
    translate([30,0,0]) r();
  }
}

color("blue") translate([-50, -50, 0]) {
  s();
  union() {
    $special = $special + 10;
    translate([30,0,0]) s();
  }
}


// TLDR: with $special variables you can override them and have a cascade
// effect with values that should be passed down to the children.
