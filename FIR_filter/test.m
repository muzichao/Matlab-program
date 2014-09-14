clc
clear all
close all

wp_l=0.4*pi;  
ws_l=0.6*pi;    
N1=26;  %初始化参数
f_l=[0 wp_l ws_l pi]/pi;  %设定归一化的remez函数参数（归一到pi）
a_l=[1 1 0 0];  %低通滤波器幅值为1
w_l=[1 10];

fil_l=remez(N1,f_l,a_l,w_l);  %生成滤波器
figure
freqz(fil_l,1,1024);


figure
stem(fil_l);
title('impulse response of lowpass filter');
xlabel('time sequence') ;
ylabel('amplitude');
fft_l=fft(fil_l,1024);
db_l=20*log10(abs(fft_l));  %对数表示

figure
plot([0:length(fft_l)-1]/(length(fft_l)/2),db_l);  %将横坐归化到0-1,单位为1/512
title(' Log-magnitude response of lowpass filter');
xlabel('Normalized frequency');
ylabel('Magnitude response (dB)');
axis([0 1 -100 10]);   %设坐标轴的范围，只取0-2pi的一半
afl=abs(fft_l);  %取傅变的幅值
afl_p=zeros(1,1024/2);
afl_s=zeros(1,1024/2);  %初始化两个一行512列的零序列
afl_p (1:fix((wp_l/(2*pi))*1024))=afl(1:fix((wp_l/(2*pi))*1024))-1;  %将通带幅值赋给序列一。减1是为了将波纹移到坐标轴附近
afl_s (fix((ws_l/(2*pi))*1024)+3:end)=afl(fix((ws_l/(2*pi))*1024)+3:end/2);  %将阻带幅值赋给序列二。加3是为了修正取值坐标

figure
plot([0:1024/2-1]/(1024),afl_p+afl_s);  %将通带和阻带的波形显示到一幅图像上
title('passband and stopband approximation error of lowpass filter');xlabel('Normalized frequency ');ylabel('Passband and stopband ripple');