% Parameters
global PARAM;

PARAM.MACH.LTC   ='uniform';% 'uniform' or 'decker'
PARAM.MACH.RAMP  = 0;       % phase ramp

PARAM.INIT.SIGZ0 = 5.6E-3;  % RMS bunch length (m)
PARAM.INIT.SIGD0 = 7.40E-4; % RMS energy spread
PARAM.INIT.NESIM = 2E5;     % Number of simulated macro particles
PARAM.INIT.ASYM  = -0.245;  % The Holtzapple skew
PARAM.INIT.TAIL  = 0;       % Not sure what this is
PARAM.INIT.CUT   = 6;       % Not sure what this is

PARAM.NRTL.AMPL  = 0.0408;  % RTL compressor amplitude (GV)
PARAM.NRTL.PHAS  = 90;      % RTL compressor phase (deg)
PARAM.NRTL.LEFF  = 2.13;    % RTL cavity length (m)
PARAM.NRTL.R56   = 0.603;   % RTL chicane R56 (m)
PARAM.NRTL.T566  = 1.0535;  % RTL chicane T566 (m)
PARAM.NRTL.ELO   = -0.025;  % RTL lower momentum cut (GeV)
PARAM.NRTL.EHI   = 0.025;   % RTL upper momentum cut (GeV)

PARAM.LONE.LEFF  = 809.5;   % Length of LI02-LI10 (m)
PARAM.LONE.PHAS  = -21.2;   % Chirp phase
PARAM.LONE.GAIN  = 0;       % energy gain in LI02-LI10 (GeV)

PARAM.LONE.FBAM  = 0.235;   % feedback amplitude (GV)

PARAM.LI10.R56   = -0.076;  % Sector 10 chicane R56 (m)
PARAM.LI10.T566  = 0.10;    % Sector 10 chicane T566 (m)
PARAM.LI10.ISR   = 5.9E-5;  % ISR energy spread from bends

PARAM.LTWO.LEFF  = 868;     % Length of LI02-LI10 (m)
PARAM.LTWO.PHAS  = 0;       % Ramp phase
PARAM.LTWO.FBAM  = 1.88;    % feedback amplitude (GV)

PARAM.LI20.R56   = 0.004;   % Sector 20 chicane R56 (m)
PARAM.LI20.T566  = 0.10;    % Sector 20 chicane T566 (m)
PARAM.LI20.ISR   = 0.8E-5;  % ISR energy spread from bends
PARAM.LI20.ELO   = -0.03;   % RTL lower momentum cut (GeV)
PARAM.LI20.EHI   = 0.03;    % RTL upper momentum cut (GeV)

PARAM.ENRG.E0    = 1.19;    % Energy from ring (GeV)
PARAM.ENRG.E1    = 9.0;     % Energy at S10 (GeV)
PARAM.ENRG.E2    = 23.00;   % Energy at S20 (GeV)

%LiTrack('FACET2');
%MACH = des_amp_and_phase();
%LiTrack('FACETDSECT');

%[k_microns,k_percent,ke_average,ke_fwhm,kz_fwhm,kz_average,ke_avg_cut,knum_part]=LiTrack('FACETsgess');
%[s_microns,s_percent,se_average,se_fwhm,sz_fwhm,sz_average,se_avg_cut,snum_part]=LiTrack('FACETsect');
%[f_microns,f_percent,fe_average,fe_fwhm,fz_fwhm,fz_average,fe_avg_cut,fnum_part]=LiTrack('FACET2',1);
%[d_microns,d_percent,de_average,de_fwhm,dz_fwhm,dz_average,de_avg_cut,dnum_part]=LiTrack('FACET',1);
%[microns,percent,e_average,e_fwhm,z_fwhm,z_average,e_avg_cut,num_part]=LiTrack('FACETDSECT',1);






% z_min = min(microns(1:num_part(8),8));
% z_max = max(microns(1:num_part(8),8));
% e_min = min(percent(1:num_part(8),8));
% e_max = max(percent(1:num_part(8),8));
% zz = linspace(z_min,z_max,200);
% ee = linspace(e_min,e_max,200);
% h = hist(microns(1:num_part(8),8),200);
% [sig,mu,norm] = mygaussfit(zz,h);
% y = norm * exp(-(zz-mu).^2/(2*sig^2));
% plot(zz,h,zz,y,'.r');
% text(z_min+z_max/10,max(h)-100,['\sigma = ' num2str(sig*1e6)]);
%h3 = hist2(f3_percent(1:fnum_part(8),8),f3_microns(1:fnum_part(8),8),ee,zz);
%image(ee,zz,h3);
%max(max(h))

