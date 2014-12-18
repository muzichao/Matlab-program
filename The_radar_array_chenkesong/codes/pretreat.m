%遗传算法子程序:  遗传操作预处理
function newpop1=pretreat(newpop,popsize,dc,chromlength) %newpop1为预操作之后得到的基因矩阵
%创建约束矩阵
con=ones(popsize,chromlength)-(1-dc);                 %产生popsize行，chromlength=N-2列个相距为dc的矩阵
con=cumsum(con,2);                                    %按行叠加，计算累积和
cons=cat(2,zeros(popsize,1),con,zeros(popsize,1));     %约束矩阵，cat(dim,A,B,C)dim=1表示按列连接，dim=2表示按行连接
newpop1=newpop-cons;