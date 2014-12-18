clc
clear all
close all

M = 200;
K = 300;
N = 400;

A = single(rand(M, K));
B = single(rand(K, N));

tic
C = A * B;
toc

tic
D = cublasDemo(A, B);
toc