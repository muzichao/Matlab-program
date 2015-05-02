function imageHashValue = ImageHash(image)
% 计算图形的哈希值，返回一个64位字符串
% 输入：image 矩阵 输入图像
% 输出：imageHashValue 字符串 图像对应的哈希值

hashFingerSize = 8; % 决定哈希值的长度
if(size(image, 3) == 3)
    image = rgb2gray(image); % rgb转为灰度
end
image = double(imresize(image, [hashFingerSize, hashFingerSize])); % 调整大小
imageHashValue = image(:) > mean(image(:)); % 计算哈希值