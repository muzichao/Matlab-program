function allFiles = FileInAllOfSubdir(filePath, fileType)
% ���ã���ȡָ���ļ����µ��������ļ�����ָ�����͵��ļ�
% ���룺filePath �ַ��� �ļ�·��
% ���룺fileType �ַ��� �ļ�����
% �����allFiles �ַ������� ���ļ�·��+�ļ���

allFiles = cell(0);
subdir = dir(filePath); % ��ȡ filePath �µ������ļ����ļ���
isSubdir = [subdir(:).isdir]; % ����Ƿ����ļ���
subFoldNames = {subdir(isSubdir).name}'; % ɾ�����ļ���  
subFoldNames(ismember(subFoldNames, {'.','..'})) = []; % ɾ�� '.' �� '..' ��Ŀ¼

for i = 1:size(subFoldNames, 1) % ����������Ŀ¼
    subdirName = fullfile(filePath, subFoldNames(i)); % ·��
    allFilesOfSubdir = dir([subdirName{1}, '\*.', fileType]); % ��ǰ��Ŀ¼����ָ�������ļ�
    addSubdirName = repmat(strcat(subFoldNames(i), {'\'}), length(allFilesOfSubdir), 1); % ������Ŀ¼·��
    allFiles = cat(1, allFiles, strcat(addSubdirName, cat(1, {}, allFilesOfSubdir.name))); % Ϊ�ҵ����ļ������Ŀ¼·��
end