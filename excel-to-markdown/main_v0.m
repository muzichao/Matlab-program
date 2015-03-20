% Markdown�������
% | Tables        | Are           | Cool  |
% | ------------- |:-------------:| -----:|
% | col 3 is      | right-aligned | $1600 |
% | col 2 is      | centered      |   $12 |
% | zebra stripes | are neat      |    $1 |

% ����� align_type : 'left'
% ���ж��� align_type : ����
% �Ҷ��� align_type : 'right'

clc
clear all
close all

addpath('.\codes\')
%% ���뷽ʽ
align_type = 'mid';
%% ��������
[NUM,TXT,RAW] = xlsread('.\input\excel');

[row, col] = size(TXT);
out = struct();

%% ��ÿ���ı��ĳ���
% TXT_length = zeros(row, col);
% for i = 1:row
%     for j = 1:col
%         TXT_length(i, j) = length_str_with_chinese(TXT{i,j});
%     end
% end
TXT_length = cellfun(@length_str_with_chinese,TXT);
%% ��ÿһ���ı������ֵ
max_col_length = max(TXT_length);

%% ���'|'
for i = 1:row+1
    for j = 1:col
        out.data{i,2*j-1} = '|';
    end
    out.data{i, 2*col+1} = '|';
end

%% ����ı�
for i = 1:row
    for j = 1:col
        out.data{i+(i>1),2*j} = set_string(TXT{i,j},TXT_length(i,j), max_col_length(j));
    end
end

%% ��ӵڶ��еĶ��뷽ʽ
for j = 1:col
    out.data{2, 2*j} = set_align_type(align_type, max_col_length(j));
end
%% д��txt�ļ�
fp = fopen('.\output\Markdown_table.txt','w');

for i = 1:row+1
    table = '';
    for j = 1:2*col+1
        table = [table, out.data{i, j}];
    end
    fprintf(fp,'%s\n',table);
end
fclose(fp);
