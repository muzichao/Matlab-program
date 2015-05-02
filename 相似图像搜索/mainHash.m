% ��ͼ��ͼ
% ����hashָ��
% �ȽϺ�������
% 2015 4 30
% by lichao

clc
clear all
close all

%% ·��
addpath('.\codes\')
addpath('.\data\')
filePath = 'D:\Document\vidpic\pictures\101_ObjectCategories\'; % �ļ�Ŀ¼
fileType = 'jpg'; % �ļ�����

%% ��ȡ·���µ��ļ�
% ��������룬�������ɣ������ظ�����
if(~exist('allFiles.mat', 'file'))
    allFiles = FileInAllOfSubdir(filePath, fileType); % ��ȡָ��Ŀ¼������ָ�����͵��ļ�
    save ('.\data\allFiles.mat', 'allFiles')
else
    load allFiles
end

%% �ֱ����ÿһ��ͼ��Ĺ�ϣֵ
% ��������룬�������ɣ������ظ�����
if(~exist('hashFinger.mat', 'file'))
    hashFinger = cell(size(allFiles, 1), 1);
    for i = 1:size(allFiles, 1)
        image = imread(char(strcat(filePath, allFiles(i))));
        hashFinger(i) = {ImageHash(image)};
    end
    save ('.\data\hashFinger.mat', 'hashFinger')
else
    load hashFinger
end

%% ����Ч��

searchImageIndex = randi([1, size(allFiles, 1)]);
imageSearch = imread(char(strcat(filePath, allFiles(searchImageIndex))));
hashValue = ImageHash(imageSearch);
resultImageIndex = SearchImage(hashFinger, hashValue);




