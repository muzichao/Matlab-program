function A=sto_net(N,M,handles) %�����������
disp('�������ģ��')
%N=input('����������ڵ���N:\n');
%M=input('���������������� M<=N((N-1)/2)��\n'); 

axes(handles.axes1)   %��������axes1����ʾ�ڵ�ֲ�ͼ

angle=0:2*pi/N:2*pi-2*pi/N;
x=100*cos(angle);
y=100*sin(angle);
plot(x,y,'r.','Markersize',30);
hold on;
%���������������磻
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
%�����ڽӾ�������
for i=1:N
    for j=1:N
        if A(i,j)==1
            plot([x(i),x(j)],[y(i),y(j)],'linewidth',1);
            hold on;
        end
    end
end

title('����ͼ');
hold off    

