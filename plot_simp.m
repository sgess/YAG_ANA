clear all;
%load('simp_scan.mat');
%load('fine_scan.mat');
load('/Users/sgess/Desktop/FACET/2012/DATA/LiTrackScans/fine_scan.mat');
%load('/Users/sgess/Desktop/data/LiTrack_scans/fine_scan.mat');
%save_dir = '/Users/sgess/Desktop/plots/LiTrack/simp_scan/';
%save_dir = '/Users/sgess/Desktop/plots/LiTrack/fine_scan/';
%save_dir = '/Users/sgess/Desktop/FACET/PLOTS/simp_scan/';
save_dir = '/Users/sgess/Desktop/FACET/PLOTS/fine_scan/';
%save_dir = '/Users/sgess/Desktop/plots/fine_scan/';

savE = 0;

s10 = 4;
s20 = 6;

if 1

%Compute pyro
PYRO  = zeros(64,64);
%DCPY  = zeros(64,64);
%HIPY  = zeros(64,64);
%HIPY2 = zeros(64,64);
%HIPY3 = zeros(64,64);
%HIPY4 = zeros(64,64);
for i=1:64
   for j=1:64
       PYRO(i,j)  = pyro(bl(:,i,j,s20),zz(:,i,j,s20)/1000/3e8,0.3e12);
       %DCPY(i,j)  = pyro(bl(:,i,j,s10),1);
       %HIPY(i,j)  = pyro(bl(:,i,j,s10),10);
       %HIPY2(i,j) = pyro(bl(:,i,j,s10),6);
       %HIPY3(i,j) = pyro(bl(:,i,j,s10),4);
       %HIPY4(i,j) = pyro(bl(:,i,j,s10),2);
   end
end

end

%phas = -phas;

if 0

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



figure(f5);
contourf(1000*NAMPL,phas(:),1000*bl_sig(:,:,s20),[0 10 15 17 22 25 30 35 40 50 60 70 80 90 100]);
%colormap(flipud(colormap));
colorbar;
ylabel('Equivalent Chirp Phase (Degrees)');
xlabel('Compressor Amplitude (MV)');
title('Bunch Length at S20 in Microns (Gaussian Sigma)');
if savE; saveas(gca,[save_dir 'bl_sig_S20.pdf']); end;


figure(f6);
contourf(1000*NAMPL,phas(:),1000*bl_fwhm(:,:,s20),[0 20 30 34 44 50 60 70 80 100 120 140 160 180 200]);
%colormap(flipud(colormap));
colorbar;
ylabel('Equivalent Chirp Phase (Degrees)');
xlabel('Compressor Amplitude (MV)');
title('Bunch Length at S20 in Microns (FWHM)');
if savE; saveas(gca,[save_dir 'bl_fwhm_S20.pdf']); end;


figure(f7);
contourf(1000*NAMPL,phas(:),I_max(:,:,s20),[0 5 10 11 12 13 14 15 16 17 18 19]);
colorbar;
ylabel('Equivalent Chirp Phase (Degrees)');
xlabel('Compressor Amplitude (MV)');
title('Peak Current at S20 in kA');
if savE; saveas(gca,[save_dir 'i_max_S20.pdf']); end;


figure(f8);
contourf(1000*NAMPL,phas(:),I_sig(:,:,s20),[0 5 10 11 12 13 14 15 16 17 18 19]);
colorbar;
ylabel('Equivalent Chirp Phase (Degrees)');
xlabel('Compressor Amplitude (MV)');
title('Gaussian Peak Current at S20 in kA');
if savE; saveas(gca,[save_dir 'i_sig_S20.pdf']); end;

end

if 0

figure(f9);
contourf(1000*NAMPL,phas(:),PYRO);
colorbar;
ylabel('Equivalent Chirp Phase (Degrees)');
xlabel('Compressor Amplitude (MV)');
%title('Pyrometer, No Filter');
%if savE; saveas(gca,[save_dir 'pyro_nofilt.pdf']); end;
title('S18 Pyrometer, No Filter');
if savE; saveas(gca,[save_dir 'S18pyro_nofilt.pdf']); end;

figure(f10);
contourf(1000*NAMPL,phas(:),DCPY);
colorbar;
ylabel('Equivalent Chirp Phase (Degrees)');
xlabel('Compressor Amplitude (MV)');
%title('Pyrometer, DC Removed');
%if savE; saveas(gca,[save_dir 'pyro_dcfilt.pdf']); end;
title('S18 Pyrometer, DC Removed');
if savE; saveas(gca,[save_dir 'S18pyro_dcfilt.pdf']); end;

