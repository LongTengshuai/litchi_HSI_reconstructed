clear all;
clc
hdrfile='E:\Hyperspectral_recovery\data\XJF\原始数据\header.hdr';
imgDataPath='E:\Hyperspectral_recovery\data\XJF\原始数据\20230707\';
imgDataPath2='E:\Hyperspectral_recovery\data\XJF\mat文件\20230707\';
heibai = xlsread('E:\Hyperspectral_recovery\data\XJF\原始数据\黑白板\heibai.xlsx');

imgDataDir  = dir([imgDataPath '*.raw']); 

for tt=1:100
mkdir([imgDataPath2,imgDataDir(tt).name]);

imagefile=imgDataDir(tt).name;
savefold=[imgDataPath2 imgDataDir(tt).name '\'];

hdrfilename=hdrfile;
imagefilename=[imgDataPath imagefile];
savefolder=savefold;
fid = fopen(hdrfilename,'r');
info = fread(fid,'char=>char');
info=info';%默认读入列向量，须要转置为行向量才适于显示
fclose(fid);
%查找列数
a=strfind(info,'samples = ');
b=length('samples = ');
c=strfind(info,'lines');
samples=[];
for i=a+b:c-1
samples=[samples,info(i)];
end
samples=str2num(samples);
%查找行数
a=strfind(info,'lines = ');
b=length('lines = ');
c=strfind(info,'bands');
lines=[];
for i=a+b:c-1
lines=[lines,info(i)];
end
lines=str2num(lines);
%查找波段数
a=strfind(info,'bands = ');
b=length('bands = ');
c=strfind(info,'header offset');
bands=[];
for i=a+b:c-1
bands=[bands,info(i)];
end
bands=str2num(bands);
%查找波长数目
a=strfind(info,'wavelength = {');
b=length('wavelength = {');
% c=strfind(info,' }');
wavelength=[];
for i=a+b:length(info)
    wavelength=[wavelength,info(i)];
end
wave=sscanf(wavelength,'%f,');
%查找数据类型
a=strfind(info,'data type = ');
b=length('data type = ');
c=strfind(info,'interleave');
datatype=[];
for i=a+b:c-1
datatype=[datatype,info(i)];
end
datatype=str2num(datatype);
precision=[];
switch datatype
case 1
precision='uint8=>uint8';%头文件中datatype=1对应ENVI中数据类型为Byte，对应MATLAB中数据类型为uint8
case 2
precision='int16=>int16';%头文件中datatype=2对应ENVI中数据类型为Integer，对应MATLAB中数据类型为int16
case 12
precision='uint16=>uint16';%头文件中datatype=12对应ENVI中数据类型为Unsighed Int，对应MATLAB中数据类型为uint16
case 3
precision='int32=>int32';%头文件中datatype=3对应ENVI中数据类型为Long Integer，对应MATLAB中数据类型为int32
case 13
precision='uint32=>uint32';%头文件中datatype=13对应ENVI中数据类型为Unsighed Long，对应MATLAB中数据类型为uint32
case 4
precision='float32=>float32';%头文件中datatype=4对应ENVI中数据类型为Floating Point，对应MATLAB中数据类型为float32
case 5
precision='double=>double';%头文件中datatype=5对应ENVI中数据类型为Double Precision，对应MATLAB中数据类型为double
otherwise
error('invalid datatype');%除以上几种常见数据类型之外的数据类型视为无效的数据类型
end
%查找数据格式
a=strfind(info,'interleave = ');
b=length('interleave = ');
c=strfind(info,'sensor type');
interleave=[];
for i=a+b:c-1
interleave=[interleave,info(i)];
end
interleave=strtrim(interleave);%删除字符串中的空格
%读取图像文件
fid = fopen(hdrfilename, 'r');
data = multibandread(imagefilename,[lines samples bands],precision,0,interleave,'ieee-le');
data= double(data);

imagefilename2 = imagefilename(1:end-4);
savefold2 = [imagefilename2 '\4_lunkuo.jpg'];
picppt = imread(savefold2);

t1 = 1;
t2 = 991;
p1 = 1;
p2 = 960;

for t = 1:991
    for p = 1:960
        if picppt(t,p) >= 255
            if t>t1
                t1 = t;
            end
            if p>p1
                p1 = p;
            end
        end
    end
end
            
for t = 991:-1:1
    for p = 960:-1:1
        if picppt(t,p) >= 255
            if t<t2
                t2 = t;
            end
            if p<p2
                p2 = p;
            end
        end
    end
end           
yi = zeros(t1-t2+1,p1-p2+1,176);  
yi2 = zeros(t1-t2+1,p1-p2+1,176);  
yi3 = zeros(t1-t2+1,p1-p2+1,176); 

for i=1:bands

    yi(:,:,i) = data(t2:t1,p2:p1,i)-heibai(i,3);
    er = heibai(i,2)-heibai(i,3);
    yi2(:,:,i) = yi(:,:,i)/er*40000/65535;
    yi3(:,:,i) = yi(:,:,i)/er*5000/65535;
%     imwrite(yi2,save_path);
%     yi = data(:,:,i)-heibai(i,3);
%     er = heibai(i,2)-heibai(i,3);

end
oi = max(max(max(yi2)));
oi2 = max(max(max(yi3)));
save_path=strcat(savefolder,imgDataDir(tt).name,'.mat');
save(save_path, 'yi2');
save_path2=strcat(savefolder,imgDataDir(tt).name,'.bmp');
ppt = yi3(:,:,120);
imwrite(ppt,save_path2);
save_path3=strcat(savefolder,imgDataDir(tt).name,'_2.bmp');
imwrite(picppt(t2:t1,p2:p1),save_path3);
% ppt = data(:,:,56);
% 保存图像
end