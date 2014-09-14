%遗传算法子程序：交叉运算(单点交叉)
function newpop2=crossover(newpop1,popsize,pc0,N)
for i=1:2:popsize-1
    if rand<pc0                      %交叉规则，只有随机数小于交叉概率才可以进行交叉
        cpoint=round(rand*(N-3)+2);  %产生交叉位置，位于[2，N-1]区间
        newpop2(i,:)=[newpop1(i,1:cpoint),newpop1(i+1,cpoint+1:N)];   %单点交叉，交换数据
        newpop2(i,:)=sort(newpop2(i,:),2);                            %对交叉后的基因矩阵进行按行排列，元素从小到大
        newpop2(i+1,:)=[newpop1(i+1,1:cpoint),newpop1(i,cpoint+1:N)];
        newpop2(i+1,:)=sort(newpop2(i+1,:),2);
    else
        newpop2(i,:)=newpop1(i,:);%不满足交叉条件，不进行交叉
        newpop2(i,:)=sort(newpop2(i,:),2);
        newpop2(i+1,:)=newpop1(i+1,:);
        newpop2(i+1,:)=sort(newpop2(i+1,:),2);
    end
end


%也可以利用算数交叉，下面是简要的说明，a是某一个参数
%for i=1:2:popsize-1
%    if rand<pc 
 %       newpop2(i,:)=a*newpop1(i,:)+(1-a)*newpop1(i+1,:);
  %      newpop2(i,:)=sort(newpop2(i,:),2); 
   %     newpop2(i+1,:)=a*newpop1(i+1,:)+ a*newpop1(i,:);
    %    newpop2(i+1,:)=sort(newpop2(i+1,:),2);
     %else
      %  newpop2(i,:)=newpop1(i,:);
       % newpop2(i,:)=sort(newpop2(i,:),2);
        %newpop2(i+1,:)=newpop1(i+1,:);
        %newpop2(i+1,:)=sort(newpop2(i+1,:),2)
    %end
%end
% pc也可以随着进化时间而变化