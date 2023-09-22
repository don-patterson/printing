// Here are a bunch of utilities, mostly to support the global prop function.


// numbers and logic
function int(s, total=0, i=0) = (i == len(s))
  ? total
  : int(s, total*10 + ord(s[i]) - ord("0"), i+1);

function frac(s) = int(s) / pow(10, len(s));

function num(s) =
  let (parts = split(s, "."))
  len(parts) == 1
  ? int(parts[0])
  : int(parts[0]) + frac(parts[1]);

function contains(list, item, i=0) = (i == len(list))
  ? false
  : list[i] == item || contains(list, item, i+1);

function any(list, i=0) = (i == len(list))
  ? false
  : list[i] || any(list, i+1);

function all(list, i=0) = (i == len(list))
  ? true
  : list[i] && all(list, i+1);

function _test_logic() =
  assert (int("123") == 123)
  assert (int("9999") == 9999)
  assert (frac("5") == 0.5)
  assert (frac("33333") == 0.33333)
  assert (frac("111111") == 0.111111)
  assert (frac("02") == 0.02)
  assert (frac("020000") == 0.02)
  assert (frac("0") == 0)
  assert (frac("0000000000000") == 0)
  assert (frac("0000000000001") == 0.0000000000001)
  assert (num("123") == 123)
  assert (num("2.75") == 2.75)
  assert (num("1234.991230149") == 1234.991230149) // I'm kinda shocked that works
  assert (contains("abcd", "d") == true)
  assert (contains("abcd", "Q") == false)
  assert (contains([1, 2, 3, 4], 1) == true)
  assert (contains([1, 2, 3, 4], 5) == false)
  assert (contains([["a"], 2, [], ""], []) == true)
  assert (contains([["a"], 2, [], ""], ["a"]) == true)
  assert (contains([["a"], 2, [], ""], ["b"]) == false)
  assert (all([1, true, "a"]) == true)
  assert (all([1, true, "a", ""]) == false)
  assert (all([]) == true)
  assert (any([false, "", 0, []]) == false)
  assert (any([false, "", 0, [], 1]) == true)
  assert (any([]) == false)
  "test logic success";

echo(_test_logic());


// strings
function is_int_string(s) = all([for(c=s) "0" <= c && c <= "9"]);

function is_num_string(s) =
  let (parts = split(s, "."))
  len(parts) == 1
  ? is_int_string(parts[0])
  : len(parts) == 2
    ? is_int_string(parts[0]) && is_int_string(parts[1])
    : false;

function strcat(char_array, i=0, r="") = (i == len(char_array))
  ? r
  : strcat(char_array, i+1, str(r, char_array[i]));

function substr(s, start=0, limit=undef) =
  // return str[i] where start <= i < limit
  let (end = limit == undef ? len(s)-1 : min(limit-1, len(s)-1))
  end < start
  ? ""
  : strcat([for (i=[start:end]) s[i]]);

function replace_substr(s, repl, start=0, limit=undef) =
  // remove a substring and replace it with another string
  let (end = limit == undef ? len(s)-1 : limit-1)
  str(substr(s, limit=start), repl, substr(s, start=end+1));

function split(s, separator=" ", parts=[]) =
  let (match=search(separator, s, 0)[0])
  match == []
  ? concat(parts, [s])
  : split(substr(s, start=match[0]+1), separator, concat(parts, [substr(s, limit=match[0])]));

function first(string, char, after=-1) =
  let (result = search(char, substr(string, start=after+1), 1))
  result == []
  ? undef
  : result[0] + after+1;

function last(string, char) =
  let (result=search(char, string, 0))
  result == []
  ? undef
  : result[0][len(result[0])-1];

