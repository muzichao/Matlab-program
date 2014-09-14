%遗传算法子程序，计算目标函数值的大小
function [SLLmax,Elog]=calobjvalue(pop,popsize,N,u,res)
E=zeros(popsize,length(u)); %E为阵元无方向性时的方向性函数，也即是阵因子
FFmax=zeros(popsize,1);     %用于保存主瓣峰值
index=zeros(popsize,1);     %用于保存主瓣峰值所在的位置
for m=1:popsize        
    for n=1:N
        E(m,:)=E(m,:)+exp(j*2*pi*u*pop(m,n)); %计算目标函数
    end
    E(m,:)=abs(E(m,:));                      %适应度函数都是非负的，且是为了下面的对数用算
    Elog(m,:)=20*log10(E(m,:)/max(E(m,:)));  %以分贝数来表示,其中log10表示以10为底的对数
    [FFmax(m),index(m)]=max(Elog(m,:));      %求出主瓣位置并保存
end
%求出最大旁瓣
for i=1:popsize
    for n=index(i):res             %用于求出最靠近主瓣右边的凹陷点的位置
        if Elog(i,n)>Elog(i,n+1)     
            continue
        end
        if Elog(i,n)<Elog(i,n+1)
            brk1=n;
            break
        end
    end
    for m=index(i):-1:2           %用于求出最靠近主瓣左边的凹陷点的位置
        if Elog(i,m)>Elog(i,m-1)
            continue
        end
        if Elog(i,m)<Elog(i,m-1)
            brk2=m;
            break
        end
    end
    SLL1=Elog(i,brk1:res);    %右边除去主瓣所在区域的旁瓣值集合
    SLL2=Elog(i,1:brk2);      %左边除去主瓣所在区域的旁瓣值集合   
    SLLmax(i)=max([SLL1,SLL2]);%求出最大的峰值旁瓣
end
SLLmax=SLLmax';   %此时得到的SLLmax为列向量  
