%2013 11 6
%3ά������2ά�ռ��ͶӰ
%�Ƴɶ���

clc
clear all
close all

k = 6;
n = 2^k-1;
[x,y,z] = sphere(n);
c = hadamard(2^k);
surf(x,y,z,c);
%colormap([1 0 0; 1 0 0])
axis equal



x1=x-2;
y1=y-2;
z2=z;

hold on
surf(x1,y1,z,c)
colormap([1 0 0; 1 0 0])
axis equal
hold on

for i=0:1:360
    view(i,0)
%     axis off
    axis equal
    drawnow;
end

for i=0:1:37
    view(0,i)
%     axis off
    axis equal
    drawnow;
end