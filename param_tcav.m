% Simulation parameters
PARAM.SIMU.PLOT  = 0;       % Small plots?
PARAM.SIMU.FRAC  = 0.05;    % Fraction of sim particles to plot
PARAM.SIMU.BIN   = 128;     % Number of historgram bins
PARAM.SIMU.ZFIT  = 0;       % Longitudinal gauss fit
PARAM.SIMU.DFIT  = 0;       % Energy gauss fit
PARAM.SIMU.CONT  = 0;       % Contour plot

% Machine energy constraints
PARAM.ENRG.E0    = 1.19;    % Energy from ring (GeV)
PARAM.ENRG.E1    = 9.0;     % Energy at S10 (GeV)
PARAM.ENRG.E2    = 20.35;   % Energy at S20 (GeV)

% Beam initial conditions
PARAM.INIT.SIGZ0 = 8.00E-3; % RMS bunch length (m)
PARAM.INIT.SIGD0 = 8.00E-4; % RMS energy spread
PARAM.INIT.Z0BAR = 0;       % Z offset
PARAM.INIT.D0BAR = 0;       % Energy offset
PARAM.INIT.NESIM = 2E5;     % Number of simulated macro particles
PARAM.INIT.NPART = 2.00E10; % Number of electrons per bunch
PARAM.INIT.ASYM  = -0.15;  % The Holtzapple skew
PARAM.INIT.TAIL  = 0;       % Not sure what this is
PARAM.INIT.CUT   = 6;       % Not sure what this is

% NRTL bunch compressor
PARAM.NRTL.AMPL  = 0.0388;   % RTL compressor ampl (MV)
PARAM.NRTL.PHAS  = 90.00;   % RTL compressor phase (deg)
PARAM.NRTL.LEFF  = 2.1694;  % RTL cavity length (m)
PARAM.NRTL.R56   = 0.6026;  % RTL chicane R56 (m)
PARAM.NRTL.T566  = 1.010;   % RTL chicane T566 (m)
PARAM.NRTL.ELO   = -0.0250; % RTL lower momentum cut (GeV)
PARAM.NRTL.EHI   = 0.0250;  % RTL upper momentum cut (GeV)

% LI02-LI10 acceleration
PARAM.LONE.LEFF  = 809.5;   % Length of LI02-LI10 (m)
PARAM.LONE.CHRP  = 3.0536;  % chirp in 2-10 (GeV)
decker           = -23.50;  % Chirping phase
ramp             = 0.00;   % Ramped phase
PARAM.LONE.PHAS = decker+ramp; % Total phase
PARAM.LONE.FBAM  = 0.235;   % feedback amplitude at S10 (GV)
PARAM.LONE.GAIN = (PARAM.ENRG.E1 - PARAM.ENRG.E0)/cosd(PARAM.LONE.PHAS); % Energy gain

% LI10 bunch compressor
PARAM.LI10.R56   = -0.075786;% Sector 10 chicane R56 (m)
PARAM.LI10.ISR   = 5.9E-5;   % ISR energy spread from bends
PARAM.LI10.ELO   = -0.040;   % low energy cut
PARAM.LI10.EHI   = 0.040;    % high energy cut

% LI11-LI19 acceleration
l_two = 0;
PARAM.LTWO.LEFF  = 848;     % Length of LI02-LI10 (m)
PARAM.LTWO.GAIN  = 11.35;   % egain in 2-10, automatically set if 0 (GeV)
PARAM.LTWO.CHRP  = 0;       % chirp in 2-10 (GeV)
PARAM.LTWO.PHAS  = ramp;    % 11-20 phase
PARAM.LTWO.FBAM  = 1.88;    % feedback amplitude at S20 (GV)

% LI20 bunch compressor
PARAM.LI20.NLO   = 0;       % notch low
PARAM.LI20.NHI   = 0;       % notch hi
PARAM.LI20.R56   = 0.0050;  % Sector 20 chicane R56 (m)
PARAM.LI20.T566  = 0.100;   % Sector 20 chicane T566 (m) % = 100 mm for R56 = 5mm from YS
PARAM.LI20.ISR   = 0.8E-5;  % ISR energy spread from bends
PARAM.LI20.ELO   = -0.035;  % RTL lower momentum cut (GeV)
PARAM.LI20.EHI   = 0.035;   % RTL upper momentum cut (GeV)
PARAM.LI20.R16   = 110;     % Dispersion at YAG
PARAM.LI20.T166  = -500;    % Second order dispersion at YAG
PARAM.LI20.BETA  = 5.0;     % Beta function at YAG
PARAM.LI20.EMIT  = 100e-6;  % Emittance in S20
delta            = 0.0;     % Energy offset