%�Ŵ��㷨�Ӻ���,������ʼ��Ⱥ
%popsize=200;       %���ó�ʼ��Ⱥ��ģ
%chromlength=N-2;   %���ó�ʼ���߱�������  Ϊȷ���׾���С����β������
function pop=initpop(popsize,chromlength,SP,L,dc)
pop1=SP*(ones(popsize,chromlength)-rand(popsize,chromlength));  %����popsize�У�chromlength=N-2�и������
pop1=sort(pop1,2);                                              %���н��д�С���������
a=ones(popsize,chromlength)-(1-dc);                             %����popsize�У�chromlength=N-2�и����Ϊdc�ľ���
a=cumsum(a,2);                                                  %���е��ӣ������ۻ���
pop2=pop1+a;
pop=cat(2,zeros(popsize,1),pop2,L*ones(popsize,1));             %����popsize�У�N�еĳ�ʼ����Ⱥ