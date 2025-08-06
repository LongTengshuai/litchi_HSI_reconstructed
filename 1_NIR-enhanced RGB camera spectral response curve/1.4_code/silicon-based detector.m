clear all;
clc
a = xlsread('E:\Hyperspectral_recovery\1_相机标定\5_标准探测器\标准探测器_单色仪响应.xlsx');
x = a(:,1);

% h = figure;
% set(h,'position',[200 200 800 600]);
% subplot(2,2,1)
% plot(a(:,1),a(:,2),'k','LineWidth',1.2);hold on;
% set(gca,'FontSize',12,'Fontname', 'Arial','LineWidth',1.2);
% set(gca,'xlim',[400 1000]);
% ylabel({'\fontname{Arial}Voltage (mV)'},'FontSize',12);
% xlabel({'\fontname{Arial}Wavelength (nm)'},'FontSize',12);
% 
% 
% b = xlsread('E:\Hyperspectral_recovery\1_相机标定\5_标准探测器\PDA100A2_5nm.xlsx');
% 
% subplot(2,2,2)
% plot(b(:,1),b(:,2),'r','LineWidth',1.2);
% set(gca,'FontSize',12,'Fontname', 'Arial','LineWidth',1.2);
% set(gca,'xlim',[400 1000],'ylim',[0 0.8]);
% ylabel({'\fontname{Arial}Responsivity (A/W)'},'FontSize',12);
% xlabel({'\fontname{Arial}Wavelength (nm)'},'FontSize',12);
% 
% c = xlsread('E:\Hyperspectral_recovery\1_相机标定\4_积分球\买积分球后的结果\1\res1.xlsx');
% r1 = c(:,1);
% g1 = c(:,2);
% b1 = c(:,3);
% 
% subplot(2,2,3)
% plot(c(:,4),r1,'r','LineWidth',1.2);hold on;
% plot(c(:,4),g1,'g','LineWidth',1.2);hold on;
% plot(c(:,4),b1,'b','LineWidth',1.2);hold on;
% set(gca,'FontSize',12,'Fontname', 'Arial','LineWidth',1.2);
% set(gca,'xlim',[400 1000]);
% ylabel({'\fontname{Arial}Responsivity (A/W)'},'FontSize',12);
% xlabel({'\fontname{Arial}Wavelength (nm)'},'FontSize',12);
% 
% subplot(2,2,4)
% plot(c(:,4),r1./(a(:,2)./b(:,2)),'r','LineWidth',1.2);hold on;
% plot(c(:,4),g1./(a(:,2)./b(:,2)),'g','LineWidth',1.2);hold on;
% plot(c(:,4),b1./(a(:,2)./b(:,2)),'b','LineWidth',1.2);hold on;
% set(gca,'FontSize',12,'Fontname', 'Arial','LineWidth',1.2);
% set(gca,'xlim',[400 1000]);
% ylabel({'\fontname{Arial}Responsivity (A/W)'},'FontSize',12);
% xlabel({'\fontname{Arial}Wavelength (nm)'},'FontSize',12);
% 
% figure
% X1 = r1./(a(:,2)./b(:,2));
% X2 = g1./(a(:,2)./b(:,2));
% X3 = b1./(a(:,2)./b(:,2));
% Y1 = mapminmax(X1',0,1);
% Y2 = mapminmax(X2',0,1);
% Y3 = mapminmax(X3',0,1);
% plot(c(:,4),Y1,'r','LineWidth',1.2);hold on;
% plot(c(:,4),Y2,'g','LineWidth',1.2);hold on;
% plot(c(:,4),Y3,'b','LineWidth',1.2);hold on;
% set(gca,'FontSize',12,'Fontname', 'Arial','LineWidth',1.2);
% set(gca,'xlim',[400 1000]);
% ylabel({'\fontname{Arial}Responsivity (A/W)'},'FontSize',12);
% xlabel({'\fontname{Arial}Wavelength (nm)'},'FontSize',12);


%interp1对sin函数进行分段线性插值，调用interp1的时候，默认的是分段线性插值

figure
subplot(2,3,1)
plot(x,y,'k','LineWidth',1.2);hold on;
set(gca,'FontSize',12,'Fontname', 'Arial','LineWidth',1.2);
set(gca,'xlim',[400 1000],'ylim',[0 0.8]);
ylabel({'\fontname{Arial}Responsivity (A/W)'},'FontSize',12);
xlabel({'\fontname{Arial}Wavelength (nm)'},'FontSize',12);
title('Origin');

y1=interp1(x,y,xx);
y2=interp1(x,y,xx,'nearest');
y3=interp1(x,y,xx,'spline');
y4=interp1(x,y,xx,'cubic');

subplot(2,3,2)
plot(xx,y1,'r','LineWidth',1.2);hold on;
plot(xx,y2,'g','LineWidth',1.2);hold on;
plot(xx,y3,'b','LineWidth',1.2);hold on;
plot(xx,y4,'k','LineWidth',1.2);hold on;
set(gca,'FontSize',12,'Fontname', 'Arial','LineWidth',1.2);
set(gca,'xlim',[400 1000],'ylim',[0 0.8]);
ylabel({'\fontname{Arial}Responsivity (A/W)'},'FontSize',12);
xlabel({'\fontname{Arial}Wavelength (nm)'},'FontSize',12);
title('All');

subplot(2,3,3)
plot(xx,y1,'r','LineWidth',1.2)
set(gca,'FontSize',12,'Fontname', 'Arial','LineWidth',1.2);
set(gca,'xlim',[400 1000],'ylim',[0 0.8]);
ylabel({'\fontname{Arial}Responsivity (A/W)'},'FontSize',12);
xlabel({'\fontname{Arial}Wavelength (nm)'},'FontSize',12);
title('Piecewise linear interpolation');

%临近插值
subplot(2,3,4)
plot(xx,y2,'r','LineWidth',1.2);
set(gca,'FontSize',12,'Fontname', 'Arial','LineWidth',1.2);
set(gca,'xlim',[400 1000],'ylim',[0 0.8]);
ylabel({'\fontname{Arial}Responsivity (A/W)'},'FontSize',12);
xlabel({'\fontname{Arial}Wavelength (nm)'},'FontSize',12);
title('Near interpolation');

%球面线性插值
subplot(2,3,5)
plot(xx,y3,'r','LineWidth',1.2)
set(gca,'FontSize',12,'Fontname', 'Arial','LineWidth',1.2);
set(gca,'xlim',[400 1000],'ylim',[0 0.8]);
ylabel({'\fontname{Arial}Responsivity (A/W)'},'FontSize',12);
xlabel({'\fontname{Arial}Wavelength (nm)'},'FontSize',12);
title('Spherical interpolation');

%三次多项式插值法
subplot(2,3,6)
plot(xx,y4,'r','LineWidth',1.2);
set(gca,'FontSize',12,'Fontname', 'Arial','LineWidth',1.2);
set(gca,'xlim',[400 1000],'ylim',[0 0.8]);
ylabel({'\fontname{Arial}Responsivity (A/W)'},'FontSize',12);
xlabel({'\fontname{Arial}Wavelength (nm)'},'FontSize',12);
title('Cubic polynomial interpolation');