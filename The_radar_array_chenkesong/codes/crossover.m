%�Ŵ��㷨�ӳ��򣺽�������(���㽻��)
function newpop2=crossover(newpop1,popsize,pc0,N)
for i=1:2:popsize-1
    if rand<pc0                      %�������ֻ�������С�ڽ�����ʲſ��Խ��н���
        cpoint=round(rand*(N-3)+2);  %��������λ�ã�λ��[2��N-1]����
        newpop2(i,:)=[newpop1(i,1:cpoint),newpop1(i+1,cpoint+1:N)];   %���㽻�棬��������
        newpop2(i,:)=sort(newpop2(i,:),2);                            %�Խ����Ļ��������а������У�Ԫ�ش�С����
        newpop2(i+1,:)=[newpop1(i+1,1:cpoint),newpop1(i,cpoint+1:N)];
        newpop2(i+1,:)=sort(newpop2(i+1,:),2);
    else
        newpop2(i,:)=newpop1(i,:);%�����㽻�������������н���
        newpop2(i,:)=sort(newpop2(i,:),2);
        newpop2(i+1,:)=newpop1(i+1,:);
        newpop2(i+1,:)=sort(newpop2(i+1,:),2);
    end
end


%Ҳ���������������棬�����Ǽ�Ҫ��˵����a��ĳһ������
%for i=1:2:popsize-1
%    if rand<pc 
 %       newpop2(i,:)=a*newpop1(i,:)+(1-a)*newpop1(i+1,:);
  %      newpop2(i,:)=sort(newpop2(i,:),2); 
   %     newpop2(i+1,:)=a*newpop1(i+1,:)+ a*newpop1(i,:);
    %    newpop2(i+1,:)=sort(newpop2(i+1,:),2);
     %else
      %  newpop2(i,:)=newpop1(i,:);
       % newpop2(i,:)=sort(newpop2(i,:),2);
        %newpop2(i+1,:)=newpop1(i+1,:);
        %newpop2(i+1,:)=sort(newpop2(i+1,:),2)
    %end
%end
% pcҲ�������Ž���ʱ����仯