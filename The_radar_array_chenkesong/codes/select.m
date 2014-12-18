%遗传算法子程序，进行轮盘赌选择（在轮盘赌之前，利用最优染色体代替最次染色体，然后参与轮盘赌）
function newpop=select(fitvalue,popsize,pop)  %newpop为经过轮盘赌选择之后的新的种群
[minvalue,index1]=min(fitvalue); %求出当前种群中最优解，并求出其所在的行数
[maxvalue,index2]=max(fitvalue); %求出当前种群中最次解，求出其所在行数
pop(index2,:)=pop(index1,:);     %将最优染色体代替最次染色体，参与轮盘赌选择
fitscore=fitvalue/sum(fitvalue); %计算个体被选中的概率,由于fitvalue为负值，因此fitscore越大，fitvalue越小，也就是说峰值旁瓣电平越小，越是最优解
fitscore=cumsum(fitscore);        %群体中个体的累积概率
wh=sort(rand(popsize,1));    %生成[0,1]区间上的随机数wh，并从小到大排列
wheel=1;
fitone=1;
while wheel<=popsize   %执行轮盘赌选择操作
    if wh(wheel)<fitscore(fitone)
        newpop(wheel,:)=pop(fitone,:);
        wheel=wheel+1;
    else
        fitone=fitone+1;
    end
end