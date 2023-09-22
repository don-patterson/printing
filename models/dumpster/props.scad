use <../../lib/util.scad>

$fn = $preview ? 30 : 128;

global_props = [
  // basic exterior dimensions
  ["box.depth", 60],
  ["box.width", 120],
  ["box.front.height", 60],
  ["box.back.height", 76],
  ["panel.thickness", 2],

  // lid/hinge
  ["lid.angle", "atan (($box.back.height - $box.front.height) / $box.depth)"],
  ["lid.length", "norm $box.depth ($box.back.height - $box.front.height)"],
  ["lid.cutout.radius", "$hinge.radius + $panel.thickness"],
  ["hinge.radius", 4],
  ["hinge.length", "$box.width"],
  // hinge fin position
  ["hinge.fin.start", "$panel.thickness + 0.2"],
  ["hinge.fin.end", "$hinge.length - $hinge.fin.start"],
  ["hinge.fin.count", 5],
  // hinge fin shape
  ["hinge.fin.length", "$lid.length - $panel.thickness"],
  ["hinge.fin.width", 2.31],
  ["hinge.fin.height", "$hinge.radius * 2"],
  ["hinge.fin.taper.angle", 40],
  ["hinge.fin.margin", 0.2],
  // hinge pin
  ["hinge.pin.radius", 2],
  ["hinge.pin.margin", 0.2],
  ["hinge.pin.start", "$panel.thickness / 2"],
  ["hinge.pin.end", "$hinge.length - $hinge.pin.start"],
];

function prop(key) = getprop(key, global_props);
