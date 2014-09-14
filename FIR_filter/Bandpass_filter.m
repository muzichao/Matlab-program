%chapter 2  第二题  多速率滤波器设计
clc
clear all
close all

wsl=0.2*pi;
wpl=0.28*pi;
wpu=0.72*pi;
wsu=0.8*pi;

f=[wsl/pi,wpl/pi,wpu/pi,wsu/pi];
m=[0,1,0];
delte_p=0.01;
delte_s=0.001;

rip=[delte_s,delte_p,delte_s];

[M,f0,m0,w]=remezord(f,m,rip);

%M=M+2;
M=80;
hn=remez(M,f0,m0,w);
freqz(hn,1,1024);

%% 
[H,m]=freqz(hn,1,1024,'whole');    %求其频率响应
mag=abs(H);     %得到幅值
db=20*log10((mag+eps)/max(mag));
pha=angle(H);   %得到相位

%%
figure

subplot(1,2,1);
n=0:M;
stem(n,hn,'.');
axis([0,M,-0.1,0.3]);
hold on;
n=0:M;
x=zeros(M+1);
plot(n,x,'-');
xlabel('n');
ylabel('h(n)');
title('带通滤波器的h(n)');

hold off;

subplot(1,2,2);
plot(m,mag);
title('幅频特性');
xlabel('频率W(rad)');
ylabel('幅值');
axis([0,3.15,0,1.5]);

figure
mags=mag.*(m<wsl | m>wsu).*(m<=pi);
magp=(mag-1).*(m>=wpl & m<=wpu);
sigmas=max(abs(mags));
sigmap=max(abs(magp));

plot(m,magp+mags)
axis([0,3.14,-0.015,0.015]);
title(['误差特性(N=',num2str(M),')']);
xlabel('频率W(rad)');
ylabel('误差');
grid;

disp(['带通滤波器的阶数为：',num2str(M)])
disp(['通带误差为：',num2str(sigmap)])
disp(['阻带误差为：',num2str(sigmas)])