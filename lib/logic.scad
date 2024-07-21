use <./strings.scad>

function int(s, total=0, i=0) = (i == len(s))
  ? total
  : int(s, total*10 + ord(s[i]) - ord("0"), i+1);

function frac(s) = int(s) / pow(10, len(s));

function num(s) =
  let (parts = split(s, "."))
  len(parts) == 1
  ? int(parts[0])
  : int(parts[0]) + frac(parts[1]);

function any(list, i=0) = (i == len(list))
  ? false
  : list[i] || any(list, i+1);

function all(list, i=0) = (i == len(list))
  ? true
  : list[i] && all(list, i+1);

function is_int_string(s) = all([for(c=s) "0" <= c && c <= "9"]);

function is_num_string(s) =
  let (parts = split(s, "."))
  len(parts) == 1
  ? is_int_string(parts[0])
  : len(parts) == 2
    ? is_int_string(parts[0]) && is_int_string(parts[1])
    : false;

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
  assert (any([false, "", 0, []]) == false)
  assert (any([false, "", 0, [], 1]) == true)
  assert (any([]) == false)
  assert (all([1, true, "a"]) == true)
  assert (all([1, true, "a", ""]) == false)
  assert (all([]) == true)
  assert (is_int_string("1234") == true)
  assert (is_int_string("093999914") == true)
  assert (is_int_string("123A") == false)
  assert (is_int_string("two") == false)
  assert (is_int_string("2.6") == false)
  assert (is_num_string("2.6") == true)
  assert (is_num_string("1241422.5522106") == true)
  assert (is_num_string("124142205522106") == true)
  assert (is_num_string("1241422,5522106") == false)
  assert (is_num_string("1241422.552.106") == false)
  assert (is_num_string("1241422Q") == false)
  "test logic success";

echo(_test_logic());
