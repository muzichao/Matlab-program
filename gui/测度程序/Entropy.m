function  [E_ND,Entropy_out]=Entropy(A) %求网络的熵
% N-------节点个数
%ND-------节点的度分布
%N_ND节点的度分布
N=size(A,2);%计算A的第二维的大小
ND=zeros(1,N);
ndin=zeros(1,N);
ndout=zeros(1,N);
ndin=sum(A);  %节点的入度
ndout=sum(A');%节点的出度
ND=ndin+ndout;
M=max(ND);
for i=1:M
    N_ND(i)=length(find(ND==i));
end
P_ND=zeros(1,M);
P_ND(:)=N_ND(:)/sum(N_ND);
PP_ND=zeros(1,M);
if P_ND(:)>0
    PP_ND(:)=log2(P_ND(:));
else 
    PP_ND(:)=0;
end
E_ND=zeros(1,M);
E_ND(:)=-P_ND(:).*PP_ND(:);
E_ND(find(E_ND==NaN))=0;
Entropy_out=sum(E_ND(:));





