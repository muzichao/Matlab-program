function out = set_align_type(type, N)
% ������Markdown�еĶ����ʽ
% type ��������
%| ------------- | ����� type : 'left'
%|:-------------:| ���ж��� type : ����
%| -------------:| �Ҷ��� type : 'right'

if N == 0
    out = '';
else
    out = char(N);
end

for i = 1:N
    out(i) = '-';
end

if strcmp(type, 'left') == 1 % �����
    out = [' ', out, ' '];
elseif strcmp(type,  'right') == 1 % �Ҷ���
    out = [' ', out, ':'];
else % ����
    out = [':', out, ':'];
end

