clear all;
clc

fig = figure;
set(fig, 'Position', [100, 100, 900, 550]);
aa1 = xlsread("E:\Hyperspectral_recovery\1_相机标定\4_积分球\买积分球后的结果\res.xlsx");
aa1 = aa1';
subplot(2,2,1)
plot(aa1(:,1),aa1(:,2),'g','LineWidth',1.2);hold on;
plot(aa1(:,1),aa1(:,3),'b','LineWidth',1.2);hold on;
plot(aa1(:,1),aa1(:,4),'r','LineWidth',1.2);hold on;
set(gca,'FontSize',12,'Fontname', 'Arial','LineWidth',1.2);
set(gca,'xlim',[400 1000]);
ylabel({'\fontname{Arial}Gary value'},'FontSize',12);
xlabel({'\fontname{Arial}Wavelength (nm)'},'FontSize',12);
legend('Green','Blue','Red','location','southeast');

a = xlsread('E:\Hyperspectral_recovery\1_相机标定\5_标准探测器\标准探测器_单色仪响应.xlsx');
x = a(:,1);
subplot(2,2,2)
plot(a(:,1),a(:,2),'k','LineWidth',1.2);hold on;
set(gca,'FontSize',12,'Fontname', 'Arial','LineWidth',1.2);
set(gca,'xlim',[400 1000]);
ylabel({'\fontname{Arial}Voltage (mV)'},'FontSize',12);
xlabel({'\fontname{Arial}Wavelength (nm)'},'FontSize',12);


b = xlsread('E:\Hyperspectral_recovery\1_相机标定\5_标准探测器\PDA100A2_5nm.xlsx');
subplot(2,2,3)
plot(b(:,1),b(:,2),'r','LineWidth',1.2);
set(gca,'FontSize',12,'Fontname', 'Arial','LineWidth',1.2);
set(gca,'xlim',[400 1000],'ylim',[0 0.8]);
ylabel({'\fontname{Arial}Responsivity (A/W)'},'FontSize',12);
xlabel({'\fontname{Arial}Wavelength (nm)'},'FontSize',12);

aa = xlsread("E:\Hyperspectral_recovery\1_相机标定\result\1.xlsx");
aa = aa';
subplot(2,2,4)
plot(aa(1,:),aa(2,:),'g','LineWidth',1.2);hold on;
plot(aa(1,:),aa(3,:),'b','LineWidth',1.2);hold on;
plot(aa(1,:),aa(4,:),'r','LineWidth',1.2);hold on;
set(gca,'FontSize',12,'Fontname', 'Arial','LineWidth',1.2);
set(gca,'xlim',[400 1000]);
ylabel({'\fontname{Arial}Response'},'FontSize',12);
xlabel({'\fontname{Arial}Wavelength (nm)'},'FontSize',12);

