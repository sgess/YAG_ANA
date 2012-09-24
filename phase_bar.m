function phase_bar(PHAS,LINAC_KLYZ,SBST_IND,IND_ALL,Ylabel,Title,file,num)

%DIFF=LINAC_TDES(IND_ALL_noFB) - LINAC_PACT(IND_ALL_noFB);
Z=LINAC_KLYZ(IND_ALL);
%bar_h = bar(Z,PHAS,'edgecolor','none','barwidth',2);
bar_h = bar(Z,PHAS,'barwidth',2);
bar_child=get(bar_h,'Children');
index = SBST_IND(IND_ALL);
%[~,b]=unique(SBST_IND(IND_ALL_noFB));
set(bar_child, 'CData',index);
%title('Phase error for triggered, non-feedback klystrons','fontsize',16);
title(Title,'fontsize',16);
xlabel('Klystron location (m)','fontsize',16);
%ylabel('Phase Error (degrees)','fontsize',16);
ylabel(Ylabel,'fontsize',16);
% cmap = colormap;
% text(60,3.8,'LI02','fontsize',18,'fontweight','bold','color',cmap(round(1*64/18),:));
% text(60,3.4,'LI03','fontsize',18,'fontweight','bold','color',cmap(round(2*64/18),:));
% text(60,3,'LI04','fontsize',18,'fontweight','bold','color',cmap(round(3*64/18),:));
% text(60,2.6,'LI05','fontsize',18,'fontweight','bold','color',cmap(round(4*64/18),:));
% text(60,2.2,'LI06','fontsize',18,'fontweight','bold','color',cmap(round(5*64/18),:));
% 
% text(260,3.8,'LI09','fontsize',18,'fontweight','bold','color',cmap(round(8*64/18),:));
% text(260,3.4,'LI10','fontsize',18,'fontweight','bold','color',cmap(round(9*64/18),:));
% text(260,3,'LI11','fontsize',18,'fontweight','bold','color',cmap(round(10*64/18),:));
% text(260,2.6,'LI12','fontsize',18,'fontweight','bold','color',cmap(round(11*64/18),:));
% text(260,2.2,'LI13','fontsize',18,'fontweight','bold','color',cmap(round(12*64/18),:));
% 
% text(460,3.8,'LI14','fontsize',18,'fontweight','bold','color',cmap(round(13*64/18),:));
% text(460,3.4,'LI15','fontsize',18,'fontweight','bold','color',cmap(round(14*64/18),:));
% text(460,3,'LI16','fontsize',18,'fontweight','bold','color',cmap(round(15*64/18),:));
% text(460,2.6,'LI19','fontsize',18,'fontweight','bold','color',cmap(round(18*64/18),:));
plot_dir = ['/Users/sgess/Desktop/plots/E200/E200_' num2str(num)];
if ~exist(plot_dir,'dir')
    mkdir(plot_dir);
end

saveas(gca,[plot_dir '/' file '.pdf']);