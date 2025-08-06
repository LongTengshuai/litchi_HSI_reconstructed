clear all;
clc
po1 = 0;
po2 = 0;
po12 = 0;
po22 = 0;
% 定义.mat文件的路径和文件名
for po = 51:205
    filename1 = ['E:\Hyperspectral_recovery\data\XJF\mat文件\20230712\' num2str(po) '-1.raw\'];
    filename2 = [num2str(po) '-1.raw.mat'];
    filename3 = [num2str(po) '-1.bmp'];
    filename4 = [num2str(po) '-1_1.bmp'];
    filename5 = [filename1 filename2];
    filename6 = [filename1 filename3];
    filename7 = [filename1 filename4];

    pic = ['E:\Hyperspectral_recovery\data\XJF\RGB\' num2str(po) '\' num2str(po) '-1.bmp'];


    % 使用load函数读取.mat文件
    data = load(filename5);
    Q = data.yi2;

    % Y holds the HSI (uint8 to save space)
    % wl holds the wavelengths of the spectral bands
    % The image is 307x307 pixels
    % The illuminant used is D65
    wI = [402.60,405.80,408.90,412.10,415.20,418.40,421.60,424.70,427.90,...
    431.10,434.20,437.40,440.60,443.80,447.00,450.20,453.40,456.60,459.80,463.00,...
    466.20,469.40,472.60,475.80,479.00,482.30,485.50,488.70,492.00,495.20,498.50,...
    501.70,505.00,508.20,511.50,514.70,518.00,521.30,524.50,527.80,531.10,534.40,...
    537.70,540.90,544.20,547.50,550.80,554.10,557.40,560.70,564.10,567.40,570.70,...
    574.00,577.30,580.70,584.00,587.40,590.70,594.00,597.40,600.70,604.10,607.40,...
    610.80,614.20,617.50,620.90,624.30,627.70,631.10,634.40,637.80,641.20,644.60,...
    648.00,651.40,654.80,658.20,661.70,665.10,668.50,671.90,675.30,678.80,682.20,...
    685.60,689.10,692.50,696.00,699.40,702.90,706.30,709.80,713.30,716.70,720.20,...
    723.70,727.20,730.60,734.10,737.60,741.10,744.60,748.10,751.60,755.10,758.60,...
    762.20,765.70,769.20,772.70,776.20,779.80,783.30,786.80,790.40,793.90,797.50,...
    801.00,804.60,808.10,811.70,815.30,818.80,822.40,826.00,829.60,833.20,836.70,...
    840.30,843.90,847.50,851.10,854.70,858.30,861.90,865.60,869.20,872.80,876.40,...
    880.10,883.70,887.30,891.00,894.60,898.20,901.90,905.50,909.20,912.90,916.50,...
    920.20,923.90,927.50,931.20,934.90,938.60,942.30,946.00,949.60,953.30,957.00,...
    960.70,964.50,968.20,971.90,975.60,979.30,983.00,986.80,990.50,994.20,998.00,...
    1001.70,1005.50];

    % load data and convert to double
    Q=double(Q)/1000;
    [ydim,xdim,zdim]=size(Q);
    E = [];
    % reorder data so that each column holds the spectra of of one pixel
    for i=1:zdim
        e=Q(:,:,i);e=e(:);
        E(:,i)=e;
    end

    Y = E;


    %Create the RBG image, 
    data = xlsread('E:\Hyperspectral_recovery\HSI2RGB\溴钨灯功率.xls');
    data2 = xlsread('E:\Hyperspectral_recovery\1_相机标定\2_RGB相机响应曲线\相机CCD响应曲线.xlsx');

    I = data(:,9);
    wY = data(:,8);

    I2 = interp1(wY,I,wI,'pchip','extrap')';

    wY2 = data2(:,1);
    I3  = data2(:,2);
    I31 = data2(:,3);
    I32 = data2(:,4);

    I4 = interp1(wY2,I3,wI,'pchip','extrap')';
    I5 = interp1(wY2,I31,wI,'pchip','extrap')';
    I6 = interp1(wY2,I32,wI,'pchip','extrap')';

    w=wI;x=I4;y=I5;z=I6;I=I2;

    % compute k
    k=1/(trapz(w,y.*I));
    % Compute X,Y & Z for image
    X=k*trapz(w,Y*diag(I.*x),2);
    Z=k*trapz(w,Y*diag(I.*z),2);
    Y=k*trapz(w,Y*diag(I.*y),2);

    XYZ=[X Y Z]';

    % a1 = 0;a2 = 0;a3 = 0;
    % b1 = 0;b2 = 0;b3 = 0;
    % c1 = 0;c2 = 0;c3 = 0;
    % ttt = 0;

    % Convert to RGB
    M=[ 4.5716 4.1378 1.80133;
       -2.57029 -5.085878 -10.045871;
       4.08109 5.06699 -0.412];
    % M=[ a1 a2 a3;
    %    -0.57029 -2.085878 -0.045871;
    %    5.28109 0.86699 -0.912];
    % M=[ a1 a2 a3;
    %    b1 b2 b3;
    %    c1 c2 c3];
    sRGB=M*XYZ;

    % do minor thresholding
    thresholdRGB = 0.002;
    % Correct gamma 
    gamma_map = (sRGB >  0.0051308);
    sRGB(gamma_map) = 1.055 * power(sRGB(gamma_map), (1 ./ 2.4)) - 0.055;
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
    RGB = [];
    RGB(:,:,1)=reshape(sRGB(1,:),ydim,xdim);
    RGB(:,:,2)=reshape(sRGB(2,:),ydim,xdim);
    RGB(:,:,3)=reshape(sRGB(3,:),ydim,xdim);
    value_psnr = 0;
    value_psnr2 = 0;
    tt = 0;
    tt2 = 0;
    img = imread(pic); %RGB
    [m,n,h] = size(img);
    for i1 = 1:2
        for i2 = 1:4
            for i3 = 2:6
                for i4 = 0:1
                    for i5 = 0.90:0.01:1.20
                        for i6 = 100:120
                            img2 = img(i1:m-i2,i3:n-i4,:); 
                            newSize = [ydim,xdim];  % 新的尺寸 [高度, 宽度]
                            resized_img = imresize(img2, newSize);
                            resized_img = double(resized_img);
                            resized_img = resized_img / 255; 
                            rgb = flipud(RGB); %转换的RGB
                            rgb(:,:,3) = rgb(:,:,3)/255*i6;
                            rgb(:,:,1) = rgb(:,:,1)*i5;
                            value_psnr = psnr(rgb(:,:,1),resized_img(:,:,1));
                            value_psnr2 = psnr(rgb(:,:,3),resized_img(:,:,3));
                            if value_psnr > tt
                                tt = value_psnr;
                                j1(1,po-50) = i1;j1(2,po-50) = i2;j1(3,po-50) = i3;
                                j1(4,po-50) = i4;j1(5,po-50) = i5;j1(6,po-50) = i6;
                            end
                            if value_psnr2 > tt2
                                tt2 = value_psnr2;
                                q1(1,po-50) = i1;q1(2,po-50) = i2;q1(3,po-50) = i3;
                                q1(4,po-50) = i4;q1(5,po-50) = i5;q1(6,po-50) = i6;
                            end                        
                        end
                    end
                end
            end
        end
    end
    po1(po-50) = tt;
    po2(po-50) = tt2;
end

for po = 51:205
    filename1 = ['E:\Hyperspectral_recovery\data\XJF\mat文件\20230712\' num2str(po) '-2.raw\'];
    filename2 = [num2str(po) '-2.raw.mat'];
    filename3 = [num2str(po) '-2.bmp'];
    filename4 = [num2str(po) '-2_1.bmp'];
    filename5 = [filename1 filename2];
    filename6 = [filename1 filename3];
    filename7 = [filename1 filename4];

    pic = ['E:\Hyperspectral_recovery\data\XJF\RGB\' num2str(po) '\' num2str(po) '-2.bmp'];


    % 使用load函数读取.mat文件
    data = load(filename5);
    Q = data.yi2;

    % Y holds the HSI (uint8 to save space)
    % wl holds the wavelengths of the spectral bands
    % The image is 307x307 pixels
    % The illuminant used is D65
    wI = [402.60,405.80,408.90,412.10,415.20,418.40,421.60,424.70,427.90,...
    431.10,434.20,437.40,440.60,443.80,447.00,450.20,453.40,456.60,459.80,463.00,...
    466.20,469.40,472.60,475.80,479.00,482.30,485.50,488.70,492.00,495.20,498.50,...
    501.70,505.00,508.20,511.50,514.70,518.00,521.30,524.50,527.80,531.10,534.40,...
    537.70,540.90,544.20,547.50,550.80,554.10,557.40,560.70,564.10,567.40,570.70,...
    574.00,577.30,580.70,584.00,587.40,590.70,594.00,597.40,600.70,604.10,607.40,...
    610.80,614.20,617.50,620.90,624.30,627.70,631.10,634.40,637.80,641.20,644.60,...
    648.00,651.40,654.80,658.20,661.70,665.10,668.50,671.90,675.30,678.80,682.20,...
    685.60,689.10,692.50,696.00,699.40,702.90,706.30,709.80,713.30,716.70,720.20,...
    723.70,727.20,730.60,734.10,737.60,741.10,744.60,748.10,751.60,755.10,758.60,...
    762.20,765.70,769.20,772.70,776.20,779.80,783.30,786.80,790.40,793.90,797.50,...
    801.00,804.60,808.10,811.70,815.30,818.80,822.40,826.00,829.60,833.20,836.70,...
    840.30,843.90,847.50,851.10,854.70,858.30,861.90,865.60,869.20,872.80,876.40,...
    880.10,883.70,887.30,891.00,894.60,898.20,901.90,905.50,909.20,912.90,916.50,...
    920.20,923.90,927.50,931.20,934.90,938.60,942.30,946.00,949.60,953.30,957.00,...
    960.70,964.50,968.20,971.90,975.60,979.30,983.00,986.80,990.50,994.20,998.00,...
    1001.70,1005.50];

    % load data and convert to double
    Q=double(Q)/1000;
    [ydim,xdim,zdim]=size(Q);
    E = [];
    % reorder data so that each column holds the spectra of of one pixel
    for i=1:zdim
        e=Q(:,:,i);e=e(:);
        E(:,i)=e;
    end

    Y = E;


    %Create the RBG image, 
    data = xlsread('E:\Hyperspectral_recovery\HSI2RGB\溴钨灯功率.xls');
    data2 = xlsread('E:\Hyperspectral_recovery\1_相机标定\2_RGB相机响应曲线\相机CCD响应曲线.xlsx');

    I = data(:,9);
    wY = data(:,8);

    I2 = interp1(wY,I,wI,'pchip','extrap')';

    wY2 = data2(:,1);
    I3  = data2(:,2);
    I31 = data2(:,3);
    I32 = data2(:,4);

    I4 = interp1(wY2,I3,wI,'pchip','extrap')';
    I5 = interp1(wY2,I31,wI,'pchip','extrap')';
    I6 = interp1(wY2,I32,wI,'pchip','extrap')';

    w=wI;x=I4;y=I5;z=I6;I=I2;

    % compute k
    k=1/(trapz(w,y.*I));
    % Compute X,Y & Z for image
    X=k*trapz(w,Y*diag(I.*x),2);
    Z=k*trapz(w,Y*diag(I.*z),2);
    Y=k*trapz(w,Y*diag(I.*y),2);

    XYZ=[X Y Z]';

    % a1 = 0;a2 = 0;a3 = 0;
    % b1 = 0;b2 = 0;b3 = 0;
    % c1 = 0;c2 = 0;c3 = 0;
    % ttt = 0;

    % Convert to RGB
    M=[ 4.5716 4.1378 1.80133;
       -2.57029 -5.085878 -10.045871;
       4.08109 5.06699 -0.412];
    % M=[ a1 a2 a3;
    %    -0.57029 -2.085878 -0.045871;
    %    5.28109 0.86699 -0.912];
    % M=[ a1 a2 a3;
    %    b1 b2 b3;
    %    c1 c2 c3];
    sRGB=M*XYZ;

    % do minor thresholding
    thresholdRGB = 0.002;
    % Correct gamma 
    gamma_map = (sRGB >  0.0051308);
    sRGB(gamma_map) = 1.055 * power(sRGB(gamma_map), (1 ./ 2.4)) - 0.055;
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
    RGB = [];
    RGB(:,:,1)=reshape(sRGB(1,:),ydim,xdim);
    RGB(:,:,2)=reshape(sRGB(2,:),ydim,xdim);
    RGB(:,:,3)=reshape(sRGB(3,:),ydim,xdim);
    value_psnr = 0;
    value_psnr2 = 0;
    tt = 0;
    tt2 = 0;
    img = imread(pic); %RGB
    [m,n,h] = size(img);
    for i1 = 1:2
        for i2 = 1:4
            for i3 = 2:6
                for i4 = 0:1
                    for i5 = 0.90:0.01:1.20
                        for i6 = 100:120
                            img2 = img(i1:m-i2,i3:n-i4,:); 
                            newSize = [ydim,xdim];  % 新的尺寸 [高度, 宽度]
                            resized_img = imresize(img2, newSize);
                            resized_img = double(resized_img);
                            resized_img = resized_img / 255; 
                            rgb = flipud(RGB); %转换的RGB
                            rgb(:,:,3) = rgb(:,:,3)/255*i6;
                            rgb(:,:,1) = rgb(:,:,1)*i5;
                            value_psnr = psnr(rgb(:,:,1),resized_img(:,:,1));
                            value_psnr2 = psnr(rgb(:,:,3),resized_img(:,:,3));
                            if value_psnr > tt
                                tt = value_psnr;
                                j12(1,po-50) = i1;j12(2,po-50) = i2;j12(3,po-50) = i3;
                                j12(4,po-50) = i4;j12(5,po-50) = i5;j12(6,po-50) = i6;
                            end
                            if value_psnr2 > tt2
                                tt2 = value_psnr2;
                                q12(1,po-50) = i1;q12(2,po-50) = i2;q12(3,po-50) = i3;
                                q12(4,po-50) = i4;q12(5,po-50) = i5;q12(6,po-50) = i6;
                            end                        
                        end
                    end
                end
            end
        end
    end
    po12(po-50) = tt;
    po22(po-50) = tt2;
end
