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

%% д��txt�ļ�
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
