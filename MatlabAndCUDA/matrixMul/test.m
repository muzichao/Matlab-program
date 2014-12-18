clc
clear all
close all

 M = 1000;
 K = 1000;
 N = 1000;
 
%  A = (1 : M*K);
%  A = single(reshape(A, K, M)');
A = single(rand(M, K));
 
%  B = (1 : K*N);
%  B = zeros (K*N, 1);
%  B(6) = 1;
%  B = single(reshape(B, N, K)');
B = single(rand(K, N));

% A = single(ones(M, K));
% B = single(ones(K, N));

 tic
 C = A * B;
 toc
 
 tic
 D = mulMatrixsCuda(A, B);
 toc
 
 tic
 %E = mulMatrix(A, B, M, K, N);
 toc
 
 F = D - C;
 %G = E - C;
 error_1 = sum(sum(abs(F)))
 %error_2 = sum(sum(abs(G)))
 