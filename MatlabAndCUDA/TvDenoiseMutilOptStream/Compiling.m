%runmulMatrixs.m
clc
clear all
close all

disp('1.nvcc TvDenoise.cu compiling...');

system('nvcc -c TvDenoise.cu -arch=compute_30 -code=sm_30 -ccbin "D:\Visual Studio 2012\VC\bin"')

disp('nvcc compiling done!');

disp('2. C/C++ compiling for TvDenoiseMutilCuda.cpp with AddVectors.obj...');

% -lcudart ����ʹ����CUDA����ʱ��
% -lcublas ����ʹ����CUDABLAS��
% -L"..." ʹ�õĿ�Ŀ��ļ�·��
% -L"..." ʹ�õĿ��ͷ�ļ�·��
mex TvDenoiseMutilCuda.cpp TvDenoise.obj -lcudart -L"C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v6.0\lib\x64"

disp('C/C++ compiling done!');

disp('3.Test TvDenoiseMutilCuda()...');


