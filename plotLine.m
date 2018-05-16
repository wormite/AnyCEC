function plotLine(point1,point2,arg)
if ~exist('arg', 'var')
    arg = '-b';
end
  plot([point1(1),point2(1)],[point1(2),point2(2)],arg);
end
