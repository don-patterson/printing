// Zany scheme to have globally shared variables, but somewhat namespaced
// inspired by https://www.reddit.com/r/openscad/comments/15qzwqx/comment/jwoub3h/
//
// Copy this file into your project directory and define all of the global variables
// here. Other files can then `use` this to have access to shared variables without
// having to worry about naming collisions and defaults everywhere, etc.

use <../util/strings.scad>

props = [
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

function _test() =
  assert (prop("key3") == 3)
  assert (prop("namespace.value2") == 2)
  assert (prop("e1") == 1.5)
  assert (prop("e2") == 3.275)
  assert (prop("e3") == 12)
  assert (prop("s") == "hello")
  "success";

echo(_test());