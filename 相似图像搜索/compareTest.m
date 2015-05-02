% ����hash��phash��dhash��Ч��
% ���д˲���֮ǰ�������� mainHash.m��mainpHash.m��maindHash.m��������Ӧָ��

clc
clear all
close all

%% ·��
addpath('.\codes\')
addpath('.\data\')
filePath = 'D:\Document\vidpic\pictures\101_ObjectCategories\'; % �ļ�Ŀ¼
fileType = 'jpg'; % �ļ�����

load allFiles

%% �����������ֵ
% ��������룬�������ɣ������ظ�����
testSize = 1000; % ����ͼ�����
if(~exist('searchImageIndex.mat', 'file'))
    searchImageIndex = unique(sort(randi(size(allFiles, 1), [1, testSize]))); % �������ظ������
    save('.\data\searchImageIndex.mat', 'searchImageIndex')
else
    load searchImageIndex
end

testSize = size(searchImageIndex, 2);
resultImageIndex = cell(testSize, 4);
resultImageIndex(:, 1) = num2cell(searchImageIndex'); % ��һ��Ϊ��������
%% hash

load hashFinger

for i = 1:testSize
    hashValue = ImageHash(imread(char(strcat(filePath, allFiles(searchImageIndex(i))))));
    resultImageIndex(i, 2) = {SearchImage(hashFinger, hashValue)}; % �ڶ���Ϊ hash ���
end

%% phash

load phashFinger

for i = 1:testSize
    hashValue = ImagePHash(imread(char(strcat(filePath, allFiles(searchImageIndex(i))))));
    resultImageIndex(i, 3) = {SearchImage(hashFinger, hashValue)}; % ������Ϊ phash ���
end
%% dhash

load dhashFinger

for i = 1:testSize
    hashValue = ImageDHash(imread(char(strcat(filePath, allFiles(searchImageIndex(i))))));
    resultImageIndex(i, 4) = {SearchImage(hashFinger, hashValue)}; % ������Ϊ dhash ���
end

%% ��ѡ��һ�����������

differentSearchResult = cell(0);

for i = 1:testSize
   if(~(size(resultImageIndex{i, 2}, 1) == size(resultImageIndex{i, 3}, 1) && size(resultImageIndex{i, 2}, 1) == size(resultImageIndex{i, 4}, 1))) 
       differentSearchResult = cat(1, differentSearchResult, resultImageIndex(i, :));
   end
end