figure(f11);
contourf(1000*NAMPL,phas(:),HIPY);
colorbar;
ylabel('Equivalent Chirp Phase (Degrees)');
xlabel('Compressor Amplitude (MV)');
%title('Pyrometer, High Pass filter (5 THz)');
%if savE; saveas(gca,[save_dir 'pyro_T5filt.pdf']); end;
title('S18 Pyrometer, High Pass filter (5 THz)');
if savE; saveas(gca,[save_dir 'S18pyro_T5filt.pdf']); end;

figure(f12);
contourf(1000*NAMPL,phas(:),HIPY2);
colorbar;
ylabel('Equivalent Chirp Phase (Degrees)');
xlabel('Compressor Amplitude (MV)');
%title('Pyrometer, High Pass filter (3 THz)');
%if savE; saveas(gca,[save_dir 'pyro_T3filt.pdf']); end;
title('S18 Pyrometer, High Pass filter (3 THz)');
if savE; saveas(gca,[save_dir 'S18pyro_T3filt.pdf']); end;

figure(f13);
contourf(1000*NAMPL,phas(:),HIPY3);
colorbar;
ylabel('Equivalent Chirp Phase (Degrees)');
xlabel('Compressor Amplitude (MV)');
%title('Pyrometer, High Pass filter (2 THz)');
%if savE; saveas(gca,[save_dir 'pyro_T2filt.pdf']); end;
title('S18 Pyrometer, High Pass filter (2 THz)');
if savE; saveas(gca,[save_dir 'S18pyro_T2filt.pdf']); end;

figure(f14);
contourf(1000*NAMPL,phas(:),HIPY4);
colorbar;
ylabel('Equivalent Chirp Phase (Degrees)');
xlabel('Compressor Amplitude (MV)');
%title('Pyrometer, High Pass filter (1 THz)');
%if savE; saveas(gca,[save_dir 'pyro_T1filt.pdf']); end;
title('S18 Pyrometer, High Pass filter (1 THz)');
if savE; saveas(gca,[save_dir 'S18 pyro_T1filt.pdf']); end;

end

if 0

[a,b] = max(PYRO);
[c,d] = max(max(PYRO));

pyro_max = PYRO(b(d),d);

figure(f9);
y = fft(bl(:,b(d),d,s20));
f = 5e11*(0:255);
semilogy(f(1:128),log(abs(y(1:128))));
xlabel('Frequency');
ylabel('Amplitude');
title('FFT of max pyro (no filter)');
axis([0 6.5e13 3 20]);
if savE; saveas(gca,[save_dir 'fft_maxPy.pdf']); end;

