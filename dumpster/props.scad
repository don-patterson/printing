use <../util/strings.scad>

// Global properties
props = [
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

function eval(lhs, op, rhs) =
  op == "/" ? lhs / rhs
  : op == "*" ? lhs * rhs
  : op == "+" ? lhs + rhs
  : op == "-" ? lhs - rhs
  : undef;

function prop(key, props=props) =
  let (entry = props[search([key], props)[0]][1])
  assert (entry, str("Missing key in global properties: ", key))
  is_num(entry)
  ? entry
  : contains(entry, " ")
    ? let (
        expr = split(entry, " "),
        lhs = expr[0][0] == "$" ? prop(substr(expr[0], start=1)) : num(expr[0]),
        op = expr[1],
        rhs = expr[2][0] == "$" ? prop(substr(expr[2], start=1)) : num(expr[2])
      )
      eval(lhs, op, rhs)
    : entry[0] != "$"
        ? entry
        : prop(substr(entry, start=1), props=props);
