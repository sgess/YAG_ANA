function phase_bar(PHAS,LINAC_KLYZ,SBST_IND,IND_ALL,Ylabel,Title,file,save_dir,savE)

Z=LINAC_KLYZ(IND_ALL);
bar_h = bar(Z,PHAS,'barwidth',2);
bar_child=get(bar_h,'Children');
index = SBST_IND(IND_ALL);
set(bar_child, 'CData',index);
title(Title,'fontsize',16);
xlabel('Klystron location (m)','fontsize',16);
ylabel(Ylabel,'fontsize',16);

if savE; saveas(gca,[save_dir '/' file '.pdf']); end;