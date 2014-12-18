clc
clear all
close all

subplot(2,2,1);
surfl(peaks);
shading interp
view(-37.5,30);          %指定子图1的视点
title('azimuth=-37.5,elevation=30')

subplot(2,2,2);
surf(peaks);
view(0,90);            %指定子图2的视点
title('azimuth=0,elevation=90')
subplot(2,2,3);
surf(peaks);
view(90,0);             %指定子图3的视点
title('azimuth=90,elevation=0')
subplot(2,2,4);
surf(peaks);
view(-7,-10);            %指定子图4的视点
title('azimuth=-7,elevation=-10')