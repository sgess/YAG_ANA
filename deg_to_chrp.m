% Parameters
global PARAM;
global LINAC;



PARAM.MACH.RAMP  = 0;       % phase ramp
PARAM.MACH.LTC   ='decker'; % lattice phasing

PARAM.SIMU.PLOT  = 0;       % Small plots?
PARAM.SIMU.FRAC  = 0.05;    % Fraction of sim particles to plot
PARAM.SIMU.BIN   = 256;     % Number of historgram bins
PARAM.SIMU.ZFIT  = 1;       % Longitudinal gauss fit
PARAM.SIMU.DFIT  = 1;       % Energy gauss fit
PARAM.SIMU.CONT  = 0;       % Contour plot

PARAM.INIT.SIGZ0 = 6.0E-3;  % RMS bunch length (m)
PARAM.INIT.SIGD0 = 8.00E-4; % RMS energy spread
PARAM.INIT.Z0BAR = 0;       % Z offset
PARAM.INIT.D0BAR = 0;       % Energy offset
PARAM.INIT.NESIM = 2E5;     % Number of simulated macro particles
PARAM.INIT.NPART = 2.2E10;  % Number of electrons per bunch
PARAM.INIT.ASYM  = -0.280;  % The Holtzapple skew
PARAM.INIT.TAIL  = 0;       % Not sure what this is
PARAM.INIT.CUT   = 6;       % Not sure what this is

PARAM.NRTL.AMPL  = 0.041;  % RTL compressor amplitude (GV)
PARAM.NRTL.PHAS  = 90;      % RTL compressor phase (deg)
PARAM.NRTL.LEFF  = 2.1694;  % RTL cavity length (m)
PARAM.NRTL.R56   = 0.602601;% RTL chicane R56 (m)
PARAM.NRTL.T566  = 1.07572; % RTL chicane T566 (m)
PARAM.NRTL.ELO   = -0.021;  % RTL lower momentum cut (GeV)
PARAM.NRTL.EHI   = 0.021;   % RTL upper momentum cut (GeV)

PARAM.LONE.LEFF  = 809.5;   % Length of LI02-LI10 (m)
PARAM.LONE.GAIN  = 7.81;    % egain in 2-10, automatically set if 0 (GeV)
PARAM.LONE.CHRP  = 3.0536;  % chirp in 2-10 (GeV)
PARAM.LONE.PHAS  = -11.05;   % decker's staged phase
PARAM.LONE.FBAM  = 0.235;   % feedback amplitude at S10 (GV)

PARAM.LI10.R56   = -0.075786;% Sector 10 chicane R56 (m)
PARAM.LI10.T566  = 0.114020;% Sector 10 chicane T566 (m)
PARAM.LI10.ISR   = 5.9E-5;  % ISR energy spread from bends

PARAM.LTWO.LEFF  = 848;     % Length of LI02-LI10 (m)
PARAM.LTWO.GAIN  = 11.35;   % egain in 2-10, automatically set if 0 (GeV)
PARAM.LTWO.CHRP  = 0;       % chirp in 2-10 (GeV)
PARAM.LTWO.PHAS  = 0;       % 11-20 phase
PARAM.LTWO.FBAM  = 1.88;    % feedback amplitude at S20 (GV)

PARAM.LI20.R56   = 0.0040;   % Sector 20 chicane R56 (m)
PARAM.LI20.T566  = 0.0803843;% Sector 20 chicane T566 (m)
PARAM.LI20.ISR   = 0.8E-5;  % ISR energy spread from bends
PARAM.LI20.ELO   = -0.03;   % RTL lower momentum cut (GeV)
PARAM.LI20.EHI   = 0.03;    % RTL upper momentum cut (GeV)

PARAM.ENRG.E0    = 1.19;    % Energy from ring (GeV)
PARAM.ENRG.E1    = 9.0;     % Energy at S10 (GeV)
PARAM.ENRG.E2    = 20.35;   % Energy at S20 (GeV)



