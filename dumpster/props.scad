// Global properties
props = [
  ["hinge.fin.length", 40],
  ["hinge.fin.width", 3],
  ["hinge.fin.height", 8],
  ["hinge.fin.count", 5],
  ["hinge.fin.margin", 1],
  ["hinge.fin.taper.angle", 30],
  ["hinge.pin.radius", 3],
  ["hinge.pin.margin", 1],
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

