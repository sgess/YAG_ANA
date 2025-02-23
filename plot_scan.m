load('scan64.mat');
%save_dir = '/Users/sgess/Desktop/plots/LiTrack/scan64/';
save_dir = '/Users/sgess/Desktop/FACET/PLOTS/scans/';

savE = 1;

figure(f1);
contourf(1000*NAMPL,phas(:,1),1000*bl_sig(:,:,2),[0 30 40 50 60 70 80 90 100 120 140 160]);
colormap(flipud(colormap));
colorbar;
ylabel('Equivalent Chirp Phase (Degrees)');
xlabel('Compressor Amplitude (MV)');
title('Bunch Length at S10 in Microns (Gaussian Sigma)');
if savE; saveas(gca,[save_dir 'bl_sig_S10.pdf']); end;


figure(f2);
contourf(1000*NAMPL,phas(:,1),1000*bl_fwhm(:,:,2),[0 30 40 50 60 70 80 90 100 120 140 160]);
colormap(flipud(colormap));
colorbar;
ylabel('Equivalent Chirp Phase (Degrees)');
xlabel('Compressor Amplitude (MV)');
title('Bunch Length at S10 in Microns (FWHM)');
if savE; saveas(gca,[save_dir 'bl_fwhm_S10.pdf']); end;


figure(f3);
contourf(1000*NAMPL,phas(:,1),I_max(:,:,2));
colorbar;
ylabel('Equivalent Chirp Phase (Degrees)');
xlabel('Compressor Amplitude (MV)');
title('Peak Current at S10 in kA');
if savE; saveas(gca,[save_dir 'i_max_S10.pdf']); end;


figure(f4);
contourf(1000*NAMPL,phas(:,1),I_sig(:,:,2));
colorbar;
ylabel('Equivalent Chirp Phase (Degrees)');
xlabel('Compressor Amplitude (MV)');
title('Gaussian Peak Current at S10 in kA');
if savE; saveas(gca,[save_dir 'i_sig_S10.pdf']); end;



figure(f5);
contourf(1000*NAMPL,phas(:,1),1000*bl_sig(:,:,3),[0 10 15 20 25 30 35 40 45 50 60 70 80 90 100]);
colormap(flipud(colormap));
colorbar;
ylabel('Equivalent Chirp Phase (Degrees)');
xlabel('Compressor Amplitude (MV)');
title('Bunch Length at S20 in Microns (Gaussian Sigma)');
if savE; saveas(gca,[save_dir 'bl_sig_S20.pdf']); end;


figure(f6);
contourf(1000*NAMPL,phas(:,1),1000*bl_fwhm(:,:,3),[0 15 30 45 60 75 90 120 140 160 180 200]);
colormap(flipud(colormap));
colorbar;
ylabel('Equivalent Chirp Phase (Degrees)');
xlabel('Compressor Amplitude (MV)');
title('Bunch Length at S20 in Microns (FWHM)');
if savE; saveas(gca,[save_dir 'bl_fwhm_S20.pdf']); end;


figure(f7);
contourf(1000*NAMPL,phas(:,1),I_max(:,:,3),[0 5 10 11 12 13 14 15 16 17 18 19]);
colorbar;
ylabel('Equivalent Chirp Phase (Degrees)');
xlabel('Compressor Amplitude (MV)');
title('Peak Current at S20 in kA');
if savE; saveas(gca,[save_dir 'i_max_S20.pdf']); end;


figure(f8);
contourf(1000*NAMPL,phas(:,1),I_sig(:,:,3),[0 5 10 11 12 13 14 15 16 17 18 19]);
colorbar;
ylabel('Equivalent Chirp Phase (Degrees)');
xlabel('Compressor Amplitude (MV)');
title('Gaussian Peak Current at S20 in kA');
if savE; saveas(gca,[save_dir 'i_sig_S20.pdf']); end;



% Sigma Z

[a,b] = min(bl_sig(:,:,3));
[c,d] = min(min(bl_sig(:,:,3)));

bl_sig_min = bl_sig(b(d),d,3);

