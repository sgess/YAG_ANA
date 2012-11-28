clear all;



sim_dir = '/Users/sgess/Desktop/data/LiTrack_scans/';
data_dir = '/Users/sgess/Desktop/data/E200_DATA/E200_1443/';
save_dir = '/Users/sgess/Desktop/plots/LiTrack/5mm_scan/';

load([sim_dir '5mm_scan.mat']);
%load([data_dir 'RES_5mm.mat']);
load([data_dir 'RES_5mm_hi.mat']);

savE = 0;
comp_py  = 1;
plot_s10 = 0;
plot_s20 = 0;
plot_dists = 0;
plot_data = 1;

s10 = 4;
s20 = 6;

blv = [15 16 17 18.5 20 22.5 25 27.5 30 35 40 45 50 60 70 80];
fwv = [27.5 30 32.5 35 40 45 50 60 70 80 100 120 140 160 180 200];
isv = [2 4 5.5 7 8.5 10.5 12 13 14 15 16 17 17.5 18 18.5 19];
imv = [3 5 6.5 8 9.5 11 12.5 14 15 16 17 17.5 18 18.5 19 19.5];
pyv = .9e10*[3 6 8 10 12 14 16 18 20 22 24 26 28 30 31 31.6];

if comp_py
    %Compute pyro
    PYRO  = zeros(64,64);    
    for i=1:64
        for j=1:64
            PYRO(i,j)  = pyro(bl(:,i,j,s20),zz(:,i,j,s20)/1000/3e8,0.3e12,0.001);
        end
    end   
end

if plot_data
    
    d1 = 123;
    d2 = 234;
    d3 = 345;
    d4 = 456;
    
    rMIN = zeros(1,90);
    cMIN = zeros(1,90);
    for k=1:length(LINESUM)
        
        [a,b] = min(RES(:,:,k)); % b is amplitude
        [c,d] = min(min(RES(:,:,k))); % d is phase
        rMIN(k) = RES(b(d),d,k);
        
        e_temp=zeros(1,838);
        e_temp(i_start(i,j,k):(i_start(i,j,k)+length(e_interp)-1))=e_interp(:,i,j);
        
        figure(d1);
        plot(1000*zz(:,b(d),d,s20),bl(:,b(d),d,s20),'linewidth',3);
        figure(d2);
        plot(ENG_AX,e_temp,ENG_AX,double(cutLINE(:,k))/LINESUM(k));
        
        [e,f] = min(CON(:,:,k)); % b is amplitude
        [g,h] = min(min(CON(:,:,k))); % d is phase
        rMIN(k) = RES(f(h),h,k);
        
        c_temp=zeros(1,838);
        c_temp(con_start(i,j,k):(con_start(i,j,k)+length(conterp)-1))=conterp(:,i,j);
        
        figure(d3);
        plot(1000*zz(:,f(h),h,s20),bl(:,f(h),h,s20),'linewidth',3);
        figure(d4);
        plot(ENG_AX,c_temp,ENG_AX,double(cutLINE(:,k))/LINESUM(k));
        
        pause;
    end
    
end

phas = -phas;


if plot_s10
    
    figure(f1);
    contourf(1000*NAMPL,phas(:),1000*bl_sig(:,:,s10),[0 30 40 50 60 70 80 90 100 120 140 160]);
    %colormap(flipud(colormap));
    colorbar;
    ylabel('Equivalent Chirp Phase (Degrees)');
    xlabel('Compressor Amplitude (MV)');
    title('Bunch Length at S10 in Microns (Gaussian Sigma)');
    if savE; saveas(gca,[save_dir 'bl_sig_S10.pdf']); end;
    
    
    figure(f2);
    contourf(1000*NAMPL,phas(:),1000*bl_fwhm(:,:,s10),[0 30 40 50 60 70 80 90 100 120 140 160]);
    %colormap(flipud(colormap));
    colorbar;
    ylabel('Equivalent Chirp Phase (Degrees)');
    xlabel('Compressor Amplitude (MV)');
    title('Bunch Length at S10 in Microns (FWHM)');
    if savE; saveas(gca,[save_dir 'bl_fwhm_S10.pdf']); end;
    
    
    figure(f3);
    contourf(1000*NAMPL,phas(:),I_max(:,:,s10));
    colorbar;
    ylabel('Equivalent Chirp Phase (Degrees)');
    xlabel('Compressor Amplitude (MV)');
    title('Peak Current at S10 in kA');
    if savE; saveas(gca,[save_dir 'i_max_S10.pdf']); end;
    
    
    figure(f4);
    contourf(1000*NAMPL,phas(:),I_sig(:,:,s10));
    colorbar;
    ylabel('Equivalent Chirp Phase (Degrees)');
    xlabel('Compressor Amplitude (MV)');
    title('Gaussian Peak Current at S10 in kA');
    if savE; saveas(gca,[save_dir 'i_sig_S10.pdf']); end;
    
