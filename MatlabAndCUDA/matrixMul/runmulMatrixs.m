%runmulMatrixs.m
clc
clear all
close all

disp('1.nvcc mulMatrixs.cu compiling...');

system('nvcc -c mulMatrixs.cu -ccbin "D:\Visual Studio 2012\VC\bin"')

disp('nvcc compiling done!');

disp('2. C/C++ compiling for mulMatrixsCuda.cpp with AddVectors.obj...');

% -lcudart 表明使用了CUDA运行时库
% -lcublas 表明使用了CUDABLAS库
% -L"..." 使用的库的库文件路径
% -L"..." 使用的库的头文件路径
mex mulMatrixsCuda.cpp mulMatrixs.obj -lcudart -L"C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v5.5\lib\x64"

disp('C/C++ compiling done!');

disp('3.Test mulMatrixsCuda()...');

disp('Two input arrays:');

