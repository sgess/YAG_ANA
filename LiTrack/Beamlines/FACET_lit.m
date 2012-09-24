% 'G'=gausian, 'U'=uniform, string.zd=name of file with z(mm) and dE/E(%) (see e.g. "atf1.zd"):
% ============================================================================================
%inp = 'lcls_145.zd';	% name of file with 2-columns [Z/mm dE/E/%] (sigz and sigd not used in this case)
inp = 'G';		% gaussian Z and dE/E (see sigz0 =..., sigd0 =...)
%inp = 'U';		% uniform  Z and dE/E (see sigz0 =..., sigd0 =...[note: FW = sig*sqrt(12)]


% The folowing items only used when "inp" = 'G' or 'U' (i.e. used when no particle coordinate file is read)
% ========================================================================================================
sigz0 = 5.6E-3;	    % rms bunch length used when inp=G or U above [m]
sigd0 = 7.39E-4;    % rms relative energy spread used when inp=G or U above [ ]
Nesim = 200000;		% number of particles to generate for simulation when inp=G or U (reasonable: ~1000 to ~100000)
asym  = -0.245;		% for inp='M' or 'G': sets rise/fall time width (-1<asym<1)
tail  = 0.0;		% for inp='M' or 'G': sets rise/fall time width (0<=tail<1)
cut   = 6;		    % for inp='G': sets rise/fall time width (0.5<=cut<inf)
% ========================================================================================================

splots = 0;			% if =1, use small plots and show no wakes (for publish size plots)
plot_frac = 0.05;   % fraction of particles to plot in the delta-z scatter-plots (0 < plot_frac <= 1)
E0     = 1.19;		% initial electron energy [GeV]
% Ne     = 2.20E10;	% number of particles initially in bunch
% z0_bar = 0.000E-3;	% axial offset of bunch [m] (used also with file input - mean of file removed first)
d0_bar = 0.000E-2;	% relative energy offset of bunch [ ]  (used also with file input - mean of file removed first)
Nbin   = 200;		% number of bins for z-coordinate (and dE/E for plots)
gzfit   = 0;		% if ==1: fit Z-distribution to gaussian (defaults to no-fit if 'gzfit' not provided)
gdfit   = 0;		% if ==1: fit dE/E-distribution to gaussian (defaults to no-fit if 'gdfit' not provided)
contf=1;		 % if ==1: get color contour image of z-d space (defaults to scatter plot if not provided)


% The follwing array of file names, "wake_fn", is the point-charge wakefield filename(s) to be used.  The pointer
% to the used filename appears in the 5th column (wake ON/OFF) of the 'beamline' array below.  A "zero" (i.e. 0)
% means no wake used, and a value of j (e.g. 1,2,...) directs the calculation to use the jth point-charge wakefield
% file (i.e. the jth row of "wake_fn") for that part of the beamline.

wake_fn = ['slac.dat         '
           'slacx.dat        '
           'SlacL.dat        '
           'Slac_cu_rw.dat   '
           'SS_12700um_rw.dat'
           'Al_12700um_rw.dat'];		% name of point-charge wakefield file(s) ["slac.dat" is default if filename not given]

comment = 'FACET in Li20';	% text comment which appears at bottom of plots

% CODES:       |
%	           |		1				2				3				4				5				6
%==============|==============================================================================================
% compressor   |	code= 6           R56/m          T566/m          E_nom/GeV       U5666/m            -
% chicane      |	code= 7           R56/m         E_nom/GeV           -               -               -
% acceleration |	code=10       tot-energy/GeV    phase/deg        lambda/m   wake(ON=1,2**/OFF=0)  Length/m
% acceleration |	code=11     dEacc(phi=0)/GeV    phase/deg        lambda/m   wake(ON=1,2**/OFF=0)  Length/m
% E-spread add |	code=22          rms_dE/E           -               -               -               -
% E-window cut |	code=25         dE/E_window         -               -               -               -
% E-cut limits |	code=26          dE/E_min        dE/E_max           -               -               -
% con-N E-cut  |	code=27            dN/N             -               -               -               -
% Z-cut limits |	code=36            z_min           z_max            -               -               -
% con-N z-cut  |	code=37            dN/N             -               -               -               -
% modulation   |	code=44           mod-amp        lambda/m           -               -               -
% STOP	       |	code=99             -               -               -               -               -
%=============================================================================================================
% CODE<0 makes a plot here, CODE>0 gives no plot here.

% 2.2E10, 41.2, -21 gave 25kA, 14µm with 5.6mm, -0.245, 7.4E-4dE/E
% 2.2E10, 41.?, -20.6 gave 24kA, 15µm
% 2.2E10, 41, -20.8 gave 22.4kA, 15.6µm with 6mm, -0.28, 7.4E-4dE/E
% 2.2E10, 40.8, -22 gave 24kA, 14.5µm can get similar parametes as the
% chicane R56 keeps dropping from 0.074 down to 0.066...
% 2.2E10, 40.8, -20.6 gave 22.6kA, 15.4µm with as built LBCCR56 -0.076

Efinal = 20.35; %23
T566 = 0.10;
% contf = 1;

% FACET Li20 for long (SLC) bunch:
% z0in_deg = 0;
% Ne = 2.0E10;
% compressor = 0.032;
% subphase = 5;
% ramp = -5;
% RTLR56 = 0.603;
% LBCCR56 = 0;
% FACETR56 = 0.004;
% RTLupper = 0.025;
% RTLlower = -0.025;
% SouthMS = -0.03;
% NorthMS = 0.03;
% 
% FACET Nominal Design Parameters:
z0in_deg = 0;
Ne = 2.2E10;
compressor = 0.0408;
subphase = -21.2;
ramp = 0;
RTLR56 = 0.603;
LBCCR56 = -0.0760;
FACETR56 = 0.0040;
RTLupper = 0.025;
RTLlower = -0.025;
SouthMS = -0.03;
NorthMS = 0.03;

% 23GeV with the 10cm T566:
% Using SPPS design NDR parameters:
% sigz0 = 6E-3
% sigd0 = 7.39E-4
% asym  = -0.28
% Maximum Peak Current = 20.6298 kA with Sigmaz = 0.0149146 µm
% Charge in NDR = 2.2E+10
% Compressor (actual is x E0/E_SLC) = 0.0402
% Li02-06 Phase =  -21.6
% Phase Ramp =      0
% RTL R56 =  0.603
% FACET R56 =  0.004
% NR into NRTL Timing Jitter =      0
% RTL High E Acceptance =  0.025
% RTL Low E Acceptance  = -0.025
% NDR E0 =   1.19
% LBCC R56 = -0.076
% FACET South Momentum Slit =  -0.03
% FACET North Momentum Slit =   0.03

% or with E-167 NDR parameters:
% sigz0 = 5.6E-3
% sigd0 = 7.39E-4
% asym  = -0.245
% Best parameters from the scan:
% Maximum Peak Current =  22.5kA with Sigmaz =  14.4µm
% Charge in NDR = 2.2E+10
% Compressor (actual is x E0/E_SLC) = 0.0408
% Li02-06 Phase =  -21.2
% Phase Ramp =      0
% RTL R56 =  0.603
% FACET R56 =  0.004
% NR into NRTL Timing Jitter =      0
% RTL High E Acceptance =  0.025
% RTL Low E Acceptance  = -0.025
% NDR E0 =   1.19
% LBCC R56 = -0.076
% FACET South Momentum Slit =  -0.03
% FACET North Momentum Slit =   0.03

phase = subphase + ramp;
mperdeg = 0.104969/360;
% Efinal = 25;
% T566 = 2*FACETR56;
thewake = 1;
z0_bar = z0in_deg*mperdeg;

beamline = [
       -11		0              0                    0.104969  0		  0        % S-band
       11		compressor     90.                  0.104969  1		  2.13     % Compressor cavity AMPL DR13 13 VDES
       -26	    RTLlower       RTLupper             0		  0       0        % Approximate energy acceptance of NRTL
       -6		RTLR56         1.0535               E0        0		  0        % Design NRTL ~0.603, BDES to KMOD for E-164 gives 0.588
       11		8.444          phase                0.104969  thewake 809.5    % 2-6, nominal 9GeV, no feedback
       -13       9              0.235*3             -90        90      0.104969 % Energy feedback to set 9GeV in chicane
       7	    LBCCR56/2      9.000                0         0       0        % 1st half of the chicane. Design was -0.0745, as built -0.076
       -7	    LBCCR56/2      9.000                0         0       0        % 2nd half of the chicane. Design was -0.0745, as built -0.076
       22       5.9E-5         0                    0         0       0        % Approximate SR growth in E-spread from chicane
       37		0.01           1                    0		  0		  0        % Clip any rediculously long tails
       -10       Efinal         ramp                 0.104969  thewake 868      % Boost to 23 GeV. 868m w/LCLS-II mods from P. Emma email 4-FEB-2011
       -6		FACETR56       T566                 Efinal    0		  0        % FACET 'dogleg' like chicane
       22       0.8E-5         0                    0         0       0        % Approximate SR growth in E-spread from dogleg
       37       0.01           1                    0		  0		  0        % Clip any rediculously long tails
       26       SouthMS        NorthMS              0         0       0        % Momentum Slits in FACET
       -99	    0              0                    0		  0		  0        % End
       ];
   


% Sign conventions used:
% =====================
%
% phase = 0 is beam on accelerating peak of RF (crest)
% phase < 0 is beam ahead of crest (i.e. bunch-head sees lower RF voltage than tail)
% The bunch head is at smaller values of z than the tail (i.e. head toward z<0)
% With these conventions, the R56 of a chicane is < 0 (and R56>0 for a FODO-arc) - note T566>0 for both
% 
% * = Note, the Energy-window cut (25-code) floats the center of the given FW window in order center it
%     on the most dense region (i.e. maximum number of particles).
% **  1:=1st wake file (e.g. S-band) is used, 2:=2nd wake file (e.g. X-band)