function [aver_D,d]=Aver_Path_Length(A) %�������ƽ��·�����Ⱥ�ֱ��
%  A��������������������ͼ���ڽӾ���
%  D��������������������ֵ������ͼ�ľ������
%  aver_D������������������ֵ������ͼ��ƽ��·������
%  d���������������������ֱ��
 N=size(A,2);
 D=A;
 D(find(D==0))=inf;    %���ڽӾ����Ϊ�ڽӾ�����������ޱ�����ʱ��ֵΪinf����������ľ���Ϊ0.
 for i=1:N           
     D(i,i)=0;       
 end   
 for k=1:N            %Floyd�㷨��������������̾���
     for i=1:N
         for j=1:N
             if D(i,j)>D(i,k)+D(k,j)
                D(i,j)=D(i,k)+D(k,j);
             end
         end
     end
 end
 aver_D=sum(sum(D))/(N*(N-1));  %ƽ��·������
 d=max(max(D));
 if aver_D==inf
     disp('������ͼ������ͨͼ');
 end
         
 
 
 
 