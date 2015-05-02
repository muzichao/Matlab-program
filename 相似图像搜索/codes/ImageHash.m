function imageHashValue = ImageHash(image)
% ����ͼ�εĹ�ϣֵ������һ��64λ�ַ���
% ���룺image ���� ����ͼ��
% �����imageHashValue �ַ��� ͼ���Ӧ�Ĺ�ϣֵ

hashFingerSize = 8; % ������ϣֵ�ĳ���
if(size(image, 3) == 3)
    image = rgb2gray(image); % rgbתΪ�Ҷ�
end
image = double(imresize(image, [hashFingerSize, hashFingerSize])); % ������С
imageHashValue = image(:) > mean(image(:)); % �����ϣֵ