use <./logic.scad>
use <./strings.scad>

// Global prop function.
// The idea here is to define a function like:
//   function prop(key) = getprop(key, global_props);
// and then use that to share variables throughout your multi-file design.
// A bunch of expressions are available within the props dictionary, like
// references to other props, and various computations. Whitespace
// is strict in the expressions.
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
  ["p1", "$key3 * ($key2 + $key1)"],
  ["p2", "(1 + 2) * (2 ^ 3)"],
  ["p3", "((1 + $e5) + 1) + (cos $key4)"],
];

function eval_literal(args) =
  // compute things like `2 + 4` or `cos 45`
  len(args) == 0 ? undef :
  args[0] == "norm" ? norm([for(i=[1:len(args)-1]) args[i]]) :
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
      : args[0] == "sqrt" ? sqrt(args[1])
      : undef
    : len(args) == 1
      ? args[0]
      : undef;

function eval_raw(expression, props) =
  // resolve types and props in expressions, like "(cos $thing) * ($other / 3)"
  // note that whitespace is not ignored
  !is_string(expression)
  ? expression
  : !contains(expression, "(")
    ? // simple expression like "$thing + 5"
      eval_literal([
        for (arg=split(expression))
          arg[0] == "$"
          ? getprop(substr(arg, start=1), props)
          : is_num_string(arg)
            ? num(arg)
            : arg
      ])
    : // resolve the innermost parens and start again
      let (inner_start = last(expression, "("),
           inner_end = first(expression, ")", after=inner_start),
           inner = eval_raw(substr(expression, inner_start+1, inner_end), props))
      eval_raw(replace_substr(expression, inner, inner_start, inner_end+1), props);

function getprop(key, props) =
  let (prop = props[search([key], props)[0]][1])
  assert (prop, str("Missing key in properties: ", key))
  eval_raw(prop, props);

function _test_props() =
  assert (getprop("key3", props_example) == 3)
  assert (getprop("namespace.value2", props_example) == 2)
  assert (getprop("e1", props_example) == 1.5)
  assert (getprop("e2", props_example) == 3.275)
  assert (getprop("e3", props_example) == 12)
  assert (getprop("e4", props_example) == 64)
  assert (getprop("e5", props_example) == 1)
  assert (getprop("e6", props_example) == 0.5)
  assert (getprop("p1", props_example) == 9)
  assert (getprop("p2", props_example) == 24)
  assert (getprop("p3", props_example) == 3.5)
  assert (getprop("s", props_example) == "hello")
  "test props success";

echo(_test_props());
