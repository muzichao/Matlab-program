function A=rule_net(N,K,handles) %���ɹ�������
disp('��������ģ��')
%N=input('����������ڵ���N:\n');
%K=input('��������ڵ��������ڵ�K/2�Ľڵ���:\n');

axes(handles.axes1)   %��������axes1����ʾ�ڵ�ֲ�ͼ

angle=0:2*pi/N:2*pi-2*pi/N;
x=100*cos(angle);
y=100*sin(angle);
plot(x,y,'r.','Markersize',30);
hold on;
%���������������磻
A=zeros(N);
%disp(A);
for i=1:N
    if i+K<=N
       for j=i+1:i+K
           A(i,j)=1;
       end
    else 
        for j=i+1:N
            A(i,j)=1;
        end
        for j=1:((i+K)-N)
            A(i,j)=1;
        end
    end
    if K<i
        for j=i-K:i-1
          A(i,j)=1;
        end
    else 
        for j=1:i-1
             A(i,j)=1;
        end
        for j=N-K+i:N
            A(i,j)=1;
        end
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
%aver_path=aver_pathlength(A);
%disp(aver_path);
         


           
            
            
        

            

