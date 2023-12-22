use <../util/props.scad>

global_props = [
  ["hinge.radius", 4],
  ["hinge.length", 60],

  // fin position
  ["hinge.fin.start", 5],
  ["hinge.fin.end", "$hinge.length - $hinge.fin.start"],
  ["hinge.fin.count", 5],

  // fin shape
  ["hinge.fin.length", 40],
  ["hinge.fin.width", 3],
  ["hinge.fin.height", "$hinge.radius * 2"],
  ["hinge.fin.taper.angle", 30],

  // fin space
  ["hinge.fin.margin", 0.3],

  // pin
  ["hinge.pin.radius", 2],
  ["hinge.pin.margin", 0.2],
  ["hinge.pin.start", 2],
  ["hinge.pin.end", "$hinge.length - $hinge.pin.start"],

];

function prop(key) = getprop(key, global_props);
