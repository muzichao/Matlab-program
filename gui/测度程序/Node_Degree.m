function  [ND,aver_ND,N_ND]=Node_Degree(A,handles) %�������ƽ���ȺͶȷֲ�ͼ
% N-------�ڵ����
%ND-------�ڵ�Ķȷֲ�
%N_ND�ڵ�Ķȷֲ�
N=size(A,2);%����A�ĵڶ�ά�Ĵ�С
ND=zeros(1,N);
ndin=zeros(1,N);
ndout=zeros(1,N);
%for i=1:N
 %   ndin(i)=sum(A(:i));   
  %  ndout(i)=sum(A(i:));  
%end
ndin=sum(A);  %�ڵ�����
ndout=sum(A');%�ڵ�ĳ���
ND=ndin+ndout;
aver_ND=mean(ND);

axes(handles.axes2)   %��������axes2����ʾ�ȷֲ�ͼ

bar([1:N],ND);
xlabel('�ڵ���');
ylabel('���ڵ�Ķ���K');
title('�ڵ�Ķȷֲ�ͼ');

M=max(ND);
for i=1:M
    N_ND(i)=length(find(ND==i));
end
P_ND=zeros(1,M);
P_ND(:)=N_ND(:)/sum(N_ND);

%{
figure;
bar([1:M],N_ND,'r');
xlabel('�ڵ�Ķ�K');
ylabel('�ڵ�Ķȷֲ�');
title('�ڵ�Ķȷֲ�ͼ');

figure;
bar([1:M],P_ND,'r');
xlabel('�ڵ�Ķ�K');
ylabel('�ڵ�ȵĸ���P(K)');
title('�ڵ�Ķȸ��ʷֲ�ͼ');
%}
