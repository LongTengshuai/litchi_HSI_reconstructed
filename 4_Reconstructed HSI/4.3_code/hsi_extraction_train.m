clear all;
clc

% 定义源文件夹和目标文件夹路径
source_folder = 'E:\Hyperspectral_recovery\data\XJF\mat\result_重建数据\ROI区域\';  % 替换为你的源文件夹路径
target_folder = 'E:\Hyperspectral_recovery\data\XJF\mat\result_重建数据\hrnt\';  % 替换为目标文件夹路径
target_folder2 = 'E:\Hyperspectral_recovery\data\XJF\mat\result_重建数据\hrnt\result\all\';  % 替换为目标文件夹路径

qwer = [];
% 遍历图像编号范围：001 到 740
for img_num = 1:840
    % 构造完整的图像文件名
    img_name = sprintf('%04dre.mat', img_num);  
    img_name2 = sprintf('%04d', img_num);  
    
    source_file_path = [target_folder '\' img_name];
    source_file_path2 = [source_folder img_name2 '\' img_name2 '_2.bmp'];
    source_file_path3 = [target_folder2 img_name2 '.xlsx'];
    
    img2 = [];
    img4 = imread(source_file_path2);

    % 读取图像
    img3 = load(source_file_path);
    img = img3.cube;
    % 获取图像尺寸
    [height, width, ~] = size(img);
    filtered_spectra = [];
    chunk_size = 1000;      % 每隔 1000 个点计算一次平均值
    chunk_means = [];       % 用于存储每个 chunk 的平均值
    
    % 遍历ROI区域的每个像素
    for x = 1:height
        for y = 1:width
            % 获取当前像素的值
            pixel_value = img4(x, y);

            % 如果像素值小于10，保存对应的光谱数据
            if pixel_value > 128
                % 获取光谱数据
                spectrum = img(x, y, :);
                filtered_spectra = [filtered_spectra, spectrum];
            end
            % 每当收集到 1000 个光谱数据时，计算平均值
            if mod(numel(filtered_spectra) / size(img, 3), chunk_size) == 0 && ~isempty(filtered_spectra)
                % 转置矩阵以方便计算
                chunk_data = permute(filtered_spectra, [3, 1, 2]);
                % 计算当前 chunk 的平均光谱
                chunk_mean = mean(chunk_data, 3);
                % 将当前 chunk 的平均值存储起来
                chunk_means = [chunk_means, chunk_mean];
                % 清空当前 chunk 的数据
                filtered_spectra = [];
            end
        end
    end

    % 如果最后还有剩余的光谱数据，计算其平均值
    if ~isempty(filtered_spectra)
        % 转置矩阵以方便计算
        chunk_data = permute(filtered_spectra, [3, 1, 2]);
        % 计算剩余数据的平均光谱
        chunk_mean = mean(chunk_data, 3);
        % 将剩余数据的平均值存储起来
        chunk_means = [chunk_means, chunk_mean];
    end

    % 如果有符合条件的 chunk 平均值，计算总平均值
    if ~isempty(chunk_means)
        % 转置矩阵以方便计算
        chunk_means = permute(chunk_means, [3, 1, 2]);
        % 计算总平均光谱
        total_mean_spectrum = mean(chunk_means, 3);
        % 将总平均光谱保存到 Excel 文件
        writematrix(total_mean_spectrum, source_file_path3);
    else
        error('没有找到符合条件的像素值');
    end
end

% 设置目标文件夹路径
target_folder = 'E:\Hyperspectral_recovery\data\XJF\mat\result_重建数据\restormer\result\all\';
target_folder3 = 'E:\Hyperspectral_recovery\data\XJF\mat\result_重建数据\restormer\result\';

% 获取文件夹中的所有Excel文件
files = dir(fullfile(target_folder, '*.xlsx')); % 假设所有文件都是.xlsx格式
num_files = length(files);

% 初始化一个空的表格
combined_table = [];

% 遍历所有文件
for i = 1:num_files
    % 获取文件名
    file_name = fullfile(target_folder, files(i).name);
    
    % 读取Excel文件
    data = readtable(file_name);
    
    % 将数据追加到combined_table中
    combined_table = [combined_table; data];
end

% 将合并后的数据保存为一个新的Excel文件
output_file = fullfile(target_folder3, 'combined_train.xlsx');
writetable(combined_table, output_file);

disp(['所有Excel文件已合并并保存为 ', output_file]);



