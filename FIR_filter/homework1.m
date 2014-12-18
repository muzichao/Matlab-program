%chapter 2  ��һ��  �������˲������
clc
clear all
close all

wp=0.4*pi;
ws=0.6*pi;
%alpha_p=1;
%alpha_s=40;


f=[wp/pi,ws/pi];
m=[1,0];
delte_p=0.01;
delte_s=0.001;
rip=[delte_p,delte_s];

[M,f0,m0,w]=remezord(f,m,rip);

%M=57;
M=M+1;
hn=remez(M,f0,m0,w);

freqz(hn,1,1024);

%% 
[H,m]=freqz(hn,1,1024,'whole');    %����Ƶ����Ӧ
mag=abs(H);     %�õ���ֵ
db=20*log10((mag+eps)/max(mag));
pha=angle(H);   %�õ���λ

%%
figure

subplot(2,2,1);
n=0:M;
stem(n,hn,'.');
axis([0,M,-0.1,0.3]);
hold on;
n=0:M;
x=zeros(M+1);
plot(n,x,'-');
xlabel('n');
ylabel('h(n)');
title('��ͨ�˲�����h(n)');

hold off;

subplot(2,2,2);
plot(m/pi,db);
axis([0,1,-100,0]);
xlabel('w/pi');
ylabel('dB');
title('˥������(dB)');
grid;

subplot(2,2,3);
plot(m,pha);
hold on;
n=0:7;
x=zeros(8);
plot(n,x,'-');
title('��Ƶ����');
xlabel('Ƶ��(rad)');
ylabel('��λ(rad)');
axis([0,3.15,-4,4]);

subplot(2,2,4);
plot(m,mag);
title('Ƶ������');
xlabel('Ƶ��W(rad)');
ylabel('��ֵ');
axis([0,3.15,0,1.5]);

figure
magp=(mag-1).*(m<wp);
mags=mag.*(m>ws).*(m<=pi);

sigmap=max(abs(magp))
sigmas=max(abs(mags))

plot(m,magp+mags)
axis([0,3.14,-0.015,0.015]);
title('�������');
xlabel('Ƶ��W(rad)');
ylabel('���');
grid;