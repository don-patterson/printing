$fa = $preview ? 1 : .1;
$fs = $preview ? 1 : .1;


inner_depth = 10;
inner_r = 3.65;
// 3.75 fit tight on the PLA prototype print I did
// and maybe a bit loose on the weird "easy" PETG
outer_depth = 10;
outer_r = 3;
handle_depth = 7;
handle_r = 18;

// main points that define a radial slice
pts = [
    [0, inner_depth],
    [inner_r, inner_depth],
    [inner_r, 0.5],
    [inner_r + outer_r, 0],
    [inner_r + outer_r, outer_depth-3],
    [handle_r, outer_depth],
    [handle_r, outer_depth+handle_depth],
    [0, outer_depth+handle_depth]
];

rotate([180,0,0])
  rotate_extrude()
    polygon(pts);