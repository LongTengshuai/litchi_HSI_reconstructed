clear all;
clc

heibai = xlsread('E:\Hyperspectral_recovery\1_相机标定\8_光源\溴钨灯功率，光栅600-500.xls');


h = figure;
set(h,'position',[50 50 450 250]);
% z2 = smooth(heibai(:,8),heibai(:,9),'moving');   % 'moving'平滑
plot(heibai(:,8),heibai(:,9),'r','LineWidth',1.5);hold on;
set(gca,'FontSize',12,'Fontname', 'Arial','LineWidth',1.5, 'FontWeight', 'bold');
set(gca,'xlim',[400 1000],'ylim',[0 10]);
% set(gca,'XTick',300:300:1200);
ylabel({'\fontname{Arial}luminous power (uw)'},'FontSize',12, 'FontWeight', 'bold');
xlabel({'\fontname{Arial}Wavelength (nm)'},'FontSize',12, 'FontWeight', 'bold');