% figure(f9);
% plot(bl(:,b(d),d,s20));
% xlabel('Bunch Profile (Unit)');
% ylabel('Number of particles');
% title('Bunch Profile in S20 for maximum simulated pyro, no filter');
% v = axis;
% text(0.7*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(b(d)),'%.2f') ' degrees']);
% text(0.7*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(d),'%.2f') ' MV']);
% text(0.7*v(2),0.85*v(4),['Z Sigma = ' num2str(1000*bl_sig(b(d),d,s20),'%.3f') ' \mum']);
% text(0.7*v(2),0.80*v(4),['Z FWHM = ' num2str(1000*bl_fwhm(b(d),d,s20),'%.3f') ' \mum']);
% text(0.7*v(2),0.75*v(4),['I peak = ' num2str(I_max(b(d),d,s20),'%.3f') ' kA']);
% text(0.7*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(b(d),d,s20),'%.3f') ' kA']);
% text(0.7*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(b(d),d,s20),'%.3f') ' %']);
% if savE; saveas(gca,[save_dir 'maxPy_noFilt_prof.pdf']); end;
% 
% figure(f10);
% plot(es(:,b(d),d,s20));
% xlabel('Energy Spread (Unit)');
% ylabel('Number of particles');
% title('Energy Spectrum in S20 for maximum simulated pyro, no filter');
% v = axis;
% text(0.7*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(b(d)),'%.2f') ' degrees']);
% text(0.7*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(d),'%.2f') ' MV']);
% text(0.7*v(2),0.85*v(4),['Z Sigma = ' num2str(1000*bl_sig(b(d),d,s20),'%.3f') ' \mum']);
% text(0.7*v(2),0.80*v(4),['Z FWHM = ' num2str(1000*bl_fwhm(b(d),d,s20),'%.3f') ' \mum']);
% text(0.7*v(2),0.75*v(4),['I peak = ' num2str(I_max(b(d),d,s20),'%.3f') ' kA']);
% text(0.7*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(b(d),d,s20),'%.3f') ' kA']);
% text(0.7*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(b(d),d,s20),'%.3f') ' %']);
% if savE; saveas(gca,[save_dir 'maxPy_noFilt_es.pdf']); end;
% 
% 
% [a,b] = max(DCPY);
% [c,d] = max(max(DCPY));
% 
% dc_max = DCPY(b(d),d);
% 
% figure(f9);
% plot(bl(:,b(d),d,s20));
% xlabel('Bunch Profile (Unit)');
% ylabel('Number of particles');
% title('Bunch Profile in S20 for maximum simulated pyro, DC filter');
% v = axis;
% text(0.7*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(b(d)),'%.2f') ' degrees']);
% text(0.7*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(d),'%.2f') ' MV']);
% text(0.7*v(2),0.85*v(4),['Z Sigma = ' num2str(1000*bl_sig(b(d),d,s20),'%.3f') ' \mum']);
% text(0.7*v(2),0.80*v(4),['Z FWHM = ' num2str(1000*bl_fwhm(b(d),d,s20),'%.3f') ' \mum']);
% text(0.7*v(2),0.75*v(4),['I peak = ' num2str(I_max(b(d),d,s20),'%.3f') ' kA']);
% text(0.7*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(b(d),d,s20),'%.3f') ' kA']);
% text(0.7*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(b(d),d,s20),'%.3f') ' %']);
% if savE; saveas(gca,[save_dir 'maxPy_dcFilt_prof.pdf']); end;
% 
% figure(f10);
% plot(es(:,b(d),d,s20));
% xlabel('Energy Spread (Unit)');
% ylabel('Number of particles');
% title('Energy Spectrum in S20 for maximum simulated pyro, DC filter');
% v = axis;
% text(0.7*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(b(d)),'%.2f') ' degrees']);
% text(0.7*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(d),'%.2f') ' MV']);
% text(0.7*v(2),0.85*v(4),['Z Sigma = ' num2str(1000*bl_sig(b(d),d,s20),'%.3f') ' \mum']);
% text(0.7*v(2),0.80*v(4),['Z FWHM = ' num2str(1000*bl_fwhm(b(d),d,s20),'%.3f') ' \mum']);
% text(0.7*v(2),0.75*v(4),['I peak = ' num2str(I_max(b(d),d,s20),'%.3f') ' kA']);
% text(0.7*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(b(d),d,s20),'%.3f') ' kA']);
% text(0.7*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(b(d),d,s20),'%.3f') ' %']);
% if savE; saveas(gca,[save_dir 'maxPy_dcFilt_es.pdf']); end;
% 
% [a,b] = max(HIPY);
% [c,d] = max(max(HIPY));
% 
% hi_max = HIPY(b(d),d);
% 
% figure(f9);
% plot(bl(:,b(d),d,s20));
% xlabel('Bunch Profile (Unit)');
% ylabel('Number of particles');
% title('Bunch Profile in S20 for maximum simulated pyro, 5 THz filter');
% v = axis;
% text(0.7*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(b(d)),'%.2f') ' degrees']);
% text(0.7*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(d),'%.2f') ' MV']);
% text(0.7*v(2),0.85*v(4),['Z Sigma = ' num2str(1000*bl_sig(b(d),d,s20),'%.3f') ' \mum']);
% text(0.7*v(2),0.80*v(4),['Z FWHM = ' num2str(1000*bl_fwhm(b(d),d,s20),'%.3f') ' \mum']);
% text(0.7*v(2),0.75*v(4),['I peak = ' num2str(I_max(b(d),d,s20),'%.3f') ' kA']);
% text(0.7*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(b(d),d,s20),'%.3f') ' kA']);
% text(0.7*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(b(d),d,s20),'%.3f') ' %']);
% if savE; saveas(gca,[save_dir 'maxPy_5TFilt_prof.pdf']); end;
% 
% figure(f10);
% plot(es(:,b(d),d,s20));
% xlabel('Energy Spread (Unit)');
% ylabel('Number of particles');
% title('Energy Spectrum in S20 for maximum simulated pyro, 5 THz filter');
% v = axis;
% text(0.7*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(b(d)),'%.2f') ' degrees']);
% text(0.7*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(d),'%.2f') ' MV']);
% text(0.7*v(2),0.85*v(4),['Z Sigma = ' num2str(1000*bl_sig(b(d),d,s20),'%.3f') ' \mum']);
% text(0.7*v(2),0.80*v(4),['Z FWHM = ' num2str(1000*bl_fwhm(b(d),d,s20),'%.3f') ' \mum']);
% text(0.7*v(2),0.75*v(4),['I peak = ' num2str(I_max(b(d),d,s20),'%.3f') ' kA']);
% text(0.7*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(b(d),d,s20),'%.3f') ' kA']);
% text(0.7*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(b(d),d,s20),'%.3f') ' %']);
% if savE; saveas(gca,[save_dir 'maxPy_5TFilt_es.pdf']); end;
% 
% [a,b] = max(HIPY3);
% [c,d] = max(max(HIPY3));
% 
% hi3_max = HIPY3(b(d),d);
% 
% figure(f9);
% plot(bl(:,b(d),d,s20));
% xlabel('Bunch Profile (Unit)');
% ylabel('Number of particles');
% title('Bunch Profile in S20 for maximum simulated pyro, 2 THz filter');
% v = axis;
% text(0.7*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(b(d)),'%.2f') ' degrees']);
% text(0.7*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(d),'%.2f') ' MV']);
% text(0.7*v(2),0.85*v(4),['Z Sigma = ' num2str(1000*bl_sig(b(d),d,s20),'%.3f') ' \mum']);
% text(0.7*v(2),0.80*v(4),['Z FWHM = ' num2str(1000*bl_fwhm(b(d),d,s20),'%.3f') ' \mum']);
% text(0.7*v(2),0.75*v(4),['I peak = ' num2str(I_max(b(d),d,s20),'%.3f') ' kA']);
% text(0.7*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(b(d),d,s20),'%.3f') ' kA']);
% text(0.7*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(b(d),d,s20),'%.3f') ' %']);
% if savE; saveas(gca,[save_dir 'maxPy_2TFilt_prof.pdf']); end;
% 
% figure(f10);
% plot(es(:,b(d),d,s20));
% xlabel('Energy Spread (Unit)');
% ylabel('Number of particles');
% title('Energy Spectrum in S20 for maximum simulated pyro, 2 THz filter');
% v = axis;
% text(0.7*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(b(d)),'%.2f') ' degrees']);
% text(0.7*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(d),'%.2f') ' MV']);
% text(0.7*v(2),0.85*v(4),['Z Sigma = ' num2str(1000*bl_sig(b(d),d,s20),'%.3f') ' \mum']);
% text(0.7*v(2),0.80*v(4),['Z FWHM = ' num2str(1000*bl_fwhm(b(d),d,s20),'%.3f') ' \mum']);
% text(0.7*v(2),0.75*v(4),['I peak = ' num2str(I_max(b(d),d,s20),'%.3f') ' kA']);
% text(0.7*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(b(d),d,s20),'%.3f') ' kA']);
% text(0.7*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(b(d),d,s20),'%.3f') ' %']);
% if savE; saveas(gca,[save_dir 'maxPy_2TFilt_es.pdf']); end;

