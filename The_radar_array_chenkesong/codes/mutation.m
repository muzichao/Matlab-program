  %遗传算法子程序：变异运算
function newpop3=mutation(newpop2,popsize,pm0,N,SP)
newpop3=newpop2;
for i=1:popsize
   if (rand<pm0)        %变异规则，只有随机数小于变异概率才进行变异操作
        mpoint=round(rand*(N-3)+2); %产生变异位置，位置区间为[2,N-1]
        newpop3(i,mpoint)=rand*SP;  %变异位置上的元素用[0,SP]区间上的随机数代替
        newpop3(i,:)=sort(newpop3(i,:),2); %将变异后的基因矩阵 按行 从小到大排序
    else
        newpop3(i,:)=newpop2(i,:);
    end
end
%也可以使pm随着进化代数的变化逐渐增大，有利于跳出局部最优
%for i=1:popsize
%pm=pm0+(0.05-pm0)*i/popsize