%2013 11 6
%3维场景在2维空间的投影
%制成动画

clc
clear all
close all
set(gcf,'color','white')


x1=linspace(-1,1,50);
y1=linspace(0,2,50);
[x,y] = meshgrid(x1,y1); 
z=5*exp(-(x-0).^2/4-(y-1).^2/4);
z=(z-4).*(z>4);
surfl(x,y,z);


hold on
x1=x+2;
y1=y+2;
z1=z;
surfl(x1,y1,z1);
%shading interp

hold on
x2=x+2;
y2=y;
z2=zeros(size(z));
surfl(x2,y2,z2);

hold on
x3=x;
y3=y+2;
z3=zeros(size(z));
surfl(x3,y3,z3);
%shading interp


colormap([1 0 0; 1 0 0])
grid off

for i=0:3:360
    %title(['视角：',num2str(i),'°'],'position',[2,2,1])
    view(i,15)
    %axis off
    %axis equal
    
    if i<10
        string=['00',num2str(i)];
    elseif i<100
        string=['0',num2str(i)];
    else
        string=num2str(i);
    end
    %saveas(gcf,['.\data\data3\',string,'.jpg'])
    drawnow
    pause(0.02)
end