end

if 0

    f9  = 184;
    f10 = 185;
    f11 = 186;
    f12 = 187;
    f13 = 188;
    f14 = 189;
    f15 = 190;
    f16 = 191;
    
% Sigma Z

[a,b] = min(bl_sig(:,:,s20)); % b is amplitude
[c,d] = min(min(bl_sig(:,:,s20))); % d is phase

bl_sig_min = bl_sig(b(d),d,s20);

figure(f9);
plot(bl(:,b(d),d,s20));
xlabel('Bunch Profile (Unit)');
ylabel('Number of particles');
title('Bunch Profile in S20 for minimum simulated sigma');
v = axis;
text(0.7*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(b(d)),'%.2f') ' degrees']);
text(0.7*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(d),'%.2f') ' MV']);
text(0.7*v(2),0.85*v(4),['Z Sigma = ' num2str(1000*bl_sig(b(d),d,s20),'%.3f') ' \mum']);
text(0.7*v(2),0.80*v(4),['Z FWHM = ' num2str(1000*bl_fwhm(b(d),d,s20),'%.3f') ' \mum']);
text(0.7*v(2),0.75*v(4),['I peak = ' num2str(I_max(b(d),d,s20),'%.3f') ' kA']);
text(0.7*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(b(d),d,s20),'%.3f') ' kA']);
text(0.7*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(b(d),d,s20),'%.3f') ' %']);
if savE; saveas(gca,[save_dir 'minSigBL_profS20.pdf']); end;


