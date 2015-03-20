function out = length_str_with_chinese(string)
% ȫ���ַ�ռ��������׼�ַ���λ��
% ��matlab��length����ֻ�ж��ַ������������ж�ռ���ַ�λ�õĳ���
% ��ˣ��ַ�����ʵ�ʳ��� = �ַ����� + ȫ���ַ�����

len = length(string);
len_ch = zeros(1,len);
for k = 1:len
    len_ch(k) = is_chinese_str(string(k));
end
out = len + sum(len_ch);
end

function chinese_str = is_chinese_str(ch)
% ����GB2312���ַ�����������ƽʱ��˵����λ����һ�����ֶ�Ӧ�������ֽڡ� ÿ���ֽڶ��Ǵ���A0��ʮ������,��160����
% ��������һ���ֽڴ���A0�����ڶ����ֽ�С��A0����ô��Ӧ�����Ǻ��֣���������GB2312)
info = unicode2native(ch,'GB2312');
bytes = size(info,2);
chinese_str = 0;
if (bytes == 2)
    if(info(1)>160 & info(2)>160)
        chinese_str = 1;
    end
end
end