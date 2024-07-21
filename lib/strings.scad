function contains(list, item, i=0) = (i == len(list))
  ? false
  : list[i] == item || contains(list, item, i+1);

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
  assert (contains("abcd", "d") == true)
  assert (contains("abcd", "Q") == false)
  assert (contains([1, 2, 3, 4], 1) == true)
  assert (contains([1, 2, 3, 4], 5) == false)
  assert (contains([["a"], 2, [], ""], []) == true)
  assert (contains([["a"], 2, [], ""], ["a"]) == true)
  assert (contains([["a"], 2, [], ""], ["b"]) == false)
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