figure(f10);
plot(-ee(:,b(d),d,s20),es(:,b(d),d,s20));
set(gca,'xdir','rev');
xlabel('Energy Spread (Unit)');
ylabel('Number of particles');
title('Energy Spectrum in S20 for minimum simulated sigma');
v = axis;
text(0.7*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(b(d)),'%.2f') ' degrees']);
text(0.7*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(d),'%.2f') ' MV']);
text(0.7*v(2),0.85*v(4),['Z Sigma = ' num2str(1000*bl_sig(b(d),d,s20),'%.3f') ' \mum']);
text(0.7*v(2),0.80*v(4),['Z FWHM = ' num2str(1000*bl_fwhm(b(d),d,s20),'%.3f') ' \mum']);
text(0.7*v(2),0.75*v(4),['I peak = ' num2str(I_max(b(d),d,s20),'%.3f') ' kA']);
text(0.7*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(b(d),d,s20),'%.3f') ' kA']);
text(0.7*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(b(d),d,s20),'%.3f') ' %']);
if savE; saveas(gca,[save_dir 'minSigES_profS20.pdf']); end;



% FWHM Z

[e,f] = min(bl_fwhm(:,:,s20)); % f is ampl
[g,h] = min(min(bl_fwhm(:,:,s20))); % h is phas

bl_fwhm_min = bl_fwhm(f(h),h,s20);

figure(f11);
plot(bl(:,f(h),h,s20));
xlabel('Bunch Profile (Unit)');
ylabel('Number of particles');
title('Bunch Profile in S20 for minimum simulated FWHM');
v = axis;
text(0.7*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(h),'%.2f') ' degrees']);
text(0.7*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(f(h)),'%.2f') ' MV']);
text(0.7*v(2),0.85*v(4),['Sigma = ' num2str(1000*bl_sig(f(h),h,s20),'%.2f') ' \mum']); 
text(0.7*v(2),0.80*v(4),['FWHM = ' num2str(1000*bl_fwhm(f(h),h,s20),'%.3f') ' \mum']);
text(0.7*v(2),0.75*v(4),['I peak = ' num2str(I_max(f(h),h,s20),'%.3f') ' kA']);
text(0.7*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(f(h),h,s20),'%.3f') ' kA']);
text(0.7*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(f(h),h,s20),'%.3f') ' %']);
if savE; saveas(gca,[save_dir 'minFwhmBL_profS20.pdf']); end;


figure(f12);
plot(es(:,f(h),h,3));
xlabel('Energy Spread (Unit)');
ylabel('Number of particles');
title('Energy Spectrum in S20 for minimum simulated FWHM');
v = axis;
text(0.7*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(h),'%.2f') ' degrees']);
text(0.7*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(f(h)),'%.2f') ' MV']);
text(0.7*v(2),0.85*v(4),['Sigma = ' num2str(1000*bl_sig(f(h),h,s20),'%.2f') ' \mum']); 
text(0.7*v(2),0.80*v(4),['FWHM = ' num2str(1000*bl_fwhm(f(h),h,s20),'%.3f') ' \mum']);
text(0.7*v(2),0.75*v(4),['I peak = ' num2str(I_max(f(h),h,s20),'%.3f') ' kA']);
text(0.7*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(f(h),h,s20),'%.3f') ' kA']);
text(0.7*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(f(h),h,s20),'%.3f') ' %']);
if savE; saveas(gca,[save_dir 'minFwhmES_profS20.pdf']); end;



% I peak

[i,j] = max(I_max(:,:,s20)); % j is ample
[k,l] = max(max(I_max(:,:,s20))); % l is phas

i_peak_max = I_max(j(l),l,s20);

figure(f13);
plot(bl(:,j(l),l,s20));
xlabel('Bunch Profile (Unit)');
ylabel('Number of particles');
title('Bunch Profile in S20 for maximum simulated Peak Current');
v = axis;
text(0.7*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(l),'%.2f') ' degrees']);
text(0.7*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(j(l)),'%.2f') ' MV']);
text(0.7*v(2),0.85*v(4),['Sigma = ' num2str(1000*bl_sig(j(l),l,s20),'%.3f') ' \mum']);
text(0.7*v(2),0.80*v(4),['FWHM = ' num2str(1000*bl_fwhm(j(l),l,s20),'%.3f') ' \mum']);
text(0.7*v(2),0.75*v(4),['I peak = ' num2str(I_max(j(l),l,s20),'%.3f') ' kA']);
text(0.7*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(j(l),l,s20),'%.3f') ' kA']);
text(0.7*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(j(l),l,s20),'%.3f') ' %']);
if savE; saveas(gca,[save_dir 'maxPeakIBL_profS20.pdf']); end;