figure(f9);
plot(bl(:,b(d),d,3));
xlabel('Bunch Profile (Unit)');
ylabel('Number of particles');
title('Bunch Profile in S20 for minimum simulated sigma');
v = axis;
text(0.7*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(b(d),d),'%.2f') ' degrees']);
text(0.7*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(d),'%.2f') ' MV']);
text(0.7*v(2),0.85*v(4),['Z Sigma = ' num2str(1000*bl_sig(b(d),d,3),'%.3f') ' \mum']);
text(0.7*v(2),0.80*v(4),['Z FWHM = ' num2str(1000*bl_fwhm(b(d),d,3),'%.3f') ' \mum']);
text(0.7*v(2),0.75*v(4),['I peak = ' num2str(I_max(b(d),d,3),'%.3f') ' kA']);
text(0.7*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(b(d),d,3),'%.3f') ' kA']);
text(0.7*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(b(d),d,3),'%.3f') ' %']);
if savE; saveas(gca,[save_dir 'minSigBL_profS20.pdf']); end;


figure(f10);
plot(es(:,b(d),d,3));
xlabel('Energy Spread (Unit)');
ylabel('Number of particles');
title('Energy Spectrum in S20 for minimum simulated sigma');
v = axis;
text(0.7*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(b(d),d),'%.2f') ' degrees']);
text(0.7*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(d),'%.2f') ' MV']);
text(0.7*v(2),0.85*v(4),['Z Sigma = ' num2str(1000*bl_sig(b(d),d,3),'%.3f') ' \mum']);
text(0.7*v(2),0.80*v(4),['Z FWHM = ' num2str(1000*bl_fwhm(b(d),d,3),'%.3f') ' \mum']);
text(0.7*v(2),0.75*v(4),['I peak = ' num2str(I_max(b(d),d,3),'%.3f') ' kA']);
text(0.7*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(b(d),d,3),'%.3f') ' kA']);
text(0.7*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(b(d),d,3),'%.3f') ' %']);
if savE; saveas(gca,[save_dir 'minSigES_profS20.pdf']); end;



% FWHM Z

[e,f] = min(bl_fwhm(:,:,3));
[g,h] = min(min(bl_fwhm(:,:,3)));

bl_fwhm_min = bl_fwhm(f(h),h,3);

figure(f11);
plot(bl(:,f(h),h,3));
xlabel('Bunch Profile (Unit)');
ylabel('Number of particles');
title('Bunch Profile in S20 for minimum simulated FWHM');
v = axis;
text(0.7*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(f(h),h),'%.2f') ' degrees']);
text(0.7*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(h),'%.2f') ' MV']);
text(0.7*v(2),0.85*v(4),['Sigma = ' num2str(1000*bl_sig(f(h),h,3),'%.2f') ' \mum']); 
text(0.7*v(2),0.80*v(4),['FWHM = ' num2str(1000*bl_fwhm(f(h),h,3),'%.3f') ' \mum']);
text(0.7*v(2),0.75*v(4),['I peak = ' num2str(I_max(f(h),h,3),'%.3f') ' kA']);
text(0.7*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(f(h),h,3),'%.3f') ' kA']);
text(0.7*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(f(h),h,3),'%.3f') ' %']);
if savE; saveas(gca,[save_dir 'minFwhmBL_profS20.pdf']); end;


figure(f12);
plot(es(:,f(h),h,3));
xlabel('Energy Spread (Unit)');
ylabel('Number of particles');
title('Energy Spectrum in S20 for minimum simulated FWHM');
v = axis;
text(0.7*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(f(h),h),'%.2f') ' degrees']);
text(0.7*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(h),'%.2f') ' MV']);
text(0.7*v(2),0.85*v(4),['Sigma = ' num2str(1000*bl_sig(f(h),h,3),'%.2f') ' \mum']); 
text(0.7*v(2),0.80*v(4),['FWHM = ' num2str(1000*bl_fwhm(f(h),h,3),'%.3f') ' \mum']);
text(0.7*v(2),0.75*v(4),['I peak = ' num2str(I_max(f(h),h,3),'%.3f') ' kA']);
text(0.7*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(f(h),h,3),'%.3f') ' kA']);
text(0.7*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(f(h),h,3),'%.3f') ' %']);
if savE; saveas(gca,[save_dir 'minFwhmES_profS20.pdf']); end;



% I peak

[i,j] = max(I_max(:,:,3));
[k,l] = max(max(I_max(:,:,3)));

i_peak_max = I_max(j(l),l,3);