end

if plot_s20

    f5 = 505;
    f6 = 606;
    f7 = 707;
    f8 = 808;
    f9 = 909;
    
    figure(f5);
    contourf(1000*NAMPL,phas(:),1000*bl_sig(:,:,s20),blv);
    colormap(flipud(colormap));
    colorbar;
    set(gca,'FontSize',14);
    ylabel('Equivalent Chirp Phase (Degrees)','fontsize',16);
    xlabel('Compressor Amplitude (MV)','fontsize',16);
    title('Bunch Length at S20 in Microns (Gaussian Sigma)','fontsize',16);
    if savE; saveas(gca,[save_dir 'bl_sig_S20.pdf']); end;
    
    
    figure(f6);
    contourf(1000*NAMPL,phas(:),1000*bl_fwhm(:,:,s20),fwv);
    colormap(flipud(colormap));
    colorbar;
    set(gca,'FontSize',14);
    ylabel('Equivalent Chirp Phase (Degrees)','fontsize',16);
    xlabel('Compressor Amplitude (MV)','fontsize',16);
    title('Bunch Length at S20 in Microns (FWHM)','fontsize',16);
    if savE; saveas(gca,[save_dir 'bl_fwhm_S20.pdf']); end;
    
    
    figure(f7);
    contourf(1000*NAMPL,phas(:),I_max(:,:,s20),imv);
    colorbar;
    set(gca,'FontSize',14);
    ylabel('Equivalent Chirp Phase (Degrees)','fontsize',16);
    xlabel('Compressor Amplitude (MV)','fontsize',16);
    title('Peak Current at S20 in kA','fontsize',16);
    if savE; saveas(gca,[save_dir 'i_max_S20.pdf']); end;
    
    
    figure(f8);
    contourf(1000*NAMPL,phas(:),I_sig(:,:,s20),isv);
    colorbar;
    set(gca,'FontSize',14);
    ylabel('Equivalent Chirp Phase (Degrees)','fontsize',16);
    xlabel('Compressor Amplitude (MV)','fontsize',16);
    title('Gaussian Peak Current at S20 in kA','fontsize',16);
    if savE; saveas(gca,[save_dir 'i_sig_S20.pdf']); end;

    figure(f9);
    contourf(1000*NAMPL,phas(:),PYRO,pyv);
    colorbar;
    set(gca,'FontSize',14);
    ylabel('Equivalent Chirp Phase (Degrees)','fontsize',16);
    xlabel('Compressor Amplitude (MV)','fontsize',16);
    title('S20 Pyrometer, 0.3 THz Filter','fontsize',16);
    if savE; saveas(gca,[save_dir 'S20pyro_03filt.pdf']); end;

end

