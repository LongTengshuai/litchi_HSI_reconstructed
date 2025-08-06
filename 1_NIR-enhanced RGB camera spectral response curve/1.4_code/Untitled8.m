clear all;
clc

aa1 = xlsread("E:\Hyperspectral_recovery\1_相机标定\result\result3.xlsx");
aa = xlsread("E:\Hyperspectral_recovery\1_相机标定\3_单色仪2参数\3.xlsx");
bb = xlsread("E:\Hyperspectral_recovery\1_相机标定\5_标准探测器\PDA100A2_5nm.xlsx");


CC = xlsread('F:\Litchi\Indoor\Xian_jin_feng\1_original_hpyerspectral_images_and_spectral_extraction\2_Origin_spectra_each\VNIR.xlsx');
heibai = xlsread('F:\Litchi\Indoor\Xian_jin_feng\1_original_hpyerspectral_images_and_spectral_extraction\2_Origin_spectra_each\heibai.xlsx');
x = xlsread('F:\Litchi\Indoor\Xian_jin_feng\1_original_hpyerspectral_images_and_spectral_extraction\2_Origin_spectra_each\x.xlsx');
xx=ones(176,1);

dd = xlsread('E:\Hyperspectral_recovery\2_HSI2RGB\溴钨灯功率.xls');

h = figure;
set(h,'position',[100 100 800 250]);

subplot(1,3,1)
plot(dd(:,1),dd(:,9),'r','LineWidth',1.5);hold on;
xlabel({'\fontname{Arial}Wavelength (nm)',},'FontSize',12, 'FontWeight', 'bold');
ylabel({'\fontname{Arial}Iuminous power (uw)'},'FontSize',12, 'FontWeight', 'bold');
set(gca,'FontName','Arial','FontSize',12,'LineWidth',1.5, 'FontWeight', 'bold');
set(gca,'TickDir','in')
set(gca, 'Box', 'on');
axis([400 1000 0 10]);


subplot(1,3,2)
wer1 = heibai(:,2)';
wer2 = heibai(:,3)';

for i =3:3
    wer(i-2,:) = (CC(i,2:177) - wer2)./(wer1 - wer2)/4+0.002;
end

plot(x,wer,'r','LineWidth',1.5);hold on;
xlabel({'\fontname{Arial}Wavelength (nm)'},'FontSize',12, 'FontWeight', 'bold');
ylabel({'\fontname{Arial}Reflectance'},'FontSize',12, 'FontWeight', 'bold');
set(gca,'FontName','Arial','FontSize',12,'LineWidth',1.5, 'FontWeight', 'bold');
set(gca,'TickDir','in')
set(gca, 'Box', 'on');
axis([400 1000 0 1]);



subplot(1,3,3)
plot(aa1(:,1),aa1(:,3),'r','LineWidth',1.5);hold on;
plot(aa1(:,1),aa1(:,2),'g','LineWidth',1.5);hold on;
plot(aa1(:,1),aa1(:,4),'b','LineWidth',1.5);hold on;
set(gca,'FontSize',12,'Fontname', 'Arial','LineWidth',1.5, 'FontWeight', 'bold');
set(gca,'xlim',[400 1000]);
ylabel({'\fontname{Arial}Relative response'},'FontSize',12, 'FontWeight', 'bold');
xlabel({'\fontname{Arial}Wavelength (nm)'},'FontSize',12, 'FontWeight', 'bold');
leg = legend('R','G','B','location','southeast', 'FontWeight', 'bold');
leg.ItemTokenSize = [12,18];




