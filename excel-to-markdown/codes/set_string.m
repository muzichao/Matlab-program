function out = set_string(str, M, N)
% �ַ������У�����������ӿո�
% Ŀ����Ϊ��ʹÿ��������ַ����ȳ�����
% str:��Ҫ��չ���ַ���
% M:�ַ����ĳ���
% N:ÿ���ַ�������󳤶�

N = N + 2;
new_str = char(N-M);
for i = 1:N-M
    new_str(i)=' ';
end

mid_num = fix((N-M)/2);

out = [new_str(1:mid_num), str, new_str(mid_num+1:end)];

