clc
clear all
close all

wp_l=0.4*pi;  
ws_l=0.6*pi;    
N1=26;  %��ʼ������
f_l=[0 wp_l ws_l pi]/pi;  %�趨��һ����remez������������һ��pi��
a_l=[1 1 0 0];  %��ͨ�˲�����ֵΪ1
w_l=[1 10];

fil_l=remez(N1,f_l,a_l,w_l);  %�����˲���
figure
freqz(fil_l,1,1024);


figure
stem(fil_l);
title('impulse response of lowpass filter');
xlabel('time sequence') ;
ylabel('amplitude');
fft_l=fft(fil_l,1024);
db_l=20*log10(abs(fft_l));  %������ʾ

figure
plot([0:length(fft_l)-1]/(length(fft_l)/2),db_l);  %�������黯��0-1,��λΪ1/512
title(' Log-magnitude response of lowpass filter');
xlabel('Normalized frequency');
ylabel('Magnitude response (dB)');
axis([0 1 -100 10]);   %��������ķ�Χ��ֻȡ0-2pi��һ��
afl=abs(fft_l);  %ȡ����ķ�ֵ
afl_p=zeros(1,1024/2);
afl_s=zeros(1,1024/2);  %��ʼ������һ��512�е�������
afl_p (1:fix((wp_l/(2*pi))*1024))=afl(1:fix((wp_l/(2*pi))*1024))-1;  %��ͨ����ֵ��������һ����1��Ϊ�˽������Ƶ������ḽ��
afl_s (fix((ws_l/(2*pi))*1024)+3:end)=afl(fix((ws_l/(2*pi))*1024)+3:end/2);  %�������ֵ�������ж�����3��Ϊ������ȡֵ����

figure
plot([0:1024/2-1]/(1024),afl_p+afl_s);  %��ͨ��������Ĳ�����ʾ��һ��ͼ����
title('passband and stopband approximation error of lowpass filter');xlabel('Normalized frequency ');ylabel('Passband and stopband ripple');