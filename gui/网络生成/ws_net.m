function A=ws_net(N,K,p,handles) %����С��������
disp('С��������ģ��')
%N=input('����������ڵ���N��\n');
%K=input('��������ڵ��������ڵ�K/2�Ľڵ���:\n');
%p=input('��������������ĸ���:\n');

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
%���������
for i=1:N
    for j=i+1:N
      if  A(i,j)==1
        pp=unifrnd(0,1);
        if pp<=p
            A(i,j)=0;
            A(j,i)=0;
            b=unidrnd(N);
            while i==b
                b=unidrnd(N);
            end
            A(i,b)=1;
            A(b,i)=1;
        end
      end
    end
end
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
         


           
            
            
        

            

