function imageHashValue = ImagePHash(image)
% ����ͼ�εĹ�ϣֵ������һ��64λ�ַ���
% ���룺image ���� ����ͼ��
% �����imageHashValue �ַ��� ͼ���Ӧ�Ĺ�ϣֵ

hashFingerSize = 8; % ������ϣֵ�ĳ���
dctSize = 32; % DCT �任�����С
if(size(image, 3) == 3)
    image = rgb2gray(image); % rgbתΪ�Ҷ�
end
image = dct2(double(imresize(image, [dctSize, dctSize]))); % ������С������DCT�任
image = image(1:hashFingerSize, 1:hashFingerSize); % ȡ���ϵĵ�Ƶ����
image = log(abs(image)); % ȡ����
imageHashValue = image(:) > mean(image(:)); % �����ϣֵ