clc
clear all
close all

[X,Y] = meshgrid(-8:.5:8);
R = sqrt(X.^2 + Y.^2) + eps;
Z = sin(R)./R;
subplot(1,2,1)
mesh(X,Y,Z/(max(Z(:)*1e6)));
zlim([-0.01,0.01]);

subplot(1,2,2)
surf(X,Y,Z)