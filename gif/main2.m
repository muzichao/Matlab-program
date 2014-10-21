clc
clear all
close all

surf(peaks); %绘制多峰函数
%shading interp
grid off
set(gcf,'color','white')
el=0;  %设置仰角为30度。
for az=0:3:360  %让方位角从0变到360，绕z轴一周
    view(az,el);
    axis off
    axis equal
    %F=getframe(gcf);
%     figure(2)
%     imshow(F.cdata)
    %pause(0.1);
    if az<10
        string=['00',num2str(az)];
    elseif az<100
        string=['0',num2str(az)];
    else
        string=num2str(az);
    end
   % saveas(gcf,['.\data\data1\',string,'.jpg'])
end

% az= 0;   %设置方位角为0
% for el=0:3:360   %仰角从0变到360
%     view(az,el);
% 
%     axis off
%     axis equal
%     %pause(0.1);
%     if el<10
%         string=['00',num2str(el)];
%     elseif el<100
%         string=['0',num2str(el)];
%     else
%         string=num2str(el);
%     end
%     saveas(gcf,['.\data\data2\',string,'.jpg'])
% end