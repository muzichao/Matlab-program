function f=myfun(h)

N=32;
ha=[h(1:N/2) fliplr(h(1:N/2))];
hb=[h(N/2+1:N) -fliplr(h(N/2+1:N))];


[mag1,w1]=freqz(ha,[1],1024);
[mag2,w2]=freqz(hb,[1],1024);

sum1=0;
sum2=0;
wp=0.43;  ws=0.57;
% wp=0.35;ws=0.65;
for i=1:ceil(wp*1024)
    sum1=sum1+(1-abs(mag1(i))).^2;
    sum2=sum2+abs(mag2(i)).^2;
end
for i=ceil(ws*1024):1024
    sum1=sum1+(1-abs(mag2(i))).^2;
    sum2=sum2+abs(mag1(i)).^2;
 end
alpha=0.6;
f=alpha*sum1+(1-alpha)*sum2;

% sum1=0;
% sum2=0;
% wp=0.43;  ws=0.57;
% for i=ceil(ws*1024):1024
%     sum1=sum1+abs(mag1(i))^2;
% end
% for i=1:1024
%     sum2=sum2+(1-(abs(mag1(i)))^2-(abs(mag2(i)))^2)^2;
% end
% alpha=0.5;
% f=alpha*sum1+(1-alpha)*sum2;