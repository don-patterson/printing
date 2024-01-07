use <../util.scad>

global_props = [
  // basic exterior dimensions
  ["box.depth", 60],
  ["box.width", 120],
  ["box.front.height", 60],
  ["box.back.height", 72],

  // hinge
  ["hinge.radius", 4.33333],
  ["hinge.length", 120],
  // hinge fin position
  ["hinge.fin.start", 5],
  ["hinge.fin.end", "$hinge.length - $hinge.fin.start"],
  ["hinge.fin.count", 5],
  // hinge fin shape
  ["hinge.fin.length", 40],
  ["hinge.fin.width", 2.31],
  ["hinge.fin.height", "$hinge.radius * 2"],
  ["hinge.fin.taper.angle", 30],
  ["hinge.fin.margin", 0.3],
  // hinge pin
  ["hinge.pin.radius", 2.88888],
  ["hinge.pin.margin", 0.2],
  ["hinge.pin.start", 2],
  ["hinge.pin.end", "$hinge.length - $hinge.pin.start"],

  // lid
  ["lid.angle", "atan ($box.depth / ($box.back.height - $box.front.height))"],
  ["lid.length", "norm $box.depth ($box.back.height - $box.front.height)"],
];

function prop(key) = getprop(key, global_props);
