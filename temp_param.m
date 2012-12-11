PARAM.MACH.RAMP  = 0;       % phase ramp
PARAM.MACH.LTC   ='decker'; % lattice phasing

PARAM.ENRG.E0    = 1.19;    % Energy from ring (GeV)
PARAM.ENRG.E1    = 9.0;     % Energy at S10 (GeV)
PARAM.ENRG.E2    = 20.35;   % Energy at S20 (GeV)

PARAM.SIMU.PLOT  = 0;       % Small plots?
PARAM.SIMU.FRAC  = 0.05;    % Fraction of sim particles to plot
PARAM.SIMU.BIN   = 256;     % Number of historgram bins
PARAM.SIMU.ZFIT  = 1;       % Longitudinal gauss fit
PARAM.SIMU.DFIT  = 1;       % Energy gauss fit
PARAM.SIMU.CONT  = 0;       % Contour plot

PARAM.INIT.SIGZ0 = 6.7E-3;  % RMS bunch length (m)
PARAM.INIT.SIGD0 = 9.7412e-04; % RMS energy spread
PARAM.INIT.Z0BAR = 0;       % Z offset
PARAM.INIT.D0BAR = 0;       % Energy offset
PARAM.INIT.NESIM = 2E5;     % Number of simulated macro particles
PARAM.INIT.NPART = 2.7227E10;  % Number of electrons per bunch
PARAM.INIT.ASYM  = -0.1728;  % The Holtzapple skew
PARAM.INIT.TAIL  = 0;       % Not sure what this is
PARAM.INIT.CUT   = 6;       % Not sure what this is

PARAM.NRTL.AMPL  = 41.1E-3;
PARAM.NRTL.PHAS  = 89.71;      % RTL compressor phase (deg)
PARAM.NRTL.LEFF  = 2.1694;  % RTL cavity length (m)
PARAM.NRTL.R56   = 0.6027;% RTL chicane R56 (m)
PARAM.NRTL.T566  = 0.9123; % RTL chicane T566 (m)
PARAM.NRTL.ELO   = -0.0228;  % RTL lower momentum cut (GeV)
PARAM.NRTL.EHI   = 0.0228;   % RTL upper momentum cut (GeV)

PARAM.LONE.LEFF  = 809.5;   % Length of LI02-LI10 (m)
ramp = -2.5286;
decker = -18.7187;
PARAM.LONE.PHAS = decker+ramp;

PARAM.LONE.FBAM  = 0.235;   % feedback amplitude at S10 (GV)
PARAM.LONE.GAIN = (PARAM.ENRG.E1 - PARAM.ENRG.E0)/cosd(PARAM.LONE.PHAS);

PARAM.LI10.R56   = -0.0758;% Sector 10 chicane R56 (m)
PARAM.LI10.ISR   = 5.9E-5;  % ISR energy spread from bends
PARAM.LI10.ELO = -0.04;
PARAM.LI10.EHI = 0.04;

PARAM.LTWO.LEFF  = 848;     % Length of LI02-LI10 (m)
PARAM.LTWO.GAIN  = 11.35;   % egain in 2-10, automatically set if 0 (GeV)
PARAM.LTWO.CHRP  = 0;       % chirp in 2-10 (GeV)
PARAM.LTWO.PHAS  = 0;       % 11-20 phase
PARAM.LTWO.FBAM  = 1.88;    % feedback amplitude at S20 (GV)

PARAM.LI20.R56   = 0.0045;   % Sector 20 chicane R56 (m)
PARAM.LI20.T566  = 0.100;% Sector 20 chicane T566 (m) % = 100 mm for R56 = 5mm from YS
PARAM.LI20.ISR   = 0.8E-5;  % ISR energy spread from bends
PARAM.LI20.ELO   = -0.03;   % RTL lower momentum cut (GeV)
PARAM.LI20.EHI   = 0.03;    % RTL upper momentum cut (GeV)