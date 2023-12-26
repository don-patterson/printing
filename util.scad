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

function any(items) = max([for (i = items) i ? 1 : 0]) == 1;

function all(items) = min([for (i = items) i ? 1 : 0]) == 1;

function _test_numbers() =
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
  assert (all([1, true, "a"]) == true)
  assert (all([1, true, "a", ""]) == false)
  assert (any([false, "", 0, []]) == false)
  assert (any([false, "", 0, [], 1]) == true)
  "test numbers success";

echo(_test_numbers());


// strings
function is_int_string(s) = all([for(c = s) c=="0" || c=="1" || c=="2" || c=="3" || c=="4" || c=="5" || c=="6" || c=="7" || c=="8" || c=="9"]);

function is_num_string(s) = let (parts = split(s, "."))
  len(parts) == 1
    ? is_int_string(parts[0])
    : len(parts) == 2
      ? is_int_string(parts[0]) && is_int_string(parts[1])
      : false;

function substr(s, start=0, limit=undef) =
  // return str[i] where start <= i < limit
  let (end = limit == undef ? len(s)-1 : limit-1)
  end < start
  ? ""
  : chr([for (i=[start:end]) ord(s[i])]);

function split(s, separator=" ", parts=[]) =
    // breaks on a few edge cases: ",abc,def" and "abc,,def" etc
    // probably because my substr function can't do empty slices
    let (i=search(separator, s, 0)[0])
    i == []
      ? concat(parts, [s])
      : split(substr(s, start=i[0]+1), separator, concat(parts, [substr(s, limit=i[0])]));

function contains(string, char, i=0) = (i == len(string))
    ? false
    : string[i] == char || contains(string, char, i+1);

function _test_strings() =
  assert (substr("abcde", start=1) == "bcde")
  assert (substr("abcde", limit=3) == "abc")
  assert (substr("abcde", start=2, limit=4) == "cd")
  assert (split("abc,defg,hi", ",") == ["abc", "defg", "hi"])
  assert (split("abc,defg,hi", "#") == ["abc,defg,hi"])
  assert (split(",,ab,c,,d,efg", ",") == ["", "", "ab", "c", "", "d", "efg"])
  assert (split("abcd") == ["abcd"])
  assert (contains("abcd", "d") == true)
  assert (contains("abcd", "Q") == false)
  assert (is_int_string("1234") == true)
  assert (is_int_string("093999914") == true)
  assert (is_int_string("123A") == false)
  assert (is_int_string("two") == false)
  assert (is_num_string("2.6") == true)
  assert (is_num_string("1241422.5522106") == true)
  assert (is_num_string("124142205522106") == true)
  assert (is_num_string("1241422,5522106") == false)
  assert (is_num_string("1241422Q") == false)
  "test strings success";

echo(_test_strings());


// global prop function
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
    ? _eval(_resolve(split(entry), props))
    : _resolve([entry], props_example)[0];

function _test_props() =
  assert (getprop("key3", props_example) == 3)
  assert (getprop("namespace.value2", props_example) == 2)
  assert (getprop("e1", props_example) == 1.5)
  assert (getprop("e2", props_example) == 3.275)
  assert (getprop("e3", props_example) == 12)
  assert (getprop("e4", props_example) == 64)
  assert (getprop("e5", props_example) == 1)
  assert (getprop("e6", props_example) == 0.5)
  assert (getprop("s", props_example) == "hello")
  "test props success";

echo(_test_props());

// bezier

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
