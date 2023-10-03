// Zany scheme to have globally shared variables, but somewhat namespaced
// inspired by https://www.reddit.com/r/openscad/comments/15qzwqx/comment/jwoub3h/
//
// Copy this file into your project directory and define all of the global variables
// here. Other files can then `use` this to have access to shared variables without
// having to worry about naming collisions and defaults everywhere, etc.


props = [
  ["key1", "value1"],
  ["key2", "value2"],
  ["key3", "value3"],
  ["namespace.value1", 8],
  ["namespace.value2", "&key2"],
  ["othernamespace.value1", "&namespace.value2"],
];

// ridiculous, but this is all I can think of to do a substring
function substr(s, start=0, end=-1) =
  let (end = end < 0 ? len(s)+end : end)
  chr([for (i=[start:end]) ord(s[i])]);

// get the value from the list, following "&key" references
function prop(key, props=props) =
  let (value = props[search([key], props)[0]][1],
       result = (is_string(value) && len(value) > 0 && value[0] == "&")
          ? prop(substr(value, 1), props)
          : value)
  assert(result != undef, str("Missing key in global properties: ", key))
  result;

