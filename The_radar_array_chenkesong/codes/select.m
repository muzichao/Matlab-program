%�Ŵ��㷨�ӳ��򣬽������̶�ѡ�������̶�֮ǰ����������Ⱦɫ��������Ⱦɫ�壬Ȼ��������̶ģ�
function newpop=select(fitvalue,popsize,pop)  %newpopΪ�������̶�ѡ��֮����µ���Ⱥ
[minvalue,index1]=min(fitvalue); %�����ǰ��Ⱥ�����Ž⣬����������ڵ�����
[maxvalue,index2]=max(fitvalue); %�����ǰ��Ⱥ����ν⣬�������������
pop(index2,:)=pop(index1,:);     %������Ⱦɫ��������Ⱦɫ�壬�������̶�ѡ��
fitscore=fitvalue/sum(fitvalue); %������屻ѡ�еĸ���,����fitvalueΪ��ֵ�����fitscoreԽ��fitvalueԽС��Ҳ����˵��ֵ�԰��ƽԽС��Խ�����Ž�
fitscore=cumsum(fitscore);        %Ⱥ���и�����ۻ�����
wh=sort(rand(popsize,1));    %����[0,1]�����ϵ������wh������С��������
wheel=1;
fitone=1;
while wheel<=popsize   %ִ�����̶�ѡ�����
    if wh(wheel)<fitscore(fitone)
        newpop(wheel,:)=pop(fitone,:);
        wheel=wheel+1;
    else
        fitone=fitone+1;
    end
end