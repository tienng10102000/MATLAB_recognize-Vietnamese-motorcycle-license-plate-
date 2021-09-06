old_dir=cd;% luu thu muc lam viec hien tai
dirName=old_dir;
if exist('b.mat','file')
    load b.mat
        [fNames, dirName] = uigetfile(...
        {'*.bmp;*.tif;*.jpg;*.tiff;*.png'},...
        'Chon Anh',...
        dirName,...
        'MultiSelect','on');
else
    [fNames, dirName] = uigetfile('*.bmp;*.tif;*.jpg;*.tiff;*.png',...
        'MultiSelect','on');
end

if dirName~=0
    save('b.mat','dirName');
end
cd(dirName); % chuyen den thu muc duoc chon
n=length(fNames); % so luong doi tuong duoc chon
numbers=cell(n,2);
for i=1:n
    a=imread(fNames{i});
    a=im2bw(a);
    numbers{i,1}=a;
    numbers{i,2}=fNames{i}(1);
end
cd(old_dir); % tro ve thu muc lam viec cu
clear a dirName fNames i n old_dir
