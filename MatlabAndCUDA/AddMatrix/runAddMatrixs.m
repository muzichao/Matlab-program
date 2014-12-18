%runAddMatrixs.m
clc
clear all
close all

disp('1.nvcc AddMatrixs.cu compiling...');

system('nvcc -c AddMatrixs.cu -ccbin "D:\Visual Studio 2012\VC\bin"')

disp('nvcc compiling done!');

disp('2. C/C++ compiling for AddMatrixsCuda.cpp with AddVectors.obj...');

mex AddMatrixsCuda.cpp AddMatrixs.obj -lcudart -L"C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v5.5\lib\x64"

disp('C/C++ compiling done!');

disp('3.Test AddMatrixsCuda()...');

disp('Two input arrays:');

A = single([1 2 3; 4 5 6; 7 8 9]);
B = single([9 8 7; 6 5 4; 3 2 1]);
C = AddMatrixsCuda(A,B);