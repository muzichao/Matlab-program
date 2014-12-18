%2013 11 6
%3维场景在2维空间的投影
%制成动画

clc
clear all
close all
addpath('.\customplots')
figure
set(gcf,'color','white')
colormap([1 0 0; 1 0 0])

xx=linspace(-1,1,50);
yy=linspace(0,2,50);
[x,y] = meshgrid(xx,yy);
z=5*exp(-(x-0).^2/4-(y-1).^2/4);
z=(z-4).*(z>4);
z=z*10;

for i=0:1:150
    %figure(1)
    surfl(x,y*4,z);
    hold on
    x1=x+7-i*0.02;
    y1=y;
    z1=z;
    surfl(x1,y1*4,z1);
    
    x2=x+14-i*0.04;
    y2=y;
    z2=z;
    surfl(x2,y2*4,z2);
    
    shading interp
    %title(['视角：',num2str(i),'°'],'position',[2,2,1])
    view(37,15)
    %axis off
    axis equal
    %oaxes([0,0,0],'Arrow','off')
    axis([-1 15 0 8 0 10])
    set(gca,'ZTick',[0,10]);
    set(gca,'ZTickLabel',{'0','F(w)'}) %X坐标轴刻度处显示的字符
    set(gca,'YTick',[0,8]);
    set(gca,'YTickLabel',{'0','1'}) %Y坐标轴刻度处显示的字符
    set(gca,'XTick',[0,1,3.5-i*0.01,7-i*0.02,14-i*0.04,15]);
    set(gca,'XTickLabel',{'0','fm','fs/2','fs','2fs','f'}) %Z坐标轴刻度处显示的字符
   
    if i<10
        string=['00',num2str(i)];
    elseif i<100
        string=['0',num2str(i)];
    else
        string=num2str(i);
    end
    saveas(gcf,['.\data\data4\',string,'.jpg'])
    drawnow
    %pause(0.02)
    hold off
end
%break
for j=1:30
    view(37-j,15);
    k=j+150;
    
    string=num2str(k);
    
    saveas(gcf,['.\data\data4\',string,'.jpg'])
    drawnow
    %pause(0.05)
end