num = 1467;
MACH = get_amp_and_phase(num,0,0,0);
% 
% Z_NAME     = cell(25,1);
% Z_NAME{1}  = 'Initial Beam from NDR';
% Z_NAME{2}  = 'After RTL Compressor';
% Z_NAME{3}  = 'After RTL Chicane';
% Z_NAME{4}  = 'END LI02';
% Z_NAME{5}  = 'END LI03';
% Z_NAME{6}  = 'END LI04';
% Z_NAME{7}  = 'END LI05';
% Z_NAME{8}  = 'END LI06';
% Z_NAME{9}  = 'END LI07';
% Z_NAME{10} = 'END LI08';
% Z_NAME{11} = 'END LI09';
% Z_NAME{12} = 'END LI10';
% Z_NAME{13} = 'After S10 Energy Feedback';
% Z_NAME{14} = 'After S10 Chicane w/ISR';
% Z_NAME{15} = 'END LI11';
% Z_NAME{16} = 'END LI12';
% Z_NAME{17} = 'END LI13';
% Z_NAME{18} = 'END LI14';
% Z_NAME{19} = 'END LI15';
% Z_NAME{20} = 'END LI16';
% Z_NAME{21} = 'END LI17';
% Z_NAME{22} = 'END LI18';
% Z_NAME{23} = 'END LI19';
% Z_NAME{24} = 'After S20 Energy Feedback';
% Z_NAME{25} = 'After FACET Chicane';
% 
% Z_LIST        = zeros(25,1);         
% Z_LIST(1)     = 0;                   
% Z_LIST(2)     = 2.1694+86.4108;              
% Z_LIST(3)     = MACH.SECT.Z(1);
% Z_LIST(4:11)  = MACH.SECT.Z(1:8)+86.4108;
% Z_LIST(12)    = MACH.SECT.Z(9)+86.4108 - 10;
% Z_LIST(13)    = MACH.SECT.Z(9)+86.4108;
% Z_LIST(14)    = MACH.SECT.Z(9)+86.4108 + 10;
% Z_LIST(15:22) = MACH.SECT.Z(10:17)+86.4108;
% Z_LIST(23)    = MACH.SECT.Z(18)+86.4108 - 10;
% Z_LIST(24)    = MACH.SECT.Z(18)+86.4108;
% Z_LIST(25)    = MACH.SECT.Z(19)+86.4108;

% for j=1:25
%     
%     z_min(j) = min(microns(1:num_part(j),j));
%     z_max(j) = max(microns(1:num_part(j),j));
%     e_min(j) = min(percent(1:num_part(j),j));
%     e_max(j) = max(percent(1:num_part(j),j));
%     
%     zz = linspace(z_min(j),z_max(j),200);
%     ee = linspace(e_min(j),e_max(j),200);
%     
%     h = hist(microns(1:num_part(j),j),200);
%     [sig,mu,norm] = mygaussfit(zz,h);
%     y = norm * exp(-(zz-mu).^2/(2*sig^2));
%     plot(zz,h,zz,y,'.r');
%     text(z_min(j)+z_max(j)/10,max(h)-100,['\sigma = ' num2str(sig*1e6)]);
%     xlabel('Bunch Profile (\mum)');
%     title(Z_NAME{j});
%     pause;
%     
% end

% z = linspace(0,2100);
% e1 = 1.19*ones(1,100);
% e2 = 9*ones(1,100);
% e3 = 20.35*ones(1,100);
% 
% if 0
% plot(Z_LIST,ke_average,':',Z_LIST,se_average,'s',z,e1,'--c',z,e2,'--m',z,e3,'--y');
% line([Z_LIST(12) Z_LIST(12)],[0,21],'LineStyle','--');
% text(1000,8,'Sector 10 Chicane','Fontsize',16);
% axis([0 2100 0 21]);
% xlabel('Z (meters)','fontsize',16);
% ylabel('Energy (GeV)','fontsize',16);
% title('Simulated energy profile for full and sector averaged linac','fontsize',16);
% l = legend('Energy Profile, All Klystrons','Energy Profile, By Sector',...
%     '1.19 GeV','9 GeV','20.35 GeV','Location','Northwest');
% set(l,'fontsize',13);
% %saveas(gca,['/Users/sgess/Desktop/plots/E200/E200_' num2str(num) '/sim_eProf.pdf']);
% 
% figure;
% 
% semilogy(Z_LIST,kz_fwhm*1000,':c',Z_LIST,sz_fwhm*1000,'sr');
% line([Z_LIST(12) Z_LIST(12)],[50,12000],'LineStyle','--');
% text(1000,1000,'Sector 10 Chicane','Fontsize',16);
% axis([0 2100 90 13000]);
% xlabel('Z (meters)','fontsize',16);
% ylabel('FWHM Bunch Length (\mum)','fontsize',16);
% title('Simulated bunch length for full and sector averaged linac','fontsize',16);
% l = legend('Bunch Length, All Klystrons','Bunch Length, By Sector');
% set(l,'fontsize',13);
% %saveas(gca,['/Users/sgess/Desktop/plots/E200/E200_' num2str(num) '/sim_blfwhm.pdf']);
% end


