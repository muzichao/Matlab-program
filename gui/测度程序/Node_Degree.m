function  [ND,aver_ND,N_ND]=Node_Degree(A,handles) %求网络的平均度和度分布图
% N-------节点个数
%ND-------节点的度分布
%N_ND节点的度分布
N=size(A,2);%计算A的第二维的大小
ND=zeros(1,N);
ndin=zeros(1,N);
ndout=zeros(1,N);
%for i=1:N
 %   ndin(i)=sum(A(:i));   
  %  ndout(i)=sum(A(i:));  
%end
ndin=sum(A);  %节点的入度
ndout=sum(A');%节点的出度
ND=ndin+ndout;
aver_ND=mean(ND);

axes(handles.axes2)   %在坐标轴axes2上显示度分布图

bar([1:N],ND);
xlabel('节点编号');
ylabel('各节点的度数K');
title('节点的度分布图');

M=max(ND);
for i=1:M
    N_ND(i)=length(find(ND==i));
end
P_ND=zeros(1,M);
P_ND(:)=N_ND(:)/sum(N_ND);

%{
figure;
bar([1:M],N_ND,'r');
xlabel('节点的度K');
ylabel('节点的度分布');
title('节点的度分布图');

figure;
bar([1:M],P_ND,'r');
xlabel('节点的度K');
ylabel('节点度的概率P(K)');
title('节点的度概率分布图');
%}
