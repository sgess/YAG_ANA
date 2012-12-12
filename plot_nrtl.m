%clear all;



sim_dir = '/Users/sgess/Desktop/data/LiTrack_scans/';
%sim_dir = '/Users/sgess/Desktop/FACET/2012/DATA/LiTrackScans/';

data_dir = '/Users/sgess/Desktop/data/E200_DATA/E200_1443/';
%data_dir = '/Users/sgess/Desktop/FACET/2012/DATA/E200_1443/';

%save_dir = '/Users/sgess/Desktop/plots/LiTrack/5mm_scan/';
save_dir = '/Users/sgess/Desktop/plots/LiTrack/NRTL_scan/';
%save_dir = '/Users/sgess/Desktop/FACET/PLOTS/5mm_scan/';

load([sim_dir 'NRTL_scan.mat']);
load([data_dir 'NRTL_1.mat']);

savE = 0;
comp_py  = 0;
plot_s10 = 0;
plot_s20 = 0;
plot_dists = 1;

s10 = 4;
s20 = 6;

blv = [15 18 20 22 24 26 28 30 32 34 36 38 40 45];
isv = [4 6 8 10 11 11.5 12 12.5 13 13.5 14 14.5 15 17];
pyv = 1e10*[2 4 6 7 8 9 10 11 11.5 12 12.5 13 14 15];

if comp_py
    PYRO = zeros(64,64);    
    for i=1:64
        for j=1:64
            PYRO(i,j)  = pyro(bl(:,i,j,s20),zz(:,i,j,s20)/1000/3e8,0.3e12,0.001);
        end
    end   
end

if plot_s20

    f5 = 505;
    f6 = 606;
    f7 = 707;
    
    figure(f5);
    contourf(1000*NAMPL,phase,1000*bl_sig(:,:,s20),blv);
    colormap(flipud(colormap));
    colorbar;
    set(gca,'FontSize',14);
    ylabel('Compressor Phase (Degrees)','fontsize',16);
    xlabel('Compressor Amplitude (MV)','fontsize',16);
    title('Bunch Length at S20 in Microns (Gaussian Sigma)','fontsize',16);
    if savE; saveas(gca,[save_dir 'bl_sig_S20.pdf']); end;
    
    figure(f6);
    contourf(1000*NAMPL,phase,I_sig(:,:,s20),isv);
    colorbar;
    set(gca,'FontSize',14);
    ylabel('Compressor Phase (Degrees)','fontsize',16);
    xlabel('Compressor Amplitude (MV)','fontsize',16);
    title('Gaussian Peak Current at S20 in kA','fontsize',16);
    if savE; saveas(gca,[save_dir 'i_sig_S20.pdf']); end;

    figure(f7);
    contourf(1000*NAMPL,phase,PYRO,pyv);
    colorbar;
    set(gca,'FontSize',14);
    ylabel('Compressor Phase (Degrees)','fontsize',16);
    xlabel('Compressor Amplitude (MV)','fontsize',16);
    title('S20 Pyrometer, 0.3 THz Filter','fontsize',16);
    if savE; saveas(gca,[save_dir 'S20pyro_03filt.pdf']); end;

end

if plot_dists
    
    nShots = length(LINESUM);
    
    minRES_phas = zeros(2,nShots);
    minRES_ampl = zeros(2,nShots);
    minRES = zeros(1,nShots);
    
    minCON_phas = zeros(2,nShots);
    minCON_ampl = zeros(2,nShots);
    minCON = zeros(1,nShots);
    
    f5 = 505;
    f6 = 606;
    f7 = 707;
    
    figure(f5);
    contourf(1000*NAMPL,phase,1000*bl_sig(:,:,s20),blv);
    colorbar;
    set(gca,'FontSize',14);
    ylabel('Compressor Phase (Degrees)','fontsize',16);
    xlabel('Compressor Amplitude (MV)','fontsize',16);
    title('Bunch Length at S20 in Microns (Gaussian Sigma)','fontsize',16);
    hold on;
    
    figure(f6);
    contourf(1000*NAMPL,phase,I_sig(:,:,s20),isv);
    colorbar;
    set(gca,'FontSize',14);
    ylabel('Compressor Phase (Degrees)','fontsize',16);
    xlabel('Compressor Amplitude (MV)','fontsize',16);
    title('Gaussian Peak Current at S20 in kA','fontsize',16);
    hold on;
   
    figure(f7);
    contourf(1000*NAMPL,phase,PYRO,pyv);
    colorbar;
    set(gca,'FontSize',14);
    ylabel('Compressor Phase (Degrees)','fontsize',16);
    xlabel('Compressor Amplitude (MV)','fontsize',16);
    title('S20 Pyrometer, 0.3 THz Filter','fontsize',16);
    hold on;
    
    for k=1:nShots
        
        [a,b] = min(RES(:,:,k));
        [c,d] = min(min(RES(:,:,k)));
        
        minRES(k) = c;
        minRES_ampl(1,k) = b(d); 
        minRES_ampl(2,k) = 1000*NAMPL(b(d));
        minRES_phas(1,k) = d;    
        minRES_phas(2,k) = phase(d);

        [a,b] = min(CON(:,:,k));
        [c,d] = min(min(CON(:,:,k)));
        
        minCON(k) = c;
        minCON_ampl(1,k) = b(d); 
        minCON_ampl(2,k) = 1000*NAMPL(b(d));
        minCON_phas(1,k) = d;    
        minCON_phas(2,k) = phase(d);
        
        figure(f5);
        plot(minCON_ampl(2,k),minCON_phas(2,k),'k*');
        
        figure(f6);
        plot(minCON_ampl(2,k),minCON_phas(2,k),'k*');
        
        figure(f7);
        plot(minCON_ampl(2,k),minCON_phas(2,k),'k*');
        
    end
    
    hold off;
        
end