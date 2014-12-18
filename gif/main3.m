clc
clear all
close all

subplot(2,2,1);
surfl(peaks);
shading interp
view(-37.5,30);          %ָ����ͼ1���ӵ�
title('azimuth=-37.5,elevation=30')

subplot(2,2,2);
surf(peaks);
view(0,90);            %ָ����ͼ2���ӵ�
title('azimuth=0,elevation=90')
subplot(2,2,3);
surf(peaks);
view(90,0);             %ָ����ͼ3���ӵ�
title('azimuth=90,elevation=0')
subplot(2,2,4);
surf(peaks);
view(-7,-10);            %ָ����ͼ4���ӵ�
title('azimuth=-7,elevation=-10')