include <./base.scad>

width=prop("socket.width");
cols=10;
rows=10;
for (i=[0:cols-1]) {
  for (j=[0:rows-1]) {
    right(i*width) back(j*width) socket();
  }
}
