clear all;
clc
aa = xlsread("E:\Hyperspectral_recovery\1_相机标定\4_积分球\积分球漫反射率测试数据.xlsx");

figure
plot(aa(:,1),aa(:,2),'k','LineWidth',1.2);hold on;
set(gca,'FontSize',12,'Fontname', 'Arial','LineWidth',1.2);
set(gca,'xlim',[250 2500]);
xticks(250:250:2500);  % 设置x轴标签
set(gca,'ylim',[0.7 1]);
ylabel({'\fontname{Arial}Reflectance'},'FontSize',12);
xlabel({'\fontname{Arial}Wavelength (nm)'},'FontSize',12);



