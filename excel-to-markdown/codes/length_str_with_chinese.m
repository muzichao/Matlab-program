function out = length_str_with_chinese(string)
% 全角字符占用两个标准字符的位置
% 而matlab的length函数只判断字符个数，不是判断占据字符位置的长度
% 因此，字符串的实际长度 = 字符个数 + 全角字符个数

len = length(string);
len_ch = zeros(1,len);
for k = 1:len
    len_ch(k) = is_chinese_str(string(k));
end
out = len + sum(len_ch);
end

function chinese_str = is_chinese_str(ch)
% 对于GB2312的字符（就是我们平时所说的区位），一个汉字对应于两个字节。 每个字节都是大于A0（十六进制,即160），
% 倘若，第一个字节大于A0，而第二个字节小于A0，那么它应当不是汉字（仅仅对于GB2312)
info = unicode2native(ch,'GB2312');
bytes = size(info,2);
chinese_str = 0;
if (bytes == 2)
    if(info(1)>160 & info(2)>160)
        chinese_str = 1;
    end
end
end