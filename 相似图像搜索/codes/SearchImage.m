function resultImageIndex = SearchImage(hashFinger, hashValue)
% ���ݹ�ϣֵ����ͼ��
% ���룺hashFinger cell���� ����ͼ���
% ���룺hashValue ��ϣֵ ������ͼ��Ĺ�ϣֵ
% �����resultImageIndex ���� ƥ��ͼ�������
resultImageIndex = [];
threshold = 1; % ƥ����ֵ����ϣֵ�в�ƥ����С�ڵ�����ֵ����Ϊ����
for i = 1:size(hashFinger, 1)
    if(sum(sum(bitxor(hashFinger{i, 1}, hashValue)))  <= threshold)
        resultImageIndex = cat(1, resultImageIndex, i);
    end
end
    