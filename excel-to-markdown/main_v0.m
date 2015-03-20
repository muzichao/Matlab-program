% Markdown表格生成
% | Tables        | Are           | Cool  |
% | ------------- |:-------------:| -----:|
% | col 3 is      | right-aligned | $1600 |
% | col 2 is      | centered      |   $12 |
% | zebra stripes | are neat      |    $1 |

% 左对齐 align_type : 'left'
% 居中对齐 align_type : 其他
% 右对齐 align_type : 'right'

clc
clear all
close all

addpath('.\codes\')
%% 对齐方式
align_type = 'mid';
%% 读入数据
[NUM,TXT,RAW] = xlsread('.\input\excel');

[row, col] = size(TXT);
out = struct();

%% 求每个文本的长度
% TXT_length = zeros(row, col);
% for i = 1:row
%     for j = 1:col
%         TXT_length(i, j) = length_str_with_chinese(TXT{i,j});
%     end
% end
TXT_length = cellfun(@length_str_with_chinese,TXT);
%% 求每一列文本的最大值
max_col_length = max(TXT_length);

%% 添加'|'
for i = 1:row+1
    for j = 1:col
        out.data{i,2*j-1} = '|';
    end
    out.data{i, 2*col+1} = '|';
end

%% 添加文本
for i = 1:row
    for j = 1:col
        out.data{i+(i>1),2*j} = set_string(TXT{i,j},TXT_length(i,j), max_col_length(j));
    end
end

%% 添加第二行的对齐方式
for j = 1:col
    out.data{2, 2*j} = set_align_type(align_type, max_col_length(j));
end
%% 写入txt文件
fp = fopen('.\output\Markdown_table.txt','w');

for i = 1:row+1
    table = '';
    for j = 1:2*col+1
        table = [table, out.data{i, j}];
    end
    fprintf(fp,'%s\n',table);
end
fclose(fp);
