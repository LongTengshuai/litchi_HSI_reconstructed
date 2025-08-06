clear all;
clc

% 定义源文件夹和目标文件夹路径
source_folder = 'E:\Hyperspectral_recovery\data\XJF\mat\test\';  % 替换为你的源文件夹路径
target_folder = 'E:\Hyperspectral_recovery\data\XJF\mat\Test_RGB';  % 替换为目标文件夹路径

% imgDataDir  = dir([source_folder '*']); 

% 定义裁剪尺寸
crop_size = [128, 128, 3];  % 高、宽、通道数
qwer = [];

% 遍历图像编号范围：001 到 740
for img_num = 841:1050
    % 构造完整的图像文件名
    img_name = sprintf('%04d_3.bmp', img_num);  % 格式化为三位数字，例如 001_3.bmp
    img_name2 = sprintf('%04d', img_num);  % 格式化为三位数字，例如 001_3.bmp
    
    source_file_path = [source_folder img_name2 '\' img_name];
    source_file_path2 = [source_folder img_name2 '\' img_name2 '_2.bmp'];
    
    img2 = [];
    img4 = imread(source_file_path2);
    % 检查图像文件是否存在
    if exist(source_file_path, 'file')
        % 读取图像
        img = imread(source_file_path);
        
        % 获取图像尺寸
        [height, width, ~] = size(img);
        
        % 计算可以裁剪的块数
        num_blocks_x = ceil(width / crop_size(2));
        num_blocks_y = ceil(height / crop_size(1));
        
        for qx = 1:height
            for qy = 1:width
                for qz = 1:3
                    if img4(qx,qy) < 128
                        img(qx,qy,qz) = 0;
                    end
                end
            end
        end
        
        % 如果图像尺寸不足，通过镜像补充
        if width < crop_size(2) * num_blocks_x
            % 从左侧镜像补充
            img(:, 128*num_blocks_x-128+1:128*num_blocks_x, :) = img(:, width-128+1:width, :);
        end
        
        if height < crop_size(1) * num_blocks_y
            % 从上方镜像补充
            img(128*num_blocks_y-128+1:128*num_blocks_y, :, :) = img(height-128+1:height, :, :);
        end
        
        % 裁剪图像并保存
        for i = 1:num_blocks_y
            for j = 1:num_blocks_x
                % 计算裁剪区域
                y_start = (i-1) * crop_size(1) + 1;
                y_end = i * crop_size(1);
                x_start = (j-1) * crop_size(2) + 1;
                x_end = j * crop_size(2);
                
                % 裁剪图像块
                cropped_img = img(y_start:y_end, x_start:x_end, :);
                
                % 构造目标文件路径
                cropped_img_name = sprintf('%s_%02d.jpg', img_name(1:end-6), (i-1)*num_blocks_x+j);  % 去掉原始文件名的扩展名
                target_file_path = fullfile(target_folder, cropped_img_name);
                
                % 保存裁剪后的图像块
                imwrite(cropped_img, target_file_path);
            end
        end
    else
        warning('图像文件不存在: %s', source_file_path);

    end
end

disp('图像裁剪完成！');