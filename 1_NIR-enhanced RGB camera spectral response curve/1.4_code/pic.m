clear all;
clc
aa = xlsread("E:\Hyperspectral_recovery\1_相机标定\4_积分球\买积分球后的结果\res.xlsx");
aa1 = aa;
bb = xlsread("E:\Hyperspectral_recovery\1_相机标定\5_标准探测器\标准探测器_单色仪响应.xlsx");
bb1 = bb';
cc = xlsread("E:\Hyperspectral_recovery\1_相机标定\5_标准探测器\PDA100A2_5nm.xlsx");
cc1 = cc';
dd = xlsread("E:\Hyperspectral_recovery\1_相机标定\3_单色仪参数\simple_scan_ref_W.xlsx");
dd1 = dd';


SamplePath =  'E:\Hyperspectral_recovery\1_相机标定\4_积分球\新建文件夹\4\';  %存储图像的路径
imgDataDir  = dir([SamplePath '*.jpg']); 

for tt=1:3
    imagefile=[imgDataDir(tt).folder '\' imgDataDir(tt).name];
    ttp = imread(imagefile);
    q1 = ttp(500:550,1000:1050,1);
    q2 = ttp(500:550,1000:1050,2);
    q3 = ttp(500:550,1000:1050,3);
    t1(tt) = mean(mean(q1,2),1)/16;
    t2(tt) = mean(mean(q2,2),1)/16;
    t3(tt) = mean(mean(q3,2),1)/16;
end

for tt=4:31
    imagefile=[imgDataDir(tt).folder '\' imgDataDir(tt).name];
    ttp = imread(imagefile);
    q1 = ttp(500:550,1000:1050,1);
    q2 = ttp(500:550,1000:1050,2);
    q3 = ttp(500:550,1000:1050,3);
    t1(tt) = mean(mean(q1,2),1);
    t2(tt) = mean(mean(q2,2),1);
    t3(tt) = mean(mean(q3,2),1);
end

for tt=32:61
    imagefile=[imgDataDir(tt).folder '\' imgDataDir(tt).name];
    ttp = imread(imagefile);
    q1 = ttp(500:550,1000:1050,1);
    q2 = ttp(500:550,1000:1050,2);
    q3 = ttp(500:550,1000:1050,3);
    t1(tt) = mean(mean(q1,2),1);
    t2(tt) = mean(mean(q2,2),1);
    t3(tt) = mean(mean(q3,2),1);
end


% 
% figure
% subplot(2,2,1)
% plot(aa1(1,:),aa1(2,:)/300*200,'r','LineWidth',1.2);hold on;
% plot(aa1(1,:),aa1(3,:)/300*200,'g','LineWidth',1.2);hold on;
% plot(aa1(1,:),aa1(4,:)/300*200,'b','LineWidth',1.2);hold on;
% set(gca,'FontSize',12,'Fontname', 'Arial','LineWidth',1.2);
% set(gca,'xlim',[400 1000]);
% ylabel({'\fontname{Arial}Gary value'},'FontSize',12);
% xlabel({'\fontname{Arial}Wavelength (nm)'},'FontSize',12);
% 
% subplot(2,2,2)
% plot(bb1(1,:),bb1(2,:),'r','LineWidth',1.2);hold on;
% set(gca,'FontSize',12,'Fontname', 'Arial','LineWidth',1.2);
% set(gca,'xlim',[400 1000]);
% ylabel({'\fontname{Arial}Gary value'},'FontSize',12);
% xlabel({'\fontname{Arial}Wavelength (nm)'},'FontSize',12);
% 
% 
% subplot(2,2,3)
% plot(cc1(1,:),cc1(2,:),'r','LineWidth',1.2);hold on;
% set(gca,'FontSize',12,'Fontname', 'Arial','LineWidth',1.2);
% set(gca,'xlim',[400 1000]);
% ylabel({'\fontname{Arial}Gary value'},'FontSize',12);
% xlabel({'\fontname{Arial}Wavelength (nm)'},'FontSize',12);
% 
% xx = cc1(1,:);
tt1 = aa1(2,:)./bb1(2,:).*cc1(2,:)./300.*175;
tt2 = aa1(3,:)./bb1(2,:).*cc1(2,:)./300.*175;
tt3 = aa1(4,:)./bb1(2,:).*cc1(2,:)./300.*175;

figure
plot(aa1(1,:),tt1,'r','LineWidth',1.2);hold on;
plot(aa1(1,:),tt2,'g','LineWidth',1.2);hold on;
plot(aa1(1,:),tt3,'b','LineWidth',1.2);hold on;
[t1,PS] = mapminmax(t1/100,0.23,1.60);
[t2,PS2] = mapminmax(t2/100,0.20,1.10);
[t3,PS3] = mapminmax(t3/100,0.20,0.96);
plot(800:10:1000,t1(41:61),'r','LineWidth',1.2);hold on;
plot(800:10:1000,t2(41:61),'g','LineWidth',1.2);hold on;
plot(800:10:1000,t3(41:61),'b','LineWidth',1.2);hold on;
t1 = t1';t2 = t2';t3 = t3';
tt1 = tt1';tt2 = tt2';tt3 = tt3';
set(gca,'FontSize',12,'Fontname', 'Arial','LineWidth',1.2);
set(gca,'xlim',[400 1000]);
ylabel({'\fontname{Arial}Gary value'},'FontSize',12);
xlabel({'\fontname{Arial}Wavelength (nm)'},'FontSize',12);

we1 = aa1(2,:)/300*200./dd1(2,:);
we2 = aa1(3,:)/300*200./dd1(2,:);
we3 = aa1(4,:)/300*200./dd1(2,:);

% figure
% plot(aa1(1,:),aa1(2,:)/300*200./dd1(2,:),'r','LineWidth',1.2);hold on;
% plot(aa1(1,:),aa1(3,:)/300*200./dd1(2,:),'g','LineWidth',1.2);hold on;
% plot(aa1(1,:),aa1(4,:)/300*200./dd1(2,:),'b','LineWidth',1.2);hold on;
% set(gca,'FontSize',12,'Fontname', 'Arial','LineWidth',1.2);
% set(gca,'xlim',[400 1000]);
% ylabel({'\fontname{Arial}Gary value'},'FontSize',12);
% xlabel({'\fontname{Arial}Wavelength (nm)'},'FontSize',12);


% subplot(2,2,2)
% plot(aa1(1,:),bb1(2,:)./dd1(2,:),'r','LineWidth',1.2);hold on;
% set(gca,'FontSize',12,'Fontname', 'Arial','LineWidth',1.2);
% set(gca,'xlim',[400 1000]);
% ylabel({'\fontname{Arial}Gary value'},'FontSize',12);
% xlabel({'\fontname{Arial}Wavelength (nm)'},'FontSize',12);
% 

