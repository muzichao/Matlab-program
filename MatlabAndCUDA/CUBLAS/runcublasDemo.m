%runmulMatrixs.m
clc
clear all
close all



disp('1. C/C++ compiling for cublasDemo.cpp...');

% -lcudart 表明使用了CUDA运行时库
% -lcublas 表明使用了CUDABLAS库
% -L"..." 使用的库的库文件路径
% -L"..." 使用的库的头文件路径
mex cublasDemo.cpp -lcudart -lcublas ...
    -L"C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v5.5\lib\x64" ...
    -v -I"C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v5.5\include"

disp('C/C++ compiling done!');

disp('2.Test cublasDemo()...');

disp('Two input arrays:');