scan = 0;

if scan == 0
    
    PARAM.MACH.LTC   ='decker'; % lattice phasing
    PARAM.LONE.PHAS  = -11.28;
    PARAM.NRTL.AMPL  = 0.04051;
    PARAM.LI20.R56   = 0.0050;
    LINAC = des_amp_and_phase();
    %LiTrack('FACETlump');
    lump_OUTPUT = LiTrack('FACETlump');
        
    PARAM.LONE.PHAS  = -21.76;
    PARAM.LONE.GAIN  = (PARAM.ENRG.E1 - PARAM.ENRG.E0)/cosd(PARAM.LONE.PHAS);
    %LiTrack('FACETpar');
    par_OUTPUT = LiTrack('FACETpar');
    
elseif scan == 1
    
    p_lo = -10.;
    p_hi = -11.6;
    n_lo = 0.0400;
    n_hi = 0.0464;
    p_el = 64;
    n_el = 64;
    phase = linspace(p_lo,p_hi,p_el);
    NAMPL = linspace(n_lo,n_hi,n_el);
    
    chrp = zeros(p_el,n_el);
    phas = zeros(p_el,n_el);
    
    bl_fwhm = zeros(p_el,n_el,3);
    bl_sig  = zeros(p_el,n_el,3);
    z_avg   = zeros(p_el,n_el,3);
    
    e_avg   = zeros(p_el,n_el,3);
    e_fwhm  = zeros(p_el,n_el,3);
    e_sig   = zeros(p_el,n_el,3);
    e_cut   = zeros(p_el,n_el,3);
    
    I_max   = zeros(p_el,n_el,3);
    I_sig   = zeros(p_el,n_el,3);
    
    N       = zeros(p_el,n_el,3);
    
    bl      = zeros(PARAM.SIMU.BIN,p_el,n_el,3);
    es      = zeros(PARAM.SIMU.BIN,p_el,n_el,3);
    
    tot = p_el*n_el;
    for i = 1:p_el
        for j = 1:n_el
            
            prog = 100*((i-1)*p_el + j)/tot;
            disp(['Progress: ' num2str(prog,'%.2f') '%']);
            
            
            PARAM.LONE.PHAS = phase(i);
            PARAM.NRTL.AMPL = NAMPL(j);
            LINAC = des_amp_and_phase();
            chrp(i,j) = LINAC.LONE.CHRP;
            phas(i,j) = LINAC.LONE.PHI;
            
            [bunch_length,energy_spread,avg_enrg,fwhm_enrg,fwhm_bl,avg_z,avg_enrg_cut,num_part,sig_bl,sig_enrg,peak_I,sigpeak_I] = LiTrack('FACETlump');
            
            bl_fwhm(i,j,:) = fwhm_bl;
            bl_sig(i,j,:) = sig_bl;
            z_avg(i,j,:) = avg_z;
            
            e_avg(i,j,:) = avg_enrg;
            e_fwhm(i,j,:) = fwhm_enrg;
            e_sig(i,j,:) = sig_enrg;
            e_cut(i,j,:) = avg_enrg_cut;
            
            I_max(i,j,:) = peak_I;
            I_sig(i,j,:) = sigpeak_I;
            
            N(i,j,:) = num_part;
            
            bl(:,i,j,1) = hist(bunch_length(1:num_part(1),1),PARAM.SIMU.BIN);
            bl(:,i,j,2) = hist(bunch_length(1:num_part(2),2),PARAM.SIMU.BIN);
            bl(:,i,j,3) = hist(bunch_length(1:num_part(3),3),PARAM.SIMU.BIN);
            
            es(:,i,j,1) = hist(energy_spread(1:num_part(1),1),PARAM.SIMU.BIN);
            es(:,i,j,2) = hist(energy_spread(1:num_part(2),2),PARAM.SIMU.BIN);
            es(:,i,j,3) = hist(energy_spread(1:num_part(3),3),PARAM.SIMU.BIN);
            
        end
    end

end