  %�Ŵ��㷨�ӳ��򣺱�������
function newpop3=mutation(newpop2,popsize,pm0,N,SP)
newpop3=newpop2;
for i=1:popsize
   if (rand<pm0)        %�������ֻ�������С�ڱ�����ʲŽ��б������
        mpoint=round(rand*(N-3)+2); %��������λ�ã�λ������Ϊ[2,N-1]
        newpop3(i,mpoint)=rand*SP;  %����λ���ϵ�Ԫ����[0,SP]�����ϵ����������
        newpop3(i,:)=sort(newpop3(i,:),2); %�������Ļ������ ���� ��С��������
    else
        newpop3(i,:)=newpop2(i,:);
    end
end
%Ҳ����ʹpm���Ž��������ı仯�����������������ֲ�����
%for i=1:popsize
%pm=pm0+(0.05-pm0)*i/popsize