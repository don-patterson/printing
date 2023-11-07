use <../util/props.scad>

global_props = [
  ["hinge.radius", 4],
  ["hinge.fin.length", 40],
  ["hinge.fin.width", 3],
  ["hinge.fin.height", "$hinge.radius * 2"],
  ["hinge.fin.count", 5],
  ["hinge.fin.margin", 0.3],
  ["hinge.fin.taper.angle", 30],
  ["hinge.pin.radius", 2],
  ["hinge.pin.margin", 0.2],
];

function prop(key) = getprop(key, global_props);