clear all;
clc

aa1 = xlsread("E:\Hyperspectral_recovery\1_相机标定\result\result3.xlsx");

aa = xlsread("E:\Hyperspectral_recovery\1_相机标定\3_单色仪2参数\3.xlsx");
bb = xlsread("E:\Hyperspectral_recovery\1_相机标定\5_标准探测器\PDA100A2_5nm.xlsx");



h = figure;
set(h,'position',[100 0 800 700]);
subplot(3,2,1)
plot(400:5:1000,aa1(:,3)./bb(:,2).*aa(:,3)/(21/3),'r','LineWidth',1.5);hold on;
plot(400:5:1000,aa1(:,2)./bb(:,2).*aa(:,3)/(21/3),'g','LineWidth',1.5);hold on;
plot(400:5:1000,aa1(:,4)./bb(:,2).*aa(:,3)/(21/3),'b','LineWidth',1.5);hold on;
set(gca,'FontSize',12,'Fontname', 'Arial','LineWidth',1.5, 'FontWeight', 'bold');
set(gca,'xlim',[400 1000]);
set(gca,'ylim',[0 250]);
set(gca,'YTick',0:50:250);
ylabel({'\fontname{Arial}Gary value'},'FontSize',12, 'FontWeight', 'bold');
xlabel({'\fontname{Arial}Wavelength (nm)'},'FontSize',12, 'FontWeight', 'bold');
leg = legend('Red','Green','Blue','location','southeast', 'FontWeight', 'bold');
leg.ItemTokenSize = [15,30];

subplot(3,2,2)
plot(400:5:1000,aa(:,3)','r','LineWidth',1.5);hold on;
set(gca,'FontSize',12,'Fontname', 'Arial','LineWidth',1.5, 'FontWeight', 'bold');
set(gca,'xlim',[400 1000]);
set(gca,'ylim',[0 2500]);
set(gca,'YTick',0:500:2500);
ylabel({'\fontname{Arial}Voltage (mV)'},'FontSize',12, 'FontWeight', 'bold');
xlabel({'\fontname{Arial}Wavelength (nm)'},'FontSize',12, 'FontWeight', 'bold');

subplot(3,2,3)
plot(400:5:1000,bb(:,2)','r','LineWidth',1.5);hold on;
set(gca,'FontSize',12,'Fontname', 'Arial','LineWidth',1.5, 'FontWeight', 'bold');
set(gca,'xlim',[400 1000]);
set(gca,'ylim',[0 1]);
set(gca,'YTick',0:0.2:1);
str23 = {'\fontname{Arial}Responsivity (A·W^{\fontsize{8}-1}{\fontsize{12})}'};
ylabel(str23,'FontSize',12, 'FontWeight', 'bold');
xlabel({'\fontname{Arial}Wavelength (nm)'},'FontSize',12, 'FontWeight', 'bold');


subplot(3,2,5)
plot(aa1(:,1),aa1(:,3),'r','LineWidth',1.5);hold on;
plot(aa1(:,1),aa1(:,2),'g','LineWidth',1.5);hold on;
plot(aa1(:,1),aa1(:,4),'b','LineWidth',1.5);hold on;
set(gca,'FontSize',12,'Fontname', 'Arial','LineWidth',1.5, 'FontWeight', 'bold');
set(gca,'xlim',[400 1000]);
set(gca,'YTick',0:0.2:1);
ylabel({'\fontname{Arial}Relative response'},'FontSize',12, 'FontWeight', 'bold');
xlabel({'\fontname{Arial}Wavelength (nm)'},'FontSize',12, 'FontWeight', 'bold');
leg = legend('Red','Green','Blue','location','southeast', 'FontWeight', 'bold');
leg.ItemTokenSize = [15,30];

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

data = xlsread('E:\Hyperspectral_recovery\2_HSI2RGB\溴钨灯功率.xls');
data2 = xlsread('E:\Hyperspectral_recovery\1_相机标定\2_RGB相机响应曲线\相机CCD响应曲线.xlsx');

I = data(:,9);
wY = data(:,8);

I2 = interp1(wY,I,wI,'pchip','extrap')';

wY2 = data2(:,1);
I3 = data2(:,2);
I31 = data2(:,3);
I32 = data2(:,4);

I4 = interp1(wY2,I3,wI,'pchip','extrap')';
I5 = interp1(wY2,I31,wI,'pchip','extrap')';
I6 = interp1(wY2,I32,wI,'pchip','extrap')';

subplot(3,2,4)
% z2 = smooth(heibai(:,8),heibai(:,9),'moving');   % 'moving'平滑
plot(wI,I2,'r','LineWidth',1.5);hold on;
set(gca,'FontSize',12,'Fontname', 'Arial','LineWidth',1.5, 'FontWeight', 'bold');
set(gca,'xlim',[400 1000],'ylim',[0 10]);
set(gca,'YTick',0:2:10);
ylabel({'\fontname{Arial}luminous power (uw)'},'FontSize',12, 'FontWeight', 'bold');
xlabel({'\fontname{Arial}Wavelength (nm)'},'FontSize',12, 'FontWeight', 'bold');


data = xlsread('E:\Hyperspectral_recovery\2_HSI2RGB\溴钨灯功率.xls');
data2 = xlsread('E:\Hyperspectral_recovery\1_相机标定\2_RGB相机响应曲线\相机CCD响应曲线.xlsx');

I = data(:,9);
wY = data(:,8);

I2 = interp1(wY,I,wI,'pchip','extrap')';

wY2 = data2(:,1);
I3 = data2(:,2);
I31 = data2(:,3);
I32 = data2(:,4);

I4 = interp1(wY2,I3,wI,'pchip','extrap')';
I5 = interp1(wY2,I31,wI,'pchip','extrap')';
I6 = interp1(wY2,I32,wI,'pchip','extrap')';
subplot(3,2,6)
% z2 = smooth(heibai(:,8),heibai(:,9),'moving');   % 'moving'平滑
plot(wI,I6,'r','LineWidth',1.5);hold on;
plot(wI,I5,'g','LineWidth',1.5);hold on;
plot(wI,I4,'b','LineWidth',1.5);hold on;
set(gca,'FontSize',12,'Fontname', 'Arial','LineWidth',1.5, 'FontWeight', 'bold');
set(gca,'xlim',[400 1000],'ylim',[0 1]);
set(gca,'YTick',0:0.2:1);
ylabel({'\fontname{Arial}Relative response'},'FontSize',12, 'FontWeight', 'bold');
xlabel({'\fontname{Arial}Wavelength (nm)'},'FontSize',12, 'FontWeight', 'bold');


