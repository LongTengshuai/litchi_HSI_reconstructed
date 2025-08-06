clear all;
clc

% 定义源文件夹和目标文件夹路径
source_folder = 'E:\Hyperspectral_recovery\data\XJF\mat\result_重建数据\6_ours\';  % 替换为你的源文件夹路径
source_folder2 = 'E:\Hyperspectral_recovery\data\XJF\mat\result_原始数据\';  % 替换为你的源文件夹路径
target_folder = 'E:\Hyperspectral_recovery\data\XJF\mat\result_重建数据\re\6_ours';  % 替换为目标文件夹路径

% imgDataDir  = dir([source_folder '*']); 

qwer = [];
% 遍历图像编号范围：001 到 740
for img_num = 1:200
    % 构造完整的图像文件名
    img_name = sprintf('%04dre.mat', img_num);  % 格式化为三位数字，例如 001_3.bmp
    img_name2 = sprintf('%04d', img_num);  % 格式化为三位数字，例如 001_3.bmp
    
    source_file_path = [source_folder '\' img_name];
    source_file_path2 = [source_folder2 img_name2 '\' img_name2 '_2.bmp'];
    
    img2 = [];
    img4 = imread(source_file_path2);
%     img4 = img3.yi2;
    % 检查图像文件是否存在
    if exist(source_file_path, 'file')
        % 读取图像
        img3 = load(source_file_path);
        img = img3.cube;
        % 获取图像尺寸
        [height, width, ~] = size(img);
        
        for qx = 1:height
            for qy = 1:width
                for qz = 1:106
                    if img4(qx,qy) < 128
                        img(qx,qy,qz) = 0;
                    end
                end
            end
        end
                
        % 裁剪图像块
        cropped_img1 = img(:, :, :);
        cropped_img2 = [];
        for i1 =1:height
            for j1 = 1:width
                A_1D = reshape(cropped_img1(i1,j1,:), [], 1);
                smoothed_y = smooth(A_1D, 5, 'moving'); % 使用移动平均，窗口大小为10
                yy = smoothed_y(1:106);
                for t = 1:106
                    if yy(t) <0
                        yy(t) = 0;
                    end
                end
                cropped_img2(i1,j1,:) = yy;
            end
        end

        A_max=max(max(max(cropped_img2)));
        A_min=min(min(min(cropped_img2)));

        % 最小-最大归一化
        cropped_img = (cropped_img2 - A_min) / (A_max - A_min);
        A_max2=max(max(max(cropped_img)));
        A_min2=min(min(min(cropped_img)));

        qwer(1,img_num) = A_max2;
        qwer(2,img_num) = A_min2;
%                 cropped_img = cropped_img2;

        % 构造目标文件路径
        cropped_img_name = sprintf('%s.mat', img_name2);  % 去掉原始文件名的扩展名
        target_file_path = [target_folder '\' cropped_img_name];
        save(target_file_path,'cropped_img');
    end
end