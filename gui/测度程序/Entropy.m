function  [E_ND,Entropy_out]=Entropy(A) %���������
% N-------�ڵ����
%ND-------�ڵ�Ķȷֲ�
%N_ND�ڵ�Ķȷֲ�
N=size(A,2);%����A�ĵڶ�ά�Ĵ�С
ND=zeros(1,N);
ndin=zeros(1,N);
ndout=zeros(1,N);
ndin=sum(A);  %�ڵ�����
ndout=sum(A');%�ڵ�ĳ���
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