figure(f14);
plot(es(:,j(l),l,s20));
xlabel('Energy Spread (Unit)');
ylabel('Number of particles');
title('Energy Spectrum in S20 for maximum simulated Peak Current');
v = axis;
text(0.7*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(l),'%.2f') ' degrees']);
text(0.7*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(j(l)),'%.2f') ' MV']);
text(0.7*v(2),0.85*v(4),['Sigma = ' num2str(1000*bl_sig(j(l),l,s20),'%.3f') ' \mum']);
text(0.7*v(2),0.80*v(4),['FWHM = ' num2str(1000*bl_fwhm(j(l),l,s20),'%.3f') ' \mum']);
text(0.7*v(2),0.75*v(4),['I peak = ' num2str(I_max(j(l),l,s20),'%.3f') ' kA']);
text(0.7*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(j(l),l,s20),'%.3f') ' kA']);
text(0.7*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(j(l),l,s20),'%.3f') ' %']);
if savE; saveas(gca,[save_dir 'maxPeakIES_profS20.pdf']); end;




% I sigma peak

[m,n] = max(I_sig(:,:,s20)); % n is ampl
[o,p] = max(max(I_sig(:,:,s20))); % p is phas

i_sig_max = I_sig(n(p),p,s20);

figure(f15);
plot(bl(:,n(p),p,s20));
xlabel('Bunch Profile (Unit)');
ylabel('Number of particles');
title('Bunch Profile in S20 for maximum simulated Gaussian Peak Current');
v = axis;
text(0.7*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(n(p)),'%.2f') ' degrees']);
text(0.7*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(p),'%.2f') ' MV']);
text(0.7*v(2),0.85*v(4),['Sigma = ' num2str(1000*bl_sig(n(p),p,s20),'%.3f') ' \mum']);
text(0.7*v(2),0.80*v(4),['FWHM = ' num2str(1000*bl_fwhm(n(p),p,s20),'%.3f') ' \mum']);
text(0.7*v(2),0.75*v(4),['I peak = ' num2str(I_max(n(p),p,s20),'%.3f') ' kA']);
text(0.7*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(n(p),p,s20),'%.3f') ' kA']);
text(0.7*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(n(p),p,s20),'%.3f') ' %']);
if savE; saveas(gca,[save_dir 'maxSigIBL_profS20.pdf']); end;


figure(f16);
plot(-ee(:,n(p),p,s20)/100,es(:,n(p),p,s20));
set(gca,'xdir','rev');
xlabel('Energy Spread \delta','fontsize',16);
ylabel('Number of particles','fontsize',16);
%title('Energy Spectrum in S20 for maximum simulated Gaussian Peak Current','fontsize',16);
v = axis;
text(-0.4*v(2),0.95*v(4),['Eq Phase = ' num2str(phas(n(p)),'%.2f') '^o'],'fontsize',14);
text(-0.4*v(2),0.90*v(4),['Comp Amp = ' num2str(1000*NAMPL(p),'%.2f') ' MV'],'fontsize',14);
text(-0.4*v(2),0.85*v(4),['Sigma = ' num2str(1000*bl_sig(n(p),p,s20),'%.3f') ' \mum'],'fontsize',14);
text(-0.4*v(2),0.80*v(4),['FWHM = ' num2str(1000*bl_fwhm(n(p),p,s20),'%.3f') ' \mum'],'fontsize',14);
text(-0.4*v(2),0.75*v(4),['I peak = ' num2str(I_max(n(p),p,s20),'%.3f') ' kA'],'fontsize',14);
text(-0.4*v(2),0.70*v(4),['I sigma = ' num2str(I_sig(n(p),p,s20),'%.3f') ' kA'],'fontsize',14);
text(-0.4*v(2),0.65*v(4),['E FWHM = ' num2str(e_fwhm(n(p),p,s20),'%.3f') ' %'],'fontsize',14);
if savE; saveas(gca,[save_dir 'maxSigIES_profS20.pdf']); end;

end