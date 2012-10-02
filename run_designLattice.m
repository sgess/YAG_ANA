% Parameters
global PARAM;
global LINAC;


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
%PARAM.LONE.PHAS  = -21.2;   % 2-10 phase for 'uniform' lattice
%PARAM.LONE.PHAS  = -11.5275;% 2-10 phase for 'decker' lattice
PARAM.LONE.GAIN  = 0;       % egain in 2-10, automatically set if 0 (GeV)
PARAM.LONE.FBAM  = 0.235;   % feedback amplitude at S10 (GV)

PARAM.LI10.R56   = -0.076;  % Sector 10 chicane R56 (m)
PARAM.LI10.T566  = 0.10;    % Sector 10 chicane T566 (m)
PARAM.LI10.ISR   = 5.9E-5;  % ISR energy spread from bends

PARAM.LTWO.LEFF  = 868;     % Length of LI02-LI10 (m)
PARAM.LTWO.PHAS  = 0;       % 11-20 phase
PARAM.LTWO.FBAM  = 1.88;    % feedback amplitude at S20 (GV)

PARAM.LI20.R56   = 0.005;   % Sector 20 chicane R56 (m)
PARAM.LI20.T566  = 0.10;    % Sector 20 chicane T566 (m)
PARAM.LI20.ISR   = 0.8E-5;  % ISR energy spread from bends
PARAM.LI20.ELO   = -0.03;   % RTL lower momentum cut (GeV)
PARAM.LI20.EHI   = 0.03;    % RTL upper momentum cut (GeV)

PARAM.ENRG.E0    = 1.19;    % Energy from ring (GeV)
PARAM.ENRG.E1    = 9.0;     % Energy at S10 (GeV)
PARAM.ENRG.E2    = 20.35;   % Energy at S20 (GeV)

MDW_param;

PARAM.MACH.LTC   ='uniform'; PARAM.LONE.PHAS  = -21.2; % uniform chirp phase
LINAC = des_amp_and_phase();
[u_bl,u_es,u_eavg,u_efwhm,u_zfwhm,u_zavg,u_eavgcut,u_numpart] = LiTrack('FACETDSECT');
%LiTrack('FACETDSECT');


PARAM.MACH.LTC   ='decker'; PARAM.LONE.PHAS  = -11.64; % decker's staged phase
LINAC = des_amp_and_phase();
[d_bl,d_es,d_eavg,d_efwhm,d_zfwhm,d_zavg,d_eavgcut,d_numpart] = LiTrack('FACETDSECT');
%LiTrack('FACETDSECT');
% overwrite parameters
%MDW_param;
%LINAC = get_amp_and_phase(1467,0,0,0);
%[m_bl,m_es,m_eavg,m_efwhm,m_zfwhm,m_zavg,m_eavgcut,m_numpart] = LiTrack('FACETDSECT');
%LiTrack('FACETDSECT');

Z_NAME     = cell(25,1);
Z_NAME{1}  = 'Initial Beam from NDR';
Z_NAME{2}  = 'After RTL Compressor';
Z_NAME{3}  = 'After RTL Chicane';
Z_NAME{4}  = 'END LI02';
Z_NAME{5}  = 'END LI03';
Z_NAME{6}  = 'END LI04';
Z_NAME{7}  = 'END LI05';
Z_NAME{8}  = 'END LI06';
Z_NAME{9}  = 'END LI07';
Z_NAME{10} = 'END LI08';
Z_NAME{11} = 'END LI09';
Z_NAME{12} = 'END LI10';
Z_NAME{13} = 'After S10 Energy Feedback';
Z_NAME{14} = 'After S10 Chicane w/ISR';
Z_NAME{15} = 'END LI11';
Z_NAME{16} = 'END LI12';
Z_NAME{17} = 'END LI13';
Z_NAME{18} = 'END LI14';
Z_NAME{19} = 'END LI15';
Z_NAME{20} = 'END LI16';
Z_NAME{21} = 'END LI17';
Z_NAME{22} = 'END LI18';
Z_NAME{23} = 'END LI19';
Z_NAME{24} = 'After S20 Energy Feedback';
Z_NAME{25} = 'After FACET Chicane';

f1 = figure;
f2 = figure;
f3 = figure;

for i=1:25
    
%     z_min = min(min(u_bl(1:u_numpart(i),i)),min(d_bl(1:d_numpart(i),i)));
%     z_max = max(max(u_bl(1:u_numpart(i),i)),max(d_bl(1:d_numpart(i),i)));
%     zz = linspace(z_min,z_max,200);
%     
%     e_min = min(min(u_es(1:u_numpart(i),i)),min(d_es(1:d_numpart(i),i)));
%     e_max = max(max(u_es(1:u_numpart(i),i)),max(d_es(1:d_numpart(i),i)));
%     ee = linspace(e_min,e_max,200);
    
    figure(f1);
    subplot(1,2,1);
     plot(u_bl(1:u_numpart(i),i),u_es(1:u_numpart(i),i),'.r');
     title('Uniform');
    %plot(m_bl(1:m_numpart(i),i),m_es(1:m_numpart(i),i),'.r');
    %title('Machine');
    subplot(1,2,2);
    plot(d_bl(1:d_numpart(i),i),d_es(1:d_numpart(i),i),'.r');
    title('Decker');

    % subplot(1,2,1);
    
    ax = axes('position',[0,0,1,1],'visible','off');
    tx = text(0.4,0.95,Z_NAME(i));
    set(tx,'fontweight','bold');
    
    figure(f2);
    subplot(1,2,1);
     hist(u_bl(1:u_numpart(i),i)*1e6,200);
     xlabel('Bunch length (\mum)');
     title('Uniform');
%    hist(m_bl(1:m_numpart(i),i)*1e6,200);
%    xlabel('Bunch length (\mum)');
%    title('Machine');
    subplot(1,2,2);
    hist(d_bl(1:d_numpart(i),i)*1e6,200);
    xlabel('Bunch length (\mum)');
    title('Decker');
    
    ax = axes('position',[0,0,1,1],'visible','off');
    tx = text(0.4,0.95,Z_NAME(i));
    set(tx,'fontweight','bold');
    
    figure(f3);
    subplot(1,2,1);
     hist(u_es(1:u_numpart(i),i)*1e2,200);
     xlabel('Energy Spread (%)');
     title('Uniform');
%    hist(m_es(1:m_numpart(i),i)*1e2,200);
 %   xlabel('Energy Spread (%)');
  %  title('Machine');
    subplot(1,2,2);
    hist(d_es(1:d_numpart(i),i)*1e2,200);
    xlabel('Energy Spread (%)');
    title('Decker');
    
    ax = axes('position',[0,0,1,1],'visible','off');
    tx = text(0.4,0.95,Z_NAME(i));
    set(tx,'fontweight','bold');
    %plot(m_bl(1:m_numpart(i),i),m_es(1:m_numpart(i),i),'.r');
    
    pause;
    
end