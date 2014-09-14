clear
clc

% initialization
N=32;

wp=0.43;ws=0.57;
p0=firpm(N-1,[0 wp ws 1],[1 1 0 0]);      % the original lowpass filter
p1=firpm(N-1,[0 wp ws 1],[0 0 1 1],'h');  % the original highpass filter
% load p0;
% load p1;
p=[p0(1:N/2) p1(1:N/2)];                  % the start point passed to the objective function
% h=[h0(1:N1/2) h1(1:N2/2)];  
%  optimization function
opts=optimset('Display','iter','MaxFunEvals',1e12, 'MaxIter',1e10,'Largescale','on','TolX',1e-10,'TolCon',1e-15,'TolFun',1e-17);
% opts=optimset('Display','iter','MaxFunEvals',1e12, 'MaxIter',1e10,'Largescale','on','TolX',1e-10,'TolCon',1e-15,'TolFun',1e-17,'algorithm','interior-point');
% opts=optimset('Display','iter', 'MaxIter',1e10,'Largescale','on','TolX',1e-10,'TolCon',1e-10,'TolFun',1e-17);
[h]=fmincon('myfun',p,[],[],[],[],[],[],'mycon',opts);     

h0=[h(1:N/2) fliplr(h(1:N/2))];
% h0=[h(1:N1/2) fliplr(h(1:N1/2))];       %用h表示h0
% h0=[h(1:15) h(16) fliplr(h(1:15))];
h1=[h(N/2+1:N) -fliplr(h(N/2+1:N))];
% h1=[h(N1/2+1:(N1/2+N2/2)) -fliplr(h(N1/2+1:(N1/2+N2/2)))];    %用h表示h1

for i=1:N                     % F0(z)=H1(-z)
  f0(i)=(-1).^(i-1)*h1(i);
end
for i=1:N                    % F1(z)=-H0(-z)
  f1(i)=(-1).^i*h0(i);
end
% save h0;
% save h1;
% save f0;
% save f1;

% 计算Epp，Ea
H0 = freqz(h0,[1],1024);
H1 = freqz(h1,[1],1024);
F0 = freqz(f0,[1],1024);
F1 = freqz(f1,[1],1024);


Tz=H0.*F0+H1.*F1;
Tz=abs(Tz);
Epp=max(Tz)-min(Tz)

dbH0=20*log10(abs(H0));
dbH1=20*log10(abs(H1));
figure(1)
t=1:1024;
plot(t./1024,dbH0,'r')
hold on
plot(t./1024,dbH1,'b')
hold off
grid on
axis([0 1 -100 20]);
xlabel('Normalized frequency (\omega/\pi)');ylabel('Log Magnitude (dB)');
title('H0 and H1')
figure(2)
subplot(211)
stem(h0)
xlabel('the impulse response of h0');
subplot(212)
stem(h1)
xlabel('the impulse response of h1');

% 
% figure(3)
% t=1:1024;
% plot(t./1024,20*log10(abs(F0)),'r')
% hold on
% plot(t./1024,20*log10(abs(F1)),'b')
% hold off
% axis([0 1 -100 20]);
% xlabel('Normalized frequency (\omega/\pi)');ylabel('Log Magnitude (dB)');
% title('F0 and F1')
% figure(4)
% subplot(211)
% stem(f0)
% xlabel('the impulse response of f0');
% subplot(212)
% stem(f1)
% xlabel('the impulse response of f1');

% figure(5)
% t=1:1024;
% plot(t./1024,20*log10(Tz))
% xlabel('Normalized frequency (\omega/\pi)');ylabel('Log Magnitude (dB)');
% title('The transfer function of the  filter banks Tz')
% 
% figure(5)
% t=1:1024;
% plot(t./1024,(Tz))
% axis([0 1 0.99920 0.99925])
% xlabel('Normalized frequency (\omega/\pi)');
% title('The transfer function of the  filter banks Tz')