clear all;

savE = 0;

%data_dir = '/Users/sgess/Desktop/FACET/2012/DATA/MR_TCAV_1501/';
%save_dir = '/Users/sgess/Desktop/FACET/PLOTS/MR_TCAV_1501/';

data_dir = '/Users/sgess/Desktop/data/E200_DATA/MR_TCAV_DISP/';
save_dir = '/Users/sgess/Desktop/plots/E200/MR_TCAV_DISP/';

yag_name_20   = 'ProfMon-YAGS_LI20_2432-2012-07-04-020725.mat';
yag_name_50   = 'ProfMon-YAGS_LI20_2432-2012-07-04-020829.mat';
yag_name_80   = 'ProfMon-YAGS_LI20_2432-2012-07-04-021011.mat';

yag20 = load([data_dir yag_name_20]);
yag50 = load([data_dir yag_name_50]);
yag80 = load([data_dir yag_name_80]);

res = 12.05;
x = 12.05 * (1:608);
x = (x - mean(x))/1000;

figure(1);

subplot(1,3,1);
imagesc(x,1:356,yag20.data.img);
title('20 MeV Energy Offset','fontsize',14);
xlabel('X (mm)','fontsize',14);
subplot(1,3,2);
imagesc(x,1:356,yag50.data.img);
title('50 MeV Energy Offset','fontsize',14);
xlabel('X (mm)','fontsize',14);
subplot(1,3,3);
imagesc(x,1:356,yag80.data.img);
title('80 MeV Energy Offset','fontsize',14);
xlabel('X (mm)','fontsize',14);

if savE
saveas(gca,[save_dir 'YAG_IMGS.pdf']);
saveas(gca,[save_dir 'YAG_IMGS.png']);
saveas(gca,[save_dir 'YAG_IMGS.tiff']);
end

yag_line20 = mean(double(yag20.data.img(100:125,:)),1);
yag_line50 = mean(double(yag50.data.img(100:125,:)),1);
yag_line80 = mean(double(yag80.data.img(100:125,:)),1);

figure(2);

plot(x,yag_line20,'c',x,yag_line50,'g',x,yag_line80,'r','linewidth',2);
xlabel('X (mm)','fontsize',14);
t = legend('20 MeV Offset','50 MeV Offset','80 MeV Offset');
set(t,'FontSize',14);

[y20_fw,y20_lo,y20_hi] = FWHM(1:608,yag_line20);
[y50_fw,y50_lo,y50_hi] = FWHM(1:608,yag_line50);
[y80_fw,y80_lo,y80_hi] = FWHM(1:608,yag_line80);
y80_hi = y80_hi+1;

[~,ym_20] = max(yag_line20);
[~,ym_50] = max(yag_line50);
[~,ym_80] = max(yag_line80);

yc_20 = round(sum((1:608).*yag_line20)/sum(yag_line20));
yc_50 = round(sum((1:608).*yag_line50)/sum(yag_line50));
yc_80 = round(sum((1:608).*yag_line80)/sum(yag_line80));



hold on;
plot(x(y20_lo),yag_line20(y20_lo),'ms','markersize',13,'MarkerFaceColor','m');
plot(x(y20_hi),yag_line20(y20_hi),'ks','markersize',13,'MarkerFaceColor','k');
plot(x(ym_20),yag_line20(ym_20),'bs','markersize',13,'MarkerFaceColor','b');
plot(x(yc_20),yag_line20(yc_20),'ys','markersize',13,'MarkerFaceColor','y');


plot(x(y50_lo),yag_line50(y50_lo),'ms','markersize',13,'MarkerFaceColor','m');
plot(x(y50_hi),yag_line50(y50_hi),'ks','markersize',13,'MarkerFaceColor','k');
plot(x(ym_50),yag_line50(ym_50),'bs','markersize',13,'MarkerFaceColor','b');
plot(x(yc_50),yag_line50(yc_50),'ys','markersize',13,'MarkerFaceColor','y');

plot(x(y80_lo),yag_line80(y80_lo),'ms','markersize',13,'MarkerFaceColor','m');
plot(x(y80_hi),yag_line80(y80_hi),'ks','markersize',13,'MarkerFaceColor','k');
plot(x(ym_80),yag_line80(ym_80),'bs','markersize',13,'MarkerFaceColor','b');
plot(x(yc_80),yag_line80(yc_80),'ys','markersize',13,'MarkerFaceColor','y');

hold off;

if savE
saveas(gca,[save_dir 'YAG_lines.pdf']);
saveas(gca,[save_dir 'YAG_lines.png']);
saveas(gca,[save_dir 'YAG_lines.tiff']);
end

delta = [0.0983 0.2457 0.3931];
flo = [0 x(y50_lo)-x(y20_lo) x(y80_lo)-x(y20_lo)];
fmax = [0 x(ym_50)-x(ym_20) x(ym_80)-x(ym_20)];
fcent = [0 x(yc_50)-x(yc_20) x(yc_80)-x(yc_20)];
fhi = [0 x(y50_hi)-x(y20_hi) x(y80_hi)-x(y20_hi)];

plo = polyfit(delta,flo,2);
pmax = polyfit(delta,fmax,2);
pcent = polyfit(delta,fcent,2);
phi = polyfit(delta,fhi,2);

pflo = plo(1)*delta.^2 + plo(2)*delta + plo(3);
pfmax = pmax(1)*delta.^2 + pmax(2)*delta + pmax(3);
pfcent = pcent(1)*delta.^2 + pcent(2)*delta + pcent(3);
pfhi = phi(1)*delta.^2 + phi(2)*delta + phi(3);

dfit = delta/100;
plo_2 = polyfit(dfit,flo,2);
pmax_2 = polyfit(dfit,fmax,2);
pcent_2 = polyfit(dfit,fcent,2);
phi_2 = polyfit(dfit,fhi,2);

plo_1 = polyfit(dfit,flo,1);
pmax_1 = polyfit(dfit,fmax,1);
pcent_1 = polyfit(dfit,fcent,1);
phi_1 = polyfit(dfit,fhi,1);

figure(3);
hold on;
plot(delta,flo,'ms','markersize',13,'MarkerFaceColor','m');
plot(delta,fmax,'bs','markersize',13,'MarkerFaceColor','b');
plot(delta,fcent,'ys','markersize',13,'MarkerFaceColor','y');
plot(delta,fhi,'ks','markersize',13,'MarkerFaceColor','k');

l = legend('FWHM Low','Peak','Centroid','FWHM High','location','Northwest');

plot(delta,pflo,'m--');
plot(delta,pfmax,'b--');
plot(delta,pfcent,'y--');
plot(delta,pfhi,'k--');

xlabel('\delta (%)','fontsize',14);
ylabel('\DeltaX (mm)','fontsize',14);
hold off;

if savE
saveas(gca,[save_dir 'disp_lines.pdf']);
saveas(gca,[save_dir 'disp_lines.png']);
saveas(gca,[save_dir 'disp_lines.tiff']);
end