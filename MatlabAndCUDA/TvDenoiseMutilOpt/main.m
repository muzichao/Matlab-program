clc
clear all
close all

addpath('.\codes\')
%% 参数
piter = 4;
th = 0.1;

iRow = 512;
iCol = 512;
band = 32;
%% 产生数据
x = fix(abs(rand(iRow, iCol, band)) * 100);
% x = zeros(uy, ux);
% for i = 1:uy
%     for j = 1:ux
%         x(i, j) = rem(i * j, 255);
%     end
% end
%% 原始Tvdenoise

tic

dh   = @(x) conv2c(x,[1 -1 0]);
dv   = @(x) conv2c(x,[1 -1 0]');
dht  = @(x) conv2c(x,[0 -1 1]);
dvt  = @(x) conv2c(x,[0 -1 1]');
vect = @(x) x(:);
opQ  = @(x) [vect(dh(x)) vect(dv(x))] ;
opQt = @(x) dht(reshape(x(:,1), iRow, iCol)) + dvt(reshape(x(:, 2), iRow, iCol));

img_x = zeros(size(x));
for i = 1:band
    img_x(:,:,i) = x(:,:,i) - projk(x(:,:,i), th/2, opQ, opQt, piter);
end

toc

%% 优化过的Tvdenoise

% tic
%
% img_xOpt = x - projkOpt(x, th/2, piter);
%
% toc

%% 优化过的Tvdenoise

% tic
%
% img_xOpt3 = x - projkOpt3(x, th/2, piter);
%
% toc

%% 优化过的TvdenoiseMutilCUDA

tic

xMutilCUDA = reshape(x, iRow, iCol * band);
xMutilCUDA = double(TvDenoiseMutilCuda(single(xMutilCUDA), single(band), single(th/2), single(piter)));
img_xMutilCUDA = reshape(xMutilCUDA, iRow, iCol, band);

toc

%% 优化过的TvdenoiseCUDA 

tic
img_xCUDA = zeros(size(x));
for i = 1:band
   img_xCUDA(:,:,i) =  double(TvDenoiseCuda(single(x(:,:,i)), single(th/2), single(piter)));
end
toc


%% 误差分析
% err = img_xOpt - img_x;
% error = sum(sum(abs(err)))
%
% err3 = img_xOpt3 - img_x;
% error3 = sum(sum(abs(err3)))

errMutilCUDA = img_xMutilCUDA - img_x;
errorMutilCUDA = sum(abs(errMutilCUDA(:)))/ (iRow * iCol * band)

errCUDA = img_xCUDA - img_x;
errorCUDA = sum(abs(errCUDA(:)))/ (iRow * iCol * band)

