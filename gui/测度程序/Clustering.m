function [C,aver_C,max_C,min_C]=Clustering(A) %%�����ϵ��
%A--------------�ڽӾ���
%C--------------����ϵ��
%aver_C---------��������ͼ��ƽ������ϵ��
N=size(A,2);
C=zeros(1,N);
for i=1:N
    a=find(A(i,:)==1); %Ѱ����ͼ���ھӽڵ�
    b=find(A(:,i)==1);
    m=union(a,b'); 
    k=length(m);
    if k==1
        disp(['�ڵ�',int2str(i),'ֻ��һ���ھӽڵ㣬�����ϵ��Ϊ0']);
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
