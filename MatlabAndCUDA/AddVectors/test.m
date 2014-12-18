clc
clear all
close all

N = 10240000;
a=single(rand(N,1));
b=single(rand(N,1));

tic
c=AddVectorsCuda(a,b);
toc

tic
d=addVector(a, b, N);
toc

tic
e = a + b;
toc

error_1 = sum(d-c);
error_2 = sum(e-d);

mata = single(rand(1000));
matb = single(rand(1000));

tic
matc = mata * matb;
toc