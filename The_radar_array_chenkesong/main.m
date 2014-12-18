%��������λ��x���ϵĲ��ȼ��ֱ������,�ο����ס�һ������Ԫ���Լ����ϡ���������ۺϷ��������¿��ɡ�
clc,clear,clf;
format;
T1=clock;
s1=sprintf('�������������У����Ե�......');
disp(s1);
%% ����
N=17;              %��Ԫ��
L=10.4;              %���п׾�  N>L>0.5*N,��Ϊ���߼������:1>d>0.5  �ò�������
dc=0.5;            %��С��Ԫ���                                 �ò�������
SP=L-(N-1)*dc;     %SPΪ�׾���ʣ�಼�����䳤��
popsize=200;       %���ó�ʼ��Ⱥ��ģ
pc0=0.5;            %���ó�ʼ�������
pm0=0.01;           %���ó�ʼ�������
numitera=300;      %���õ�������
chromlength=N-2;   %���ó�ʼ���߱�������
In=1;              %�������Ԫ�����ǵȷ�ͬ���
res=1800;          %���ò���������Ҳ���Ƿֱ���
theta=0:pi/res:pi; %theta �ǹ۲췽��������ļн�
theta0=90/180*pi;  %theta0 Ϊ����ָ�򣬵�Ϊ 0.5*pi ʱΪ������
u=cos(theta)-cos(theta0);

%------------------------------------��ʼ����Ⱥ-----------------------------%
pop=initpop(popsize,chromlength,SP,L,dc);%���г�ʼ��������������ʼ����Ⱥ

num=1;             %��ʼ��ѭ��������������ֻ�������Ҫ��ĵ���������ѭ���Ż���ֹ��
bestindividual=ones(numitera,N+1);  %����ÿ�ε��������ֵ

while num<=numitera   %���ó�����ֹ����
    disp(['��',num2str(num),'��'])
    
    
    [SLLmax,Elog]=calobjvalue(pop,popsize,N,u,res);%����Ŀ�꺯�������������ֵ�԰�
    fitvalue=calfitvalue(SLLmax,popsize);%������Ӧ��ֵ�Ĵ�С
    newpop=select(fitvalue,popsize,pop);  %newpopΪ�������̶�ѡ��֮����µ���Ⱥ
    newpop1=pretreat(newpop,popsize,dc,chromlength);%�Ŵ�����Ԥ����
    newpop2=crossover(newpop1,popsize,pc0,N);        %���н�������
    newpop3=mutation(newpop2,popsize,pm0,N,SP);      %���б�������
    newpop4=posttreat(newpop3,popsize,dc,chromlength);%�Ŵ���������
   
    %�Ŵ�����֮�������¼�����Ӧ�Ⱥ�����С
    [newSLLmax,newElog]=calobjvalue(newpop4,popsize,N,u,res);
    newfitvalue=calfitvalue(newSLLmax,popsize);
    
    %�����Ѹ��壬��������С��ֵ�԰����Ѹ���
    [Minvalue,Index]=min(newfitvalue);
    bestindividual(num,1)=Minvalue; %ÿһ���е���С��ֵ�԰걣���ڵ�һ��
    bestindividual(num,2:N+1)=newpop4(Index,:); %ÿһ����С��ֵ�԰�����Ӧ������Ⱦɫ�壨Ҳ������Ԫ���ڵ�λ�ã�
    
    pop=newpop4;    %���¸�ֵ����ѭ��
    
    num=num+1;      %�Ա�����1
end

%% ���bestindividual�е���Сֵ������Ⱦɫ��
bestindividual1=abs(bestindividual);  %ȡ����ֵ
[Minfit,I]=max(bestindividual1(:,1));  %��� bestindividual1 �����ֵ��Ҳ���� bestindividual �е���Сֵ�������ڵ���
Minfit=-1*Minfit;    %�����ͷ�ֵ�԰��ƽ
chromosome=bestindividual(I,2:N+1); %����Ⱦɫ��
str1=sprintf('��������%d��\n',I);
str2=sprintf('��Ӧ��Ⱦɫ��:%s\n',num2str(chromosome));
str3=sprintf('����ֵΪ:%.3f\n',Minfit);
disp(str1);
disp(str2);
disp(str3);

%% ��������ͼ
S=zeros(1,length(u));   %��ʼ��������
for m=1:N
   S(1,:)=S(1,:) + exp(j*2*pi*u*chromosome(1,m));
end
S=abs(S);
Slog = 20*log10(S/max(S));
plot(theta*180/pi,Slog,'k','linewidth',2);  %���������ӷ���ͼ
xlabel('��λ��(degree)','FontSize',11);
ylabel('PSLL��dB��','FontSize',11);
axis([0 180 -45 0]);

%% �����������ʱ��
T2=clock;
T3=T2-T1;
if T3(6)<0                %������
    T3(6)=T3(6)+60;
    T3(5)=T3(5)-1;
end
if T3(5)<0                %�������
    T3(5)=T3(5)+60;
    T3(4)=T3(4)-1;
end
if T3(4)<0                %����Сʱ
    T3(4)=T3(4)+24;
    T3(3)=T3(3)-1;
end
s2=sprintf('�������к�ʱ��%d Сʱ %d ���� %.4f ��',T3(4),T3(5),T3(6));
disp(s2);


