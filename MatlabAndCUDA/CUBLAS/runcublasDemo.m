%runmulMatrixs.m
clc
clear all
close all



disp('1. C/C++ compiling for cublasDemo.cpp...');

% -lcudart ����ʹ����CUDA����ʱ��
% -lcublas ����ʹ����CUDABLAS��
% -L"..." ʹ�õĿ�Ŀ��ļ�·��
% -L"..." ʹ�õĿ��ͷ�ļ�·��
mex cublasDemo.cpp -lcudart -lcublas ...
    -L"C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v5.5\lib\x64" ...
    -v -I"C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v5.5\include"

disp('C/C++ compiling done!');

disp('2.Test cublasDemo()...');

disp('Two input arrays:');

