function out = set_align_type(type, N)
% 设置在Markdown中的对齐格式
% type 对齐类型
%| ------------- | 左对齐 type : 'left'
%|:-------------:| 居中对齐 type : 其他
%| -------------:| 右对齐 type : 'right'

if N == 0
    out = '';
else
    out = char(N);
end

for i = 1:N
    out(i) = '-';
end

if strcmp(type, 'left') == 1 % 左对齐
    out = [' ', out, ' '];
elseif strcmp(type,  'right') == 1 % 右对齐
    out = [' ', out, ':'];
else % 居中
    out = [':', out, ':'];
end

