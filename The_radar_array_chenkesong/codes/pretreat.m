%�Ŵ��㷨�ӳ���:  �Ŵ�����Ԥ����
function newpop1=pretreat(newpop,popsize,dc,chromlength) %newpop1ΪԤ����֮��õ��Ļ������
%����Լ������
con=ones(popsize,chromlength)-(1-dc);                 %����popsize�У�chromlength=N-2�и����Ϊdc�ľ���
con=cumsum(con,2);                                    %���е��ӣ������ۻ���
cons=cat(2,zeros(popsize,1),con,zeros(popsize,1));     %Լ������cat(dim,A,B,C)dim=1��ʾ�������ӣ�dim=2��ʾ��������
newpop1=newpop-cons;