figure(f13);
plot(bl(:,j(l),l,3));
xlabel('Bunch Profile (Unit)');
ylabel('Number of particles');
title('Bunch Profile in S20 for maximum simulated Peak Current');
v = axis;
text(0.7*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(j(l),l),'%.2f') ' degrees']);
text(0.7*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(l),'%.2f') ' MV']);
text(0.7*v(2),0.85*v(4),['Sigma = ' num2str(1000*bl_sig(j(l),l,3),'%.3f') ' \mum']);
text(0.7*v(2),0.80*v(4),['FWHM = ' num2str(1000*bl_fwhm(j(l),l,3),'%.3f') ' \mum']);
text(0.7*v(2),0.75*v(4),['I peak = ' num2str(I_max(j(l),l,3),'%.3f') ' kA']);
text(0.7*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(j(l),l,3),'%.3f') ' kA']);
text(0.7*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(j(l),l,3),'%.3f') ' %']);
if savE; saveas(gca,[save_dir 'maxPeakIBL_profS20.pdf']); end;


figure(f14);
plot(es(:,j(l),l,3));
xlabel('Energy Spread (Unit)');
ylabel('Number of particles');
title('Energy Spectrum in S20 for maximum simulated Peak Current');
v = axis;
text(0.7*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(j(l),l),'%.2f') ' degrees']);
text(0.7*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(l),'%.2f') ' MV']);
text(0.7*v(2),0.85*v(4),['Sigma = ' num2str(1000*bl_sig(j(l),l,3),'%.3f') ' \mum']);
text(0.7*v(2),0.80*v(4),['FWHM = ' num2str(1000*bl_fwhm(j(l),l,3),'%.3f') ' \mum']);
text(0.7*v(2),0.75*v(4),['I peak = ' num2str(I_max(j(l),l,3),'%.3f') ' kA']);
text(0.7*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(j(l),l,3),'%.3f') ' kA']);
text(0.7*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(j(l),l,3),'%.3f') ' %']);
if savE; saveas(gca,[save_dir 'maxPeakIES_profS20.pdf']); end;




% I sigma peak

[m,n] = max(I_sig(:,:,3));
[o,p] = max(max(I_sig(:,:,3)));

i_sig_max = I_sig(n(p),p,3);

figure(f15);
plot(bl(:,n(p),p,3));
xlabel('Bunch Profile (Unit)');
ylabel('Number of particles');
title('Bunch Profile in S20 for maximum simulated Gaussian Peak Current');
v = axis;
text(0.7*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(n(p),p),'%.2f') ' degrees']);
text(0.7*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(p),'%.2f') ' MV']);
text(0.7*v(2),0.85*v(4),['Sigma = ' num2str(1000*bl_sig(n(p),p,3),'%.3f') ' \mum']);
text(0.7*v(2),0.80*v(4),['FWHM = ' num2str(1000*bl_fwhm(n(p),p,3),'%.3f') ' \mum']);
text(0.7*v(2),0.75*v(4),['I peak = ' num2str(I_max(n(p),p,3),'%.3f') ' kA']);
text(0.7*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(n(p),p,3),'%.3f') ' kA']);
text(0.7*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(n(p),p,3),'%.3f') ' %']);
if savE; saveas(gca,[save_dir 'maxSigIBL_profS20.pdf']); end;


figure(f16);
plot(es(:,n(p),p,3));
xlabel('Energy Spread (Unit)');
ylabel('Number of particles');
title('Energy Spectrum in S20 for maximum simulated Gaussian Peak Current');
v = axis;
text(0.7*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(n(p),p),'%.2f') ' degrees']);
text(0.7*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(p),'%.2f') ' MV']);
text(0.7*v(2),0.85*v(4),['Sigma = ' num2str(1000*bl_sig(n(p),p,3),'%.3f') ' \mum']);
text(0.7*v(2),0.80*v(4),['FWHM = ' num2str(1000*bl_fwhm(n(p),p,3),'%.3f') ' \mum']);
text(0.7*v(2),0.75*v(4),['I peak = ' num2str(I_max(n(p),p,3),'%.3f') ' kA']);
text(0.7*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(n(p),p,3),'%.3f') ' kA']);
text(0.7*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(n(p),p,3),'%.3f') ' %']);
if savE; saveas(gca,[save_dir 'maxSigIES_profS20.pdf']); end;

