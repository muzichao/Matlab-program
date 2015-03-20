function out = set_string(str, M, N)
% 字符串居中，并在两侧添加空格
% 目的是为了使每列输出的字符串等长对齐
% str:需要扩展的字符串
% M:字符串的长度
% N:每列字符串的最大长度

N = N + 2;
new_str = char(N-M);
for i = 1:N-M
    new_str(i)=' ';
end

mid_num = fix((N-M)/2);

out = [new_str(1:mid_num), str, new_str(mid_num+1:end)];

