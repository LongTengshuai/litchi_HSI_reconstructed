clear all;
clc
a = xlsread('E:\Hyperspectral_recovery\1_相机标定\4_积分球\积分球漫反射率测试数据.xlsx');

h = figure;
set(h,'position',[50 50 450 250]);
z2 = smooth(a(:,1),a(:,2),'moving');   % 'moving'平滑
plot(a(:,1),a(:,2),'r','LineWidth',1.5);hold on;
set(gca,'FontSize',12,'Fontname', 'Arial','LineWidth',1.5, 'FontWeight', 'bold');
set(gca,'xlim',[400 1000],'ylim',[0.8 1]);
set(gca,'XTick',400:100:1000);
ylabel({'\fontname{Arial}Diffuse reflectance'},'FontSize',12, 'FontWeight', 'bold');
xlabel({'\fontname{Arial}Wavelength (nm)'},'FontSize',12, 'FontWeight', 'bold');

