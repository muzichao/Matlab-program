function imageHashValue = ImageDHash(image)
% ����ͼ�εĹ�ϣֵ������һ��64λ�ַ���
% ���룺image ���� ����ͼ��
% �����imageHashValue �ַ��� ͼ���Ӧ�Ĺ�ϣֵ

hashFingerSize = 8; % ������ϣֵ�ĳ���
if(size(image, 3) == 3)
    image = rgb2gray(image); % rgbתΪ�Ҷ�
end
image = double(imresize(image, [hashFingerSize+1, hashFingerSize])); % ������С
imageHashValue = image(1:hashFingerSize, :) > image(2:hashFingerSize+1, :); % �����ϣֵ
imageHashValue = imageHashValue(:);