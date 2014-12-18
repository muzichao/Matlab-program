%主函数，位于x轴上的不等间距直线阵列,参考文献《一种有阵元间距约束的稀布阵天线综合方法——陈客松》
clc,clear,clf;
format;
T1=clock;
s1=sprintf('程序正在运行中，请稍等......');
disp(s1);
%% 参数
N=17;              %阵元数
L=10.4;              %阵列孔径  N>L>0.5*N,因为天线间距满足:1>d>0.5  用波长量化
dc=0.5;            %最小阵元间距                                 用波长量化
SP=L-(N-1)*dc;     %SP为孔径上剩余布阵区间长度
popsize=200;       %设置初始种群规模
pc0=0.5;            %设置初始交叉概率
pm0=0.01;           %设置初始变异概率
numitera=300;      %设置迭代次数
chromlength=N-2;   %设置初始决策变量个数
In=1;              %设各个阵元激励是等幅同相的
res=1800;          %设置采样点数，也就是分辨率
theta=0:pi/res:pi; %theta 是观察方向与阵轴的夹角
theta0=90/180*pi;  %theta0 为波束指向，当为 0.5*pi 时为侧射阵
u=cos(theta)-cos(theta0);

%------------------------------------初始化种群-----------------------------%
pop=initpop(popsize,chromlength,SP,L,dc);%运行初始化函数，产生初始化种群

num=1;             %初始化循环变量（现在是只有完成所要求的迭代次数，循环才会终止）
bestindividual=ones(numitera,N+1);  %保存每次迭代的最佳值

while num<=numitera   %设置程序终止条件
    disp(['第',num2str(num),'代'])
    
    
    [SLLmax,Elog]=calobjvalue(pop,popsize,N,u,res);%计算目标函数，并求出最大峰值旁瓣
    fitvalue=calfitvalue(SLLmax,popsize);%计算适应度值的大小
    newpop=select(fitvalue,popsize,pop);  %newpop为经过轮盘赌选择之后的新的种群
    newpop1=pretreat(newpop,popsize,dc,chromlength);%遗传操作预处理
    newpop2=crossover(newpop1,popsize,pc0,N);        %进行交叉运算
    newpop3=mutation(newpop2,popsize,pm0,N,SP);      %进行变异运算
    newpop4=posttreat(newpop3,popsize,dc,chromlength);%遗传操作后处理
   
    %遗传操作之后再重新计算适应度函数大小
    [newSLLmax,newElog]=calobjvalue(newpop4,popsize,N,u,res);
    newfitvalue=calfitvalue(newSLLmax,popsize);
    
    %求出最佳个体，并保存最小峰值旁瓣和最佳个体
    [Minvalue,Index]=min(newfitvalue);
    bestindividual(num,1)=Minvalue; %每一代中的最小峰值旁瓣保存在第一列
    bestindividual(num,2:N+1)=newpop4(Index,:); %每一代最小峰值旁瓣所对应的最优染色体（也即是阵元所在的位置）
    
    pop=newpop4;    %重新赋值进行循环
    
    num=num+1;      %自变量加1
end

%% 求出bestindividual中的最小值及最优染色体
bestindividual1=abs(bestindividual);  %取绝对值
[Minfit,I]=max(bestindividual1(:,1));  %求出 bestindividual1 中最大值，也就是 bestindividual 中的最小值及其所在的行
Minfit=-1*Minfit;    %求出最低峰值旁瓣电平
chromosome=bestindividual(I,2:N+1); %最优染色体
str1=sprintf('进化到第%d代\n',I);
str2=sprintf('对应的染色体:%s\n',num2str(chromosome));
str3=sprintf('最优值为:%.3f\n',Minfit);
disp(str1);
disp(str2);
disp(str3);

%% 画出方向图
S=zeros(1,length(u));   %初始化阵因子
for m=1:N
   S(1,:)=S(1,:) + exp(j*2*pi*u*chromosome(1,m));
end
S=abs(S);
Slog = 20*log10(S/max(S));
plot(theta*180/pi,Slog,'k','linewidth',2);  %绘制阵因子方向图
xlabel('方位角(degree)','FontSize',11);
ylabel('PSLL（dB）','FontSize',11);
axis([0 180 -45 0]);

%% 计算程序运行时间
T2=clock;
T3=T2-T1;
if T3(6)<0                %计算秒
    T3(6)=T3(6)+60;
    T3(5)=T3(5)-1;
end
if T3(5)<0                %计算分钟
    T3(5)=T3(5)+60;
    T3(4)=T3(4)-1;
end
if T3(4)<0                %计算小时
    T3(4)=T3(4)+24;
    T3(3)=T3(3)-1;
end
s2=sprintf('程序运行耗时：%d 小时 %d 分钟 %.4f 秒',T3(4),T3(5),T3(6));
disp(s2);


