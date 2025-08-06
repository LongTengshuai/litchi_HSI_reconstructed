function error = objective_function(M, xyz_data, actual_rgb)
    % 将 M 转换为 3x3 矩阵
    M = reshape(M, [3, 3]);
    
    % 计算变换后的 RGB 图像
    sRGB =  M * xyz_data;
    % do minor thresholding
    thresholdRGB = 0.0005;  
    % Correct gamma 
    gamma_map = (sRGB >  0.0031308);
    sRGB(gamma_map) = 1.055 * power(sRGB(gamma_map), (1. / 2.4)) - 0.055;
    sRGB(~gamma_map) = 12.92*sRGB(~gamma_map);
    sRGB(sRGB>1)=1;
    sRGB(sRGB<0)=0;

    if (thresholdRGB>0)
    thres=thresholdRGB;

    for idx=1:3
        y=sRGB(idx,:);
        [a,b]=hist(y(y>0),100);
        a=cumsum(a)/sum(a);
        th=b(1);
        i=find(a<thres);
        if ~isempty(i)
        th=b(i(end));
        end
        y=max(0,y-th);


        [a,b]=hist(y,100);
        a=cumsum(a)/sum(a);    
        i=find(a>1-thres);
        th=b(i(1));
        y(y>th)=th;
        y=y./th;
        sRGB(idx,:)=y;
    end
    end
    
    % 计算 RGB 通道之间的差值的平方和
    error = sum((sRGB - actual_rgb).^2, 'all'); % 使用均方误差
end