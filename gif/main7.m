clc
clear all
close all

t=0:pi/20:2*pi;
subplot(1,2,1);
[x,y,z]=cylinder(sin(t),30);
surf(x,y,z);
rotate3d
