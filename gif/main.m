%2013 11 6
%3ά������2ά�ռ��ͶӰ
%�Ƴɶ���

clc
clear all
close all

syms x y z1 z2
z1=sqrt(2-(x-2)^2-(y-2)^2);
ezsurf(z1,[0,10])

hold on 
z2=sqrt(2-(x-4)^2-(y-4)^2);
ezsurf(z2,[0,10])