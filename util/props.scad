// Zany scheme to have globally shared variables, but somewhat namespaced
// inspired by https://www.reddit.com/r/openscad/comments/15qzwqx/comment/jwoub3h/
//
// Usage: Define your global_props similar to this example, and
// define a "prop" function to use in your modules like:
//   function prop(key) = getprop(key, global_props);

use <./strings.scad>

props_example = [
  ["key1", 1],
  ["key2", 2],
  ["key3", 3],
  ["namespace.value1", 8],
  ["namespace.value2", "$key2"],
  ["othernamespace.value1", "$namespace.value2"],
  ["s", "hello"],
  ["e1", "$key3 / 2"],
  ["e2", "$namespace.value2 + 1.275"],
  ["e3", "$othernamespace.value1 * 6"],
];

function _eval(lhs, op, rhs) =
  op == "/" ? lhs / rhs
  : op == "*" ? lhs * rhs
  : op == "+" ? lhs + rhs
  : op == "-" ? lhs - rhs
  : undef;

function getprop(key, props) =
  let (entry = props[search([key], props)[0]][1])
  assert (entry, str("Missing key in global properties: ", key))
  is_num(entry)
  ? entry
  : contains(entry, " ")
    ? let (
        expr = split(entry, " "),
        lhs = expr[0][0] == "$" ? getprop(substr(expr[0], start=1), props) : num(expr[0]),
        op = expr[1],
        rhs = expr[2][0] == "$" ? getprop(substr(expr[2], start=1), props) : num(expr[2])
      )
      _eval(lhs, op, rhs)
    : entry[0] != "$"
        ? entry
        : getprop(substr(entry, start=1), props);

function _test() =
  assert (getprop("key3", props_example) == 3)
  assert (getprop("namespace.value2", props_example) == 2)
  assert (getprop("e1", props_example) == 1.5)
  assert (getprop("e2", props_example) == 3.275)
  assert (getprop("e3", props_example) == 12)
  assert (getprop("s", props_example) == "hello")
  "success";

echo(_test());