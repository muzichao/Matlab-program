function A=sto_net(N,M,handles) %生成随机网络
disp('随机网络模型')
%N=input('请输入网络节点数N:\n');
%M=input('请输入最终链接数 M<=N((N-1)/2)：\n'); 

axes(handles.axes1)   %在坐标轴axes1上显示节点分布图

angle=0:2*pi/N:2*pi-2*pi/N;
x=100*cos(angle);
y=100*sin(angle);
plot(x,y,'r.','Markersize',30);
hold on;
%生成最近邻耦合网络；
A=zeros(N);
k=0;
warning off
while (k<=M)
    i=randi([1,N],1,1);
    j=randi([1,N],1,1);
   while(i==j)
      j=randi([1,N],1,1);
   end
   if A(i,j)==0
      A(i,j)=1;
      k=k+1;
   end
end
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

