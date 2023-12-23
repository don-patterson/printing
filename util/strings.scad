// strings.scad

function substr(s, start=0, end=-1) =
  let (end = end < 0 ? len(s)+end : end)
  chr([for (i=[start:end]) ord(s[i])]);

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

function is_int_string(s) = all([for(c = s) c=="0" || c=="1" || c=="2" || c=="3" || c=="4" || c=="5" || c=="6" || c=="7" || c=="8" || c=="9"]);

function is_num_string(s) = let (parts = split(s, "."))
  len(parts) == 1
    ? is_int_string(parts[0])
    : len(parts) == 2
      ? is_int_string(parts[0]) && is_int_string(parts[1])
      : false;

function split(s, separator=" ", parts=[]) =
    // breaks on a few edge cases: ",abc,def" and "abc,,def" etc
    // probably because my substr function can't do empty slices
    let (i=search(separator, s, 0)[0])
    i == []
      ? concat(parts, [s])
      : split(substr(s, start=i[0]+1), separator, concat(parts, [substr(s, end=i[0]-1)]));

function contains(string, char, i=0) = (i == len(string))
    ? false
    : string[i] == char || contains(string, char, i+1);

function _test() =
  assert (substr("abcde", start=1) == "bcde")
  assert (substr("abcde", end=2) == "abc")
  assert (substr("abcde", start=2, end=3) == "cd")
  assert (substr("abcde", end=-2) == "abcd")
  assert (substr("abcde", start=3, end=-2) == "d")
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
  assert (split("abc,defg,hi", ",") == ["abc", "defg", "hi"])
  assert (split("abc,defg,hi", "#") == ["abc,defg,hi"])
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
  assert (all([1, true, "a"]) == true)
  assert (all([1, true, "a", ""]) == false)
  assert (any([false, "", 0, []]) == false)
  assert (any([false, "", 0, [], 1]) == true)

  "success";

echo(_test());
