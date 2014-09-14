%遗传算法子函数,产生初始种群
%popsize=200;       %设置初始种群规模
%chromlength=N-2;   %设置初始决策变量个数  为确保孔径大小，首尾有天线
function pop=initpop(popsize,chromlength,SP,L,dc)
pop1=SP*(ones(popsize,chromlength)-rand(popsize,chromlength));  %产生popsize行，chromlength=N-2列个随机数
pop1=sort(pop1,2);                                              %按行进行从小到大的排列
a=ones(popsize,chromlength)-(1-dc);                             %产生popsize行，chromlength=N-2列个相距为dc的矩阵
a=cumsum(a,2);                                                  %按行叠加，计算累积和
pop2=pop1+a;
pop=cat(2,zeros(popsize,1),pop2,L*ones(popsize,1));             %产生popsize行，N列的初始化种群