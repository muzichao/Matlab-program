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

%% 写入txt文件
fp = fopen('.\output\Markdown_table.txt','w');

for i = 1:row+1
    table = '| ';
    for j = 1:col
        if i ==2
            table = [table, set_align_type(align_type, 4), ' |'];
        else
            table = [table, TXT{i-(i>1), j}, ' |'];
        end
    end
    fprintf(fp,'%s\n',table);
end
fclose(fp);
