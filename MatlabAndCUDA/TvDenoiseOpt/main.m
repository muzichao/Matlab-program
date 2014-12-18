clc
clear all
close all

addpath('.\codes\')
%% 参数
piter = 100;
th = 0.1;

uy = 256;
ux = 256;

%% 产生数据
x = fix(abs(rand(uy, ux)) * 100);
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
opQt = @(x) dht(reshape(x(:,1), uy, ux)) + dvt(reshape(x(:, 2), uy, ux));

img_x = x - projk(x, th/2, opQ, opQt, piter);

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

%% 优化过的Tvdenoise

tic

img_xCUDA = double(TvDenoiseCuda(single(x), single(th/2), single(piter)));

toc
%% 误差分析
% err = img_xOpt - img_x;
% error = sum(sum(abs(err)))
% 
% err3 = img_xOpt3 - img_x;
% error3 = sum(sum(abs(err3)))

errCUDA = img_xCUDA - img_x;
errorCUDA = sum(sum(abs(errCUDA))) / (uy * ux)
