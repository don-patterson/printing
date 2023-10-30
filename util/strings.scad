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

function split(s, separator, parts=[]) =
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
  assert (num("123") == 123)
  assert (num("2.75") == 2.75)
  assert (num("1234.991230149") == 1234.991230149) // I'm kinda shocked that works
  assert (split("abc,defg,hi", ",") == ["abc", "defg", "hi"])
  assert (split("abc,defg,hi", "#") == ["abc,defg,hi"])
  assert (contains("abcd", "d") == true)
  assert (contains("abcd", "Q") == false)
  "success";

echo(_test());