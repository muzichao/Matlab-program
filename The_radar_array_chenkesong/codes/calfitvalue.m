%遗传算法子程序，计算适应度值
function fitvalue=calfitvalue(SLLmax,popsize)
fitvalue=zeros(popsize,1);
for i=1:popsize
    fitvalue(i)=SLLmax(i);   %fitvalue也是列向量，其实和SLLmax是一样的，相当于赋值
end