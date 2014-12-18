clc
clear all
close all

[x,y,z]=peaks;
z=(z-3).*(z>3);

surfl(x,y,z); %���ƶ�庯��
shading interp
grid off
set(gcf,'color','white')
el=0;  %��������Ϊ30�ȡ�
for az=0:2:360  %�÷�λ�Ǵ�0�䵽360����z��һ��
    title(['�۲�Ƕȣ�',num2str(az),'��'])
    view(az,el);
    %axis off
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
    saveas(gcf,['.\data\data3\',string,'.jpg'])
end

% az= 0;   %���÷�λ��Ϊ0
% for el=0:2:360   %���Ǵ�0�䵽360
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
%     saveas(gcf,['.\data\data4\',string,'.jpg'])
% end