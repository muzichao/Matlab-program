%�Ŵ��㷨�ӳ��򣬼���Ŀ�꺯��ֵ�Ĵ�С
function [SLLmax,Elog]=calobjvalue(pop,popsize,N,u,res)
E=zeros(popsize,length(u)); %EΪ��Ԫ�޷�����ʱ�ķ����Ժ�����Ҳ����������
FFmax=zeros(popsize,1);     %���ڱ��������ֵ
index=zeros(popsize,1);     %���ڱ��������ֵ���ڵ�λ��
for m=1:popsize        
    for n=1:N
        E(m,:)=E(m,:)+exp(j*2*pi*u*pop(m,n)); %����Ŀ�꺯��
    end
    E(m,:)=abs(E(m,:));                      %��Ӧ�Ⱥ������ǷǸ��ģ�����Ϊ������Ķ�������
    Elog(m,:)=20*log10(E(m,:)/max(E(m,:)));  %�Էֱ�������ʾ,����log10��ʾ��10Ϊ�׵Ķ���
    [FFmax(m),index(m)]=max(Elog(m,:));      %�������λ�ò�����
end
%�������԰�
for i=1:popsize
    for n=index(i):res             %���������������ұߵİ��ݵ��λ��
        if Elog(i,n)>Elog(i,n+1)     
            continue
        end
        if Elog(i,n)<Elog(i,n+1)
            brk1=n;
            break
        end
    end
    for m=index(i):-1:2           %����������������ߵİ��ݵ��λ��
        if Elog(i,m)>Elog(i,m-1)
            continue
        end
        if Elog(i,m)<Elog(i,m-1)
            brk2=m;
            break
        end
    end
    SLL1=Elog(i,brk1:res);    %�ұ߳�ȥ��������������԰�ֵ����
    SLL2=Elog(i,1:brk2);      %��߳�ȥ��������������԰�ֵ����   
    SLLmax(i)=max([SLL1,SLL2]);%������ķ�ֵ�԰�
end
SLLmax=SLLmax';   %��ʱ�õ���SLLmaxΪ������  