function _test_strings() =
  assert (strcat([]) == "")
  assert (strcat(["a"]) == "a")
  assert (strcat(["a", "b"]) == "ab")
  assert (strcat(["a", "", "b"]) == "ab")
  assert (substr("abcde") == "abcde")
  assert (substr("abcde", start=0) == "abcde")
  assert (substr("abcde", start=1) == "bcde")
  assert (substr("abcde", limit=3) == "abc")
  assert (substr("abcde", start=2, limit=4) == "cd")
  assert (substr("abcde", start=99) == "")
  assert (replace_substr("abcde", "CD", start=2, limit=4) == "abCDe")
  assert (replace_substr("abcde", "CD", start=2, limit=5) == "abCD")
  assert (replace_substr("abcde", "CD", start=2, limit=999) == "abCD")
  assert (replace_substr("abcde", "CD", start=2) == "abCD")
  assert (replace_substr("abcde", "AAA", start=0) == "AAA")
  assert (replace_substr("abcde", "AAA") == "AAA")
  assert (replace_substr("abcde", "III", limit=0) == "IIIabcde")
  assert (replace_substr("abcde", "III", start=3, limit=3) == "abcIIIde")
  assert (replace_substr("abcde", "III", start=5) == "abcdeIII")
  assert (replace_substr("abcde", "III", start=999) == "abcdeIII")
  assert (split("abc,defg,hi", ",") == ["abc", "defg", "hi"])
  assert (split("abc,defg,hi", "#") == ["abc,defg,hi"])
  assert (split(",,ab,c,,d,efg", ",") == ["", "", "ab", "c", "", "d", "efg"])
  assert (split("a b  cd ") == ["a", "b", "", "cd", ""])
  assert (split("abcd") == ["abcd"])
  assert (is_int_string("1234") == true)
  assert (is_int_string("093999914") == true)
  assert (is_int_string("123A") == false)
  assert (is_int_string("two") == false)
  assert (is_num_string("2.6") == true)
  assert (is_num_string("1241422.5522106") == true)
  assert (is_num_string("124142205522106") == true)
  assert (is_num_string("1241422,5522106") == false)
  assert (is_num_string("1241422Q") == false)
  assert (first("aaaaa", "a") == 0)
  assert (first("00aaa", "a") == 2)
  assert (first("0000a", "a") == 4)
  assert (first("0000a", "Z") == undef)
  assert (first("aaaaa", "a", after=2) == 3)
  assert (first("aaa00", "a", after=2) == undef)
  assert (first("a000a", "a", after=0) == 4)
  assert (first("a000a", "a", after=99) == undef)
  assert (last("aaaaa", "a") == 4)
  assert (last("aaa00", "a") == 2)
  assert (last("a0000", "a") == 0)
  assert (last("a0000", "Z") == undef)
  "test strings success";

echo(_test_strings());


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

// geometry

function bezier(points, count=30) =
  // Generate points along the bezier curve for a given list of control points
  len(points) == 1
  ? [for (i=[0:count-1]) points[0]]
  : let (head=bezier([for (i=[0:len(points)-2]) points[i]], count),
         tail=bezier([for (i=[1:len(points)-1]) points[i]], count))
    [for (i=[0:count-1]) head[i] + (tail[i] - head[i]) * i / (count-1)];

/*// Demo
p0 = [0, 0];
p1 = [6, 1];
p2 = [5, 5];
p3 = [2, 4];
for (i = bezier([p0, p1], count=10)) translate(i) circle(r=.1, $fn=32);
for (i = bezier([p1, p2], count=10)) translate(i) circle(r=.1, $fn=32);
for (i = bezier([p2, p3], count=10)) translate(i) circle(r=.1, $fn=32);
for (i = bezier([p0, p1, p2, p3])) color("green") translate(i) circle(r=.1, $fn=32);
//*/

module r_extrude(x=undef, y=undef) {
  // rotation extrude, without the weird z axis flip up thing
  if (x == undef)
    rotate([-90,0,180])
      rotate_extrude(angle=y)
        rotate([0,0,180])
          children();
  else
    rotate([-90,0,-90])
      rotate_extrude(angle=x)
        rotate([0,0,90])
          children();
}
