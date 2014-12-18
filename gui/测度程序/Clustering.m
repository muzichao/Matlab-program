function [C,aver_C,max_C,min_C]=Clustering(A) %%求聚类系数
%A--------------邻接矩阵
%C--------------聚类系数
%aver_C---------整个网络图的平均聚类系数
N=size(A,2);
C=zeros(1,N);
for i=1:N
    a=find(A(i,:)==1); %寻找子图的邻居节点
    b=find(A(:,i)==1);
    m=union(a,b'); 
    k=length(m);
    if k==1
        disp(['节点',int2str(i),'只有一个邻居节点，其聚类系数为0']);
        C(i)=0;
    else
        B=A(m,m);
        C(i)=length(find(B==1))/(k*(k-1));
    end
end
aver_C=mean(C);
max_C=max(C);
n=find(C==0);
a=C;
a(n)=inf;
min_C=min(a);
