


p0 = [0,0];
p1 = [9, 2];
p2 = [4, 5];

function slice(array, start, stop) = [for (i=[start:stop]) array[i]];
function bezier(points, count=30) = 
    len(points) == 1
      ? [for (i=[0:count-1]) points[0]]
      : let (head=bezier(slice(points, 0, len(points)-2), count=count),
             tail=bezier(slice(points, 1, len(points)-1), count=count))
        [for (i=[0:count-1]) head[i] + (tail[i] - head[i]) * i / (count-1)];
        
        
for (i = bezier([p0, p1], count=10)) translate(i) circle(r=.1, $fn=32);
for (i = bezier([p1, p2], count=10)) translate(i) circle(r=.1, $fn=32);
for (i = bezier([p0, p1, p2])) color("green") translate(i) circle(r=.1, $fn=32);

