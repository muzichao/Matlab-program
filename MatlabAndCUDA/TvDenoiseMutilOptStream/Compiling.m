%runmulMatrixs.m
clc
clear all
close all

disp('1.nvcc TvDenoise.cu compiling...');

system('nvcc -c TvDenoise.cu -arch=compute_30 -code=sm_30 -ccbin "D:\Visual Studio 2012\VC\bin"')

disp('nvcc compiling done!');

disp('2. C/C++ compiling for TvDenoiseMutilCuda.cpp with AddVectors.obj...');

% -lcudart 表明使用了CUDA运行时库
% -lcublas 表明使用了CUDABLAS库
% -L"..." 使用的库的库文件路径
% -L"..." 使用的库的头文件路径
mex TvDenoiseMutilCuda.cpp TvDenoise.obj -lcudart -L"C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v6.0\lib\x64"

disp('C/C++ compiling done!');

disp('3.Test TvDenoiseMutilCuda()...');