if plot_dists
    
    f9  = 184;
    f10 = 185;
    f11 = 186;
    f12 = 187;
    f13 = 188;
    f14 = 189;
    f15 = 190;
    f16 = 191;
    f17 = 192;
    f18 = 193;
    
    % Sigma Z
    
    [a,b] = min(bl_sig(:,:,s20)); % b is amplitude
    [c,d] = min(min(bl_sig(:,:,s20))); % d is phase
    
    bl_sig_min = bl_sig(b(d),d,s20);
    
    figure(f9);
    plot(1000*zz(:,b(d),d,s20),bl(:,b(d),d,s20),'linewidth',3);
    set(gca,'FontSize',14);
    xlabel('Z (\mum)','fontsize',16);
    ylabel('Number of particles','fontsize',16);
    title('Bunch Profile in S20 for minimum simulated sigma','fontsize',16);
    v = axis;
    text(0.55*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(b(d)),'%.2f') '^o'],'fontsize',14);
    text(0.55*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(d),'%.2f') ' MV'],'fontsize',14);
    text(0.55*v(2),0.85*v(4),['Z Sigma = ' num2str(1000*bl_sig(b(d),d,s20),'%.3f') ' \mum'],'fontsize',14);
    text(0.55*v(2),0.80*v(4),['Z FWHM = ' num2str(1000*bl_fwhm(b(d),d,s20),'%.3f') ' \mum'],'fontsize',14);
    text(0.55*v(2),0.75*v(4),['I peak = ' num2str(I_max(b(d),d,s20),'%.3f') ' kA'],'fontsize',14);
    text(0.55*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(b(d),d,s20),'%.3f') ' kA'],'fontsize',14);
    text(0.55*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(b(d),d,s20),'%.3f') ' %'],'fontsize',14);
    if savE; saveas(gca,[save_dir 'minSigBL_profS20.pdf']); end;
    
    
    figure(f10);
    plot(-ee(:,b(d),d,s20)/100,es(:,b(d),d,s20),'linewidth',3);
    set(gca,'FontSize',14);
    set(gca,'xdir','rev');
    xlabel('\delta','fontsize',16);
    ylabel('Number of particles','fontsize',16);
    title('Energy Spectrum in S20 for minimum simulated sigma','fontsize',16);
    v = axis;
    text(-0.4*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(b(d)),'%.2f') '^o'],'fontsize',14);
    text(-0.4*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(d),'%.2f') ' MV'],'fontsize',14);
    text(-0.4*v(2),0.85*v(4),['Z Sigma = ' num2str(1000*bl_sig(b(d),d,s20),'%.3f') ' \mum'],'fontsize',14);
    text(-0.4*v(2),0.80*v(4),['Z FWHM = ' num2str(1000*bl_fwhm(b(d),d,s20),'%.3f') ' \mum'],'fontsize',14);
    text(-0.4*v(2),0.75*v(4),['I peak = ' num2str(I_max(b(d),d,s20),'%.3f') ' kA'],'fontsize',14);
    text(-0.4*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(b(d),d,s20),'%.3f') ' kA'],'fontsize',14);
    text(-0.4*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(b(d),d,s20),'%.3f') ' %'],'fontsize',14);
    if savE; saveas(gca,[save_dir 'minSigES_profS20.pdf']); end;
    
    
    
    % FWHM Z
    
    [e,f] = min(bl_fwhm(:,:,s20)); % f is ampl
    [g,h] = min(min(bl_fwhm(:,:,s20))); % h is phas
    
    bl_fwhm_min = bl_fwhm(f(h),h,s20);
    
    figure(f11);
    plot(1000*zz(:,f(h),h,s20),bl(:,f(h),h,s20),'linewidth',3);
    set(gca,'FontSize',14);
    xlabel('Z (\mum)','fontsize',16);
    ylabel('Number of particles','fontsize',16);
    title('Bunch Profile in S20 for minimum simulated FWHM','fontsize',16);
    v = axis;
    text(0.45*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(f(h)),'%.2f') '^o'],'fontsize',14);
    text(0.45*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(h),'%.2f') ' MV'],'fontsize',14);
    text(0.45*v(2),0.85*v(4),['Sigma = ' num2str(1000*bl_sig(f(h),h,s20),'%.2f') ' \mum'],'fontsize',14);
    text(0.45*v(2),0.80*v(4),['FWHM = ' num2str(1000*bl_fwhm(f(h),h,s20),'%.3f') ' \mum'],'fontsize',14);
    text(0.45*v(2),0.75*v(4),['I peak = ' num2str(I_max(f(h),h,s20),'%.3f') ' kA'],'fontsize',14);
    text(0.45*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(f(h),h,s20),'%.3f') ' kA'],'fontsize',14);
    text(0.45*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(f(h),h,s20),'%.3f') ' %'],'fontsize',14);
    if savE; saveas(gca,[save_dir 'minFwhmBL_profS20.pdf']); end;
    
    
    figure(f12);
    plot(-ee(:,f(h),h,s20)/100,es(:,f(h),h,s20),'linewidth',3);
    set(gca,'FontSize',14);
    set(gca,'xdir','rev');
    xlabel('\delta','fontsize',16);
    ylabel('Number of particles','fontsize',16);
    title('Energy Spectrum in S20 for minimum simulated FWHM','fontsize',16);
    v = axis;
    text(-0.4*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(f(h)),'%.2f') '^o'],'fontsize',14);
    text(-0.4*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(h),'%.2f') ' MV'],'fontsize',14);
    text(-0.4*v(2),0.85*v(4),['Sigma = ' num2str(1000*bl_sig(f(h),h,s20),'%.2f') ' \mum'],'fontsize',14);
    text(-0.4*v(2),0.80*v(4),['FWHM = ' num2str(1000*bl_fwhm(f(h),h,s20),'%.3f') ' \mum'],'fontsize',14);
    text(-0.4*v(2),0.75*v(4),['I peak = ' num2str(I_max(f(h),h,s20),'%.3f') ' kA'],'fontsize',14);
    text(-0.4*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(f(h),h,s20),'%.3f') ' kA'],'fontsize',14);
    text(-0.4*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(f(h),h,s20),'%.3f') ' %'],'fontsize',14);
    if savE; saveas(gca,[save_dir 'minFwhmES_profS20.pdf']); end;
    
    
    
    % I peak
    
    [i,j] = max(I_max(:,:,s20)); % j is ample
    [k,l] = max(max(I_max(:,:,s20))); % l is phas
    
    i_peak_max = I_max(j(l),l,s20);
    
    figure(f13);
    plot(1000*zz(:,j(l),l,s20),bl(:,j(l),l,s20),'linewidth',3);
    set(gca,'FontSize',14);
    xlabel('Z (\mum)','fontsize',16);
    ylabel('Number of particles','fontsize',16);
    title('Bunch Profile in S20 for maximum simulated Peak Current','fontsize',16);
    v = axis;
    text(0.55*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(j(l)),'%.2f') '^o'],'fontsize',14);
    text(0.55*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(l),'%.2f') ' MV'],'fontsize',14);
    text(0.55*v(2),0.85*v(4),['Sigma = ' num2str(1000*bl_sig(j(l),l,s20),'%.3f') ' \mum'],'fontsize',14);
    text(0.55*v(2),0.80*v(4),['FWHM = ' num2str(1000*bl_fwhm(j(l),l,s20),'%.3f') ' \mum'],'fontsize',14);
    text(0.55*v(2),0.75*v(4),['I peak = ' num2str(I_max(j(l),l,s20),'%.3f') ' kA'],'fontsize',14);
    text(0.55*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(j(l),l,s20),'%.3f') ' kA'],'fontsize',14);
    text(0.55*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(j(l),l,s20),'%.3f') ' %'],'fontsize',14);
    if savE; saveas(gca,[save_dir 'maxPeakIBL_profS20.pdf']); end;
    
    
    figure(f14);
    plot(-ee(:,j(l),l,s20)/100,es(:,j(l),l,s20),'linewidth',3);
    set(gca,'FontSize',14);
    set(gca,'xdir','rev');
    xlabel('\delta','fontsize',16);
    ylabel('Number of particles','fontsize',16);
    title('Energy Spectrum in S20 for maximum simulated Peak Current','fontsize',16);
    v = axis;
    text(-0.4*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(j(l)),'%.2f') '^o'],'fontsize',14);
    text(-0.4*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(l),'%.2f') ' MV'],'fontsize',14);
    text(-0.4*v(2),0.85*v(4),['Sigma = ' num2str(1000*bl_sig(j(l),l,s20),'%.3f') ' \mum'],'fontsize',14);
    text(-0.4*v(2),0.80*v(4),['FWHM = ' num2str(1000*bl_fwhm(j(l),l,s20),'%.3f') ' \mum'],'fontsize',14);
    text(-0.4*v(2),0.75*v(4),['I peak = ' num2str(I_max(j(l),l,s20),'%.3f') ' kA'],'fontsize',14);
    text(-0.4*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(j(l),l,s20),'%.3f') ' kA'],'fontsize',14);
    text(-0.4*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(j(l),l,s20),'%.3f') ' %'],'fontsize',14);
    if savE; saveas(gca,[save_dir 'maxPeakIES_profS20.pdf']); end;
    
    
    
    
    % I sigma peak
    
    [m,n] = max(I_sig(:,:,s20)); % n is ampl
    [o,p] = max(max(I_sig(:,:,s20))); % p is phas
    
    i_sig_max = I_sig(n(p),p,s20);
    
    figure(f15);
    plot(1000*zz(:,n(p),p,s20),bl(:,n(p),p,s20),'linewidth',3);
    set(gca,'FontSize',14);
    xlabel('Z (\mum)','fontsize',16);
    ylabel('Number of particles','fontsize',16);
    title('Bunch Profile in S20 for maximum simulated Gaussian Peak Current','fontsize',16);
    v = axis;
    text(0.55*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(n(p)),'%.2f') '^o'],'fontsize',14);
    text(0.55*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(p),'%.2f') ' MV'],'fontsize',14);
    text(0.55*v(2),0.85*v(4),['Sigma = ' num2str(1000*bl_sig(n(p),p,s20),'%.3f') ' \mum'],'fontsize',14);
    text(0.55*v(2),0.80*v(4),['FWHM = ' num2str(1000*bl_fwhm(n(p),p,s20),'%.3f') ' \mum'],'fontsize',14);
    text(0.55*v(2),0.75*v(4),['I peak = ' num2str(I_max(n(p),p,s20),'%.3f') ' kA'],'fontsize',14);
    text(0.55*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(n(p),p,s20),'%.3f') ' kA'],'fontsize',14);
    text(0.55*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(n(p),p,s20),'%.3f') ' %'],'fontsize',14);
    if savE; saveas(gca,[save_dir 'maxSigIBL_profS20.pdf']); end;
    
    
    figure(f16);
    plot(-ee(:,n(p),p,s20)/100,es(:,n(p),p,s20),'linewidth',3);
    set(gca,'xdir','rev');
    set(gca,'FontSize',14);
    xlabel('\delta','fontsize',16);
    ylabel('Number of particles','fontsize',16);
    title('Energy Spectrum in S20 for maximum simulated Gaussian Peak Current','fontsize',16);
    v = axis;
    text(-0.5*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(n(p)),'%.2f') '^o'],'fontsize',14);
    text(-0.5*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(p),'%.2f') ' MV'],'fontsize',14);
    text(-0.5*v(2),0.85*v(4),['Sigma = ' num2str(1000*bl_sig(n(p),p,s20),'%.3f') ' \mum'],'fontsize',14);
    text(-0.5*v(2),0.80*v(4),['FWHM = ' num2str(1000*bl_fwhm(n(p),p,s20),'%.3f') ' \mum'],'fontsize',14);
    text(-0.5*v(2),0.75*v(4),['I peak = ' num2str(I_max(n(p),p,s20),'%.3f') ' kA'],'fontsize',14);
    text(-0.5*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(n(p),p,s20),'%.3f') ' kA'],'fontsize',14);
    text(-0.5*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(n(p),p,s20),'%.3f') ' %'],'fontsize',14);
    if savE; saveas(gca,[save_dir 'maxSigIES_profS20.pdf']); end;
    
    % pyro peak
    
    [q,r] = max(PYRO); % n is ampl
    [s,t] = max(max(PYRO)); % p is phas
    
    figure(f17);
    plot(1000*zz(:,r(t),t,s20),bl(:,r(t),t,s20),'linewidth',3);
    set(gca,'FontSize',14);
    xlabel('Z (\mum)','fontsize',16);
    ylabel('Number of particles','fontsize',16);
    title('Bunch Profile in S20 for maximum simulated Pyrometer','fontsize',16);
    v = axis;
    text(0.5*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(r(t)),'%.2f') '^o'],'fontsize',14);
    text(0.5*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(t),'%.2f') ' MV'],'fontsize',14);
    text(0.5*v(2),0.85*v(4),['Sigma = ' num2str(1000*bl_sig(r(t),t,s20),'%.3f') ' \mum'],'fontsize',14);
    text(0.5*v(2),0.80*v(4),['FWHM = ' num2str(1000*bl_fwhm(r(t),t,s20),'%.3f') ' \mum'],'fontsize',14);
    text(0.5*v(2),0.75*v(4),['I peak = ' num2str(I_max(r(t),t,s20),'%.3f') ' kA'],'fontsize',14);
    text(0.5*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(r(t),t,s20),'%.3f') ' kA'],'fontsize',14);
    text(0.5*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(r(t),t,s20),'%.3f') ' %'],'fontsize',14);
    if savE; saveas(gca,[save_dir 'maxPyro_profS20.pdf']); end;
    
    
    figure(f18);
    plot(-ee(:,r(t),t,s20)/100,es(:,r(t),t,s20),'linewidth',3);
    set(gca,'xdir','rev');
    set(gca,'FontSize',14);
    xlabel('\delta','fontsize',16);
    ylabel('Number of particles','fontsize',16);
    title('Energy Spectrum in S20 for maximum simulated Pyrometer','fontsize',16);
    v = axis;
    text(-0.5*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(r(t)),'%.2f') '^o'],'fontsize',14);
    text(-0.5*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(t),'%.2f') ' MV'],'fontsize',14);
    text(-0.5*v(2),0.85*v(4),['Sigma = ' num2str(1000*bl_sig(r(t),t,s20),'%.3f') ' \mum'],'fontsize',14);
    text(-0.5*v(2),0.80*v(4),['FWHM = ' num2str(1000*bl_fwhm(r(t),t,s20),'%.3f') ' \mum'],'fontsize',14);
    text(-0.5*v(2),0.75*v(4),['I peak = ' num2str(I_max(r(t),t,s20),'%.3f') ' kA'],'fontsize',14);
    text(-0.5*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(r(t),t,s20),'%.3f') ' kA'],'fontsize',14);
    text(-0.5*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(r(t),t,s20),'%.3f') ' %'],'fontsize',14);
    if savE; saveas(gca,[save_dir 'maxPyroES_profS20.pdf']); end;
    
end