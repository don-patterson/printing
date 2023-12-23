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
  ["key4", "$key3 * 20"],
  ["namespace.value1", 8],
  ["namespace.value2", "$key2"],
  ["othernamespace.value1", "$namespace.value2"],
  ["s", "hello"],
  ["e1", "$key3 / 2"],
  ["e2", "$namespace.value2 + 1.275"],
  ["e3", "$othernamespace.value1 * 6"],
  ["e4", "$key2 ^ 6"],
  ["e5", "$key3 % 2"],
  ["e6", "cos $key4"],
];

function _eval(args) =
  len(args) == 3
  ? args[1] == "/" ? args[0] / args[2]
    : args[1] == "*" ? args[0] * args[2]
    : args[1] == "+" ? args[0] + args[2]
    : args[1] == "-" ? args[0] - args[2]
    : args[1] == "^" ? args[0] ^ args[2]
    : args[1] == "%" ? args[0] % args[2]
    : undef
  : len(args) == 2
    ? args[0] == "sin" ? sin(args[1])
      : args[0] == "cos" ? cos(args[1])
      : args[0] == "tan" ? tan(args[1])
      : args[0] == "asin" ? asin(args[1])
      : args[0] == "acos" ? acos(args[1])
      : args[0] == "atan" ? atan(args[1])
      : undef
    : undef;

function _resolve(items, props) = [for (i = items)
    is_string(i) && len(i) > 0
    ? i[0] == "$"
      ? getprop(substr(i, start=1), props)
      : is_num_string(i)
        ? num(i)
        : i
    : i
];

function getprop(key, props) =
  let (entry = props[search([key], props)[0]][1])
  assert (entry, str("Missing key in global properties: ", key))
  is_num(entry)
  ? entry
  : contains(entry, " ")
    ? _eval(_resolve(split(entry), props_example))
    : _resolve([entry], props_example)[0];

function _test() =
  assert (getprop("key3", props_example) == 3)
  assert (getprop("namespace.value2", props_example) == 2)
  assert (getprop("e1", props_example) == 1.5)
  assert (getprop("e2", props_example) == 3.275)
  assert (getprop("e3", props_example) == 12)
  assert (getprop("e4", props_example) == 64)
  assert (getprop("e5", props_example) == 1)
  assert (getprop("e6", props_example) == 0.5)
  assert (getprop("s", props_example) == "hello")
  "success";

echo(_test());
