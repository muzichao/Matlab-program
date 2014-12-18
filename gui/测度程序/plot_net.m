function plot_net(N,A,handles) %生成规则网络

axes(handles.axes1)   %在坐标轴axes1上显示节点分布图

angle=0:2*pi/N:2*pi-2*pi/N;
x=100*cos(angle);
y=100*sin(angle);
plot(x,y,'r.','Markersize',30);
hold on;


%disp(A);
%根据邻接矩阵连线

for i=1:N
    for j=1:N
        if A(i,j)==1
            plot([x(i),x(j)],[y(i),y(j)],'linewidth',1);
            hold on;
        end
    end
end

title('连接图');
hold off
         


           
            
            
        

            

