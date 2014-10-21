clc
clear all
close all

[x y z v] = flow;
[fc vt] = isosurface(x, y, z, v, -3);%vt就是曲面点集
p=patch('Faces',fc,'Vertices',vt);
       isonormals(x,y,z,v, p)
       set(p, 'FaceColor', 'red', 'EdgeColor', 'none');
       daspect([1 1 1])
       view(3)
       camlight; lighting phong
figure
plot3(vt(:,1),vt(:,2),vt(:,3),'.')