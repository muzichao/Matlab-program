function [c,ceq]=mycon(h)
N=32;
c=[];

ha=[h(1:N/2) fliplr(h(1:N/2))];
% ha=[h(1:15) h(16) fliplr(h(1:15))];
hb=[h(N/2+1:N) -fliplr(h(N/2+1:N))];

for i=1:N
    ha1(i)=(-1).^(i-1)*ha(i);
end
for i=1:N
    hb1(i)=(-1).^(i-1)*hb(i);
end

mid=conv(ha,hb1)-conv(ha1,hb);

for i=1:N-1
    ceq(i)=mid(i);
end
% ceq(N)=sum(ha)-1;
% ceq(N+1)=sum(hb);
% ceq(N+2)=sum(ha1);
% ceq(N+3)=sum(hb1)-1;

% ceq(N)=1-mid(N);