#!/usr/bin/env bash

[ $2 -gt 0 ] && [ $1 -ge $2 ] || { echo >&2 "usage: $0 COLS ROWS   (where COLS >= ROWS > 0)"; exit 1; }

stl=./stl/panels/$(printf '%02d' $1)x$(printf '%02d' $2).stl
[ -e "$stl" ] && { echo >&2 "$stl is already rendered"; exit; }

openscad-nightly --backend=Manifold -o "$stl" -D cols=$1 -D rows=$2 - <<EOF
  include <./bsw.scad>
  width=\$v_socket_width;
  cols = 1;
  rows = 1;

  for (i=[0:cols-1]) {
    for (j=[0:rows-1]) {
      right(i*width) back(j*width) socket();
    }
  }
EOF

