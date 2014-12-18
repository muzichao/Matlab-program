clc
clear all
close all

N = 2000;
a=single(rand(N));
b=single(rand(N));

tic
c=AddMatrixsCuda(a,b);
toc

tic
d=addMatrix(a, b, N, N);
toc

tic
e = a + b;
toc

error_1 = sum(sum(d-c));
error_2 = sum(sum(e-d));