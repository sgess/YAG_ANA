% get FACET energy profile

  [LI_02_10_AMPL, LI_02_10_PHAS, LI_11_20_AMPL, LI_11_20_PHAS] = get_amp_and_phase(state_file);

  E0=1.19;                    % GeV ... initial energy
  E1=9.0;                     % GeV ... energy at LBCC
  E2=20.35;                   % GeV ... energy at FACET
  NRTL_ampl=1e-3*(43.0);      % AMPL DR13 11 VDES
  NRTL_phas=90;               % on the zero-crossing
  NRTL_R56=-(-0.602601);      % MAD and LiTrack have a sign difference
  NRTL_T566=-(-1.07572);      % MAD and LiTrack have a sign difference
  LBCC_R56=-(0.075786);       % MAD and LiTrack have a sign difference
  LBCC_T566=-(-0.114020);     % MAD and LiTrack have a sign difference
  LI20_R56=-(-0.003996);      % MAD and LiTrack have a sign difference
  LI20_T566=-(-0.803843E-01); % MAD and LiTrack have a sign difference

% Hogan's values
  NRTL_ampl=1e-3*(42.0);      % AMPL DR13 11 VDES
  NRTL_R56=-(-0.590);         % MAD and LiTrack have a sign difference
  NRTL_T566=-(-1.0535);       % MAD and LiTrack have a sign difference
  LBCC_R56=-(0.0760);         % MAD and LiTrack have a sign difference

% 'G'=gausian, 'U'=uniform, string.zd=name of file with z(mm) and dE/E(%) (see e.g. "atf1.zd"):
% ============================================================================================
% inp = 'lcls_145.zd'; % name of file with 2-columns [Z/mm dE/E/%] (sigz and sigd not used in this case)
  inp = 'G';		       % gaussian Z and dE/E (see sigz0 =..., sigd0 =...)
% inp = 'U';		       % uniform  Z and dE/E (see sigz0 =..., sigd0 =...[note: FW = sig*sqrt(12)]

% the folowing items only used when "inp" = 'G' or 'U' (i.e. used when no particle coordinate file is read)
% ========================================================================================================
  sigz0=6.0E-3;	  % rms bunch length used when inp=G or U above [m]
  sigd0=0.080E-2;	% rms relative energy spread used when inp=G or U above [ ]
  Nesim=200000;		% number of particles to generate for simulation when inp=G or U (reasonable: ~1000 to ~100000)
  asym=-0.28;		  % for inp='M' or 'G': sets rise/fall time width (-1<asym<1)
  tail=0;		      % for inp='M' or 'G': sets rise/fall time width (0<=tail<1)
  cut=6;		      % for inp='G': sets rise/fall time width (0.5<=cut<inf)
% ========================================================================================================

  splots=0;			 % if =1, use small plots and show no wakes (for publish size plots)
  plot_frac=0.1; % fraction of particles to plot in the delta-z scatter-plots (0 < plot_frac <= 1)
  Ne=2.3e10;	   % number of particles initially in bunch
  z0_bar=0;	     % axial offset of bunch [m] (used also with file input - mean of file removed first)
  d0_bar=0;	     % relative energy offset of bunch [ ]  (used also with file input - mean of file removed first)
  Nbin=200;		   % number of bins for z-coordinate (and dE/E for plots)
  gzfit=1;		   % if ==1: fit Z-distribution to gaussian (defaults to no-fit if 'gzfit' not provided)
  gdfit=0;		   % if ==1: fit dE/E-distribution to gaussian (defaults to no-fit if 'gdfit' not provided)
  contf=1;		   % if ==1: get color contour image of z-d space (defaults to scatter plot if not provided)

% The follwing array of file names, "wake_fn", is the point-charge wakefield filename(s) to be used.  The pointer
% to the used filename appears in the 5th column (wake ON/OFF) of the 'beamline' array below.  A "zero" (i.e. 0)
% means no wake used, and a value of j (e.g. 1,2,...) directs the calculation to use the jth point-charge wakefield
% file (i.e. the jth row of "wake_fn") for that part of the beamline.

  wake_fn=[ ...
    'slac.dat         '; ...
    'slacx.dat        '; ...
    'SlacL.dat        '; ...
    'Slac_cu_rw.dat   '; ...
    'SS_12700um_rw.dat'; ...
    'Al_12700um_rw.dat'; ...
  ]; % name of point-charge wakefield file(s) ["slac.dat" is default if filename not given]

  comment='FACET (LBCC on)'; % text comment which appears at bottom of plots

%==============|==============================================================================================
%	CODES        |		 1				        2				        3				        4				        5				        6
%==============|==============================================================================================
% compressor   |	code= 6           R56/m          T566/m          E_nom/GeV       U5666/m            -
% chicane      |	code= 7           R56/m         E_nom/GeV           -               -               -
% acceleration |	code=10       tot-energy/GeV    phase/deg        lambda/m   wake(ON=1,2**/OFF=0)  Length/m
% acceleration |	code=11     dEacc(phi=0)/GeV    phase/deg        lambda/m   wake(ON=1,2**/OFF=0)  Length/m
% energy fdbk  |	code=13      energy-goal/GeV    voltage/GV      phase1/deg      phase2/deg        lambda/m
% E-spread add |	code=22          rms_dE/E           -               -               -               -
% E-window cut |	code=25         dE/E_window         -               -               -               -
% E-cut limits |	code=26          dE/E_min        dE/E_max           -               -               -
% con-N E-cut  |	code=27            dN/N             -               -               -               -
% notch-coll   |	code=28          dE/E_min        dE/E_max           -               -               -
% Z-cut limits |	code=36            z_min           z_max            -               -               -
% con-N z-cut  |	code=37            dN/N             -               -               -               -
% modulation   |	code=44           mod-amp        lambda/m           -               -               -
% STOP	       |	code=99             -               -               -               -               -
%=============================================================================================================
% CODE<0 makes a plot here, CODE>0 gives no plot here.
%=============================================================================================================

%=============================================================================================================
% SPPS
%=============================================================================================================
% beamline=[
%   -11     0		       0          0.104969     0       0        % printout
%   -11     0.042     90.0        0.104969     1       2.13     % NRTL compressor
%    26    -0.021	     0.021      0            0       0        % energy spread cut
%    -6     0.59       1.0535     1.19         0       0        % NRTL R56, T566
%   -11     8.476	   -20.0		    0.104969     1     809.5      % LI02-10
%   -13     9.0        0.235    -90.0         90.0     0.104969 % LI09 energy feedback (9-1,9-2)
%     7    -0.076      9.0        0            0       0        % LBCC R56
%    22     5.9E-5     0          0            0       0        % LBCC ISR energy spread
%   -37     0.01       1          0            0       0        % Z-cut
%   -11    20.202      0          0.104969     1    1872.4      % LI11-LI30
%     6     0.002      0.004     28.50         0       0        % FFTB R56, T566
%    22     0.8E-5     0          0            0       0        % FFTB ISR energy spread
%    37     0.01       1          0            0       0        % Z-cut
%   -99		  0          0          0            0       0        % end
% ];
%=============================================================================================================

%=============================================================================================================
% FACET
%=============================================================================================================
  lambdaS=2.99792458e8/2856e6; % S-band wavelength
  beamline=[
     -1     0		       0          0           0         0      % initial particles
    -11     NRTL_ampl  NRTL_phas  lambdaS     1         2.1694 % NRTL compressor
     26    -0.021	     0.021      0           0         0      % energy spread cut
     -6     NRTL_R56   NRTL_T566  E0          0         0      % NRTL R56, T566
     11     ampl(  1)  phas(  1)  lambdaS     1         5.7384 % LI02:KLYS:21
     11     ampl(  2)  phas(  2)  lambdaS     1         5.7384 % LI02:KLYS:11
     11     ampl(  3)  phas(  3)  lambdaS     1         5.7384 % LI02:KLYS:31
     11     ampl(  4)  phas(  4)  lambdaS     1        11.6517 % LI02:KLYS:41
     11     ampl(  5)  phas(  5)  lambdaS     1        11.6517 % LI02:KLYS:51
     11     ampl(  6)  phas(  6)  lambdaS     1        11.6517 % LI02:KLYS:61
     11     ampl(  7)  phas(  7)  lambdaS     1        11.6517 % LI02:KLYS:71
     11     ampl(  8)  phas(  8)  lambdaS     1        11.6517 % LI02:KLYS:81
     11     ampl(  9)  phas(  9)  lambdaS     1        12.0015 % LI03:KLYS:11
     11     ampl( 10)  phas( 10)  lambdaS     1        12.0015 % LI03:KLYS:21
     11     ampl( 11)  phas( 11)  lambdaS     1        12.0015 % LI03:KLYS:31
     11     ampl( 12)  phas( 12)  lambdaS     1        12.0015 % LI03:KLYS:41
     11     ampl( 13)  phas( 13)  lambdaS     1        12.0015 % LI03:KLYS:51
     11     ampl( 14)  phas( 14)  lambdaS     1        12.0015 % LI03:KLYS:61
     11     ampl( 15)  phas( 15)  lambdaS     1        12.0015 % LI03:KLYS:71
     11     ampl( 16)  phas( 16)  lambdaS     1        12.0015 % LI03:KLYS:81
     11     ampl( 17)  phas( 17)  lambdaS     1         5.9133 % LI04:KLYS:11
     11     ampl( 18)  phas( 18)  lambdaS     1         6.0882 % LI04:KLYS:21
     11     ampl( 19)  phas( 19)  lambdaS     1        12.0015 % LI04:KLYS:31
     11     ampl( 20)  phas( 20)  lambdaS     1        12.0015 % LI04:KLYS:41
     11     ampl( 21)  phas( 21)  lambdaS     1        12.0015 % LI04:KLYS:51
     11     ampl( 22)  phas( 22)  lambdaS     1        12.0015 % LI04:KLYS:61
     11     ampl( 23)  phas( 23)  lambdaS     1        12.0015 % LI04:KLYS:71
     11     ampl( 24)  phas( 24)  lambdaS     1        12.0015 % LI04:KLYS:81
     11     ampl( 25)  phas( 25)  lambdaS     1        12.1764 % LI05:KLYS:11
     11     ampl( 26)  phas( 26)  lambdaS     1        12.1764 % LI05:KLYS:21
     11     ampl( 27)  phas( 27)  lambdaS     1        12.1764 % LI05:KLYS:31
     11     ampl( 28)  phas( 28)  lambdaS     1        12.1764 % LI05:KLYS:41
     11     ampl( 29)  phas( 29)  lambdaS     1        12.1764 % LI05:KLYS:51
     11     ampl( 30)  phas( 30)  lambdaS     1        12.1764 % LI05:KLYS:61
     11     ampl( 31)  phas( 31)  lambdaS     1        12.1764 % LI05:KLYS:71
     11     ampl( 32)  phas( 32)  lambdaS     1        12.1764 % LI05:KLYS:81
     11     ampl( 33)  phas( 33)  lambdaS     1        12.1764 % LI06:KLYS:11
     11     ampl( 34)  phas( 34)  lambdaS     1        12.1764 % LI06:KLYS:21
     11     ampl( 35)  phas( 35)  lambdaS     1        12.1764 % LI06:KLYS:31
     11     ampl( 36)  phas( 36)  lambdaS     1        12.1764 % LI06:KLYS:41
     11     ampl( 37)  phas( 37)  lambdaS     1        12.1764 % LI06:KLYS:51
     11     ampl( 38)  phas( 38)  lambdaS     1        12.1764 % LI06:KLYS:61
     11     ampl( 39)  phas( 39)  lambdaS     1        12.1764 % LI06:KLYS:71
     11     ampl( 40)  phas( 40)  lambdaS     1        12.1764 % LI06:KLYS:81
     11     ampl( 41)  phas( 41)  lambdaS     1        12.1764 % LI07:KLYS:11
     11     ampl( 42)  phas( 42)  lambdaS     1        12.1764 % LI07:KLYS:21
     11     ampl( 43)  phas( 43)  lambdaS     1        12.1764 % LI07:KLYS:31
     11     ampl( 44)  phas( 44)  lambdaS     1        12.1764 % LI07:KLYS:41
     11     ampl( 45)  phas( 45)  lambdaS     1        12.1764 % LI07:KLYS:51
     11     ampl( 46)  phas( 46)  lambdaS     1        12.1764 % LI07:KLYS:61
     11     ampl( 47)  phas( 47)  lambdaS     1        12.1764 % LI07:KLYS:71
     11     ampl( 48)  phas( 48)  lambdaS     1        12.1764 % LI07:KLYS:81
     11     ampl( 49)  phas( 49)  lambdaS     1        12.1764 % LI08:KLYS:11
     11     ampl( 50)  phas( 50)  lambdaS     1        12.1764 % LI08:KLYS:21
     11     ampl( 51)  phas( 51)  lambdaS     1        12.1764 % LI08:KLYS:31
     11     ampl( 52)  phas( 52)  lambdaS     1        12.1764 % LI08:KLYS:41
     11     ampl( 53)  phas( 53)  lambdaS     1        12.1764 % LI08:KLYS:51
     11     ampl( 54)  phas( 54)  lambdaS     1        12.1764 % LI08:KLYS:61
     11     ampl( 55)  phas( 55)  lambdaS     1        12.1764 % LI08:KLYS:71
     11     ampl( 56)  phas( 56)  lambdaS     1        12.1764 % LI08:KLYS:81
     11     ampl( 57)  phas( 57)  lambdaS     1        12.1764 % LI09:KLYS:11
     11     ampl( 58)  phas( 58)  lambdaS     1        12.1764 % LI09:KLYS:21
     11     ampl( 59)  phas( 59)  lambdaS     1        12.1764 % LI09:KLYS:31
     11     ampl( 60)  phas( 60)  lambdaS     1        12.1764 % LI09:KLYS:41
     11     ampl( 61)  phas( 61)  lambdaS     1        12.1764 % LI09:KLYS:51
     11     ampl( 62)  phas( 62)  lambdaS     1        12.1764 % LI09:KLYS:61
     11     ampl( 63)  phas( 63)  lambdaS     1        12.1764 % LI09:KLYS:71
     11     ampl( 64)  phas( 64)  lambdaS     1        12.1764 % LI09:KLYS:81
     11     ampl( 65)  phas( 65)  lambdaS     1         6.0882 % LI10:KLYS:11
     11     ampl( 66)  phas( 66)  lambdaS     1        12.1764 % LI10:KLYS:21
     11     ampl( 67)  phas( 67)  lambdaS     1         6.0882 % LI10:KLYS:31
     11     ampl( 68)  phas( 68)  lambdaS     1         6.0882 % LI10:KLYS:41
     11     ampl( 69)  phas( 69)  lambdaS     1        12.1764 % LI10:KLYS:51
     11     ampl( 70)  phas( 70)  lambdaS     1        12.1764 % LI10:KLYS:61
     11     ampl( 71)  phas( 71)  lambdaS     1        12.1764 % LI10:KLYS:71
		-13		  E1 	       0.235    -90.0	       90.0      lambdaS % LI09 energy feedback
%     6     LBCC_R56   LBCC_T566  E1          0         0      % LBCC R56, T566
			7	    LBCC_R56   E1	        0           0         0      % LBCC chicane
     22     5.9E-5     0          0           0         0      % LBCC ISR energy spread
    -37     0.01       1          0           0         0      % Z-cut
     99		  0          0          0           0         0      % end
     11     ampl( 72)  phas( 72)  lambdaS     1         9.1323 % LI11:KLYS:11
     11     ampl( 73)  phas( 73)  lambdaS     1        12.1764 % LI11:KLYS:21
     11     ampl( 74)  phas( 74)  lambdaS     1         6.0882 % LI11:KLYS:31
     11     ampl( 75)  phas( 75)  lambdaS     1         9.5523 % LI11:KLYS:41
     11     ampl( 76)  phas( 76)  lambdaS     1        11.3017 % LI11:KLYS:51
     11     ampl( 77)  phas( 77)  lambdaS     1        10.4270 % LI11:KLYS:61
     11     ampl( 78)  phas( 78)  lambdaS     1        11.3017 % LI11:KLYS:71
     11     ampl( 79)  phas( 79)  lambdaS     1        12.1764 % LI11:KLYS:81
     11     ampl( 80)  phas( 80)  lambdaS     1        12.1764 % LI12:KLYS:11
     11     ampl( 81)  phas( 81)  lambdaS     1        11.3017 % LI12:KLYS:21
     11     ampl( 82)  phas( 82)  lambdaS     1        12.1764 % LI12:KLYS:31
     11     ampl( 83)  phas( 83)  lambdaS     1        12.1764 % LI12:KLYS:41
     11     ampl( 84)  phas( 84)  lambdaS     1        12.1764 % LI12:KLYS:51
     11     ampl( 85)  phas( 85)  lambdaS     1        12.1764 % LI12:KLYS:61
     11     ampl( 86)  phas( 86)  lambdaS     1        12.1764 % LI12:KLYS:71
     11     ampl( 87)  phas( 87)  lambdaS     1        12.1764 % LI12:KLYS:81
     11     ampl( 88)  phas( 88)  lambdaS     1        12.1764 % LI13:KLYS:11
     11     ampl( 89)  phas( 89)  lambdaS     1        12.1764 % LI13:KLYS:21
     11     ampl( 90)  phas( 90)  lambdaS     1        12.1764 % LI13:KLYS:31
     11     ampl( 91)  phas( 91)  lambdaS     1        12.1764 % LI13:KLYS:41
     11     ampl( 92)  phas( 92)  lambdaS     1        12.1764 % LI13:KLYS:51
     11     ampl( 93)  phas( 93)  lambdaS     1        12.1764 % LI13:KLYS:61
     11     ampl( 94)  phas( 94)  lambdaS     1        12.1764 % LI13:KLYS:71
     11     ampl( 95)  phas( 95)  lambdaS     1        12.1764 % LI13:KLYS:81
     11     ampl( 96)  phas( 96)  lambdaS     1        12.1764 % LI14:KLYS:11
     11     ampl( 97)  phas( 97)  lambdaS     1        12.1764 % LI14:KLYS:21
     11     ampl( 98)  phas( 98)  lambdaS     1        12.1764 % LI14:KLYS:31
     11     ampl( 99)  phas( 99)  lambdaS     1        12.1764 % LI14:KLYS:41
     11     ampl(100)  phas(100)  lambdaS     1        12.1764 % LI14:KLYS:51
     11     ampl(101)  phas(101)  lambdaS     1        12.1764 % LI14:KLYS:61
     11     ampl(102)  phas(102)  lambdaS     1        12.1764 % LI14:KLYS:71
     11     ampl(103)  phas(103)  lambdaS     1        12.1764 % LI14:KLYS:81
     11     ampl(104)  phas(104)  lambdaS     1        12.1764 % LI15:KLYS:11
     11     ampl(105)  phas(105)  lambdaS     1        12.1764 % LI15:KLYS:21
     11     ampl(106)  phas(106)  lambdaS     1        12.1764 % LI15:KLYS:31
     11     ampl(107)  phas(107)  lambdaS     1        12.1764 % LI15:KLYS:41
     11     ampl(108)  phas(108)  lambdaS     1        12.1764 % LI15:KLYS:51
     11     ampl(109)  phas(109)  lambdaS     1        12.1764 % LI15:KLYS:61
     11     ampl(110)  phas(110)  lambdaS     1        12.1764 % LI15:KLYS:71
     11     ampl(111)  phas(111)  lambdaS     1        12.1764 % LI15:KLYS:81
     11     ampl(112)  phas(112)  lambdaS     1        12.1764 % LI16:KLYS:11
     11     ampl(113)  phas(113)  lambdaS     1        12.1764 % LI16:KLYS:21
     11     ampl(114)  phas(114)  lambdaS     1        12.1764 % LI16:KLYS:31
     11     ampl(115)  phas(115)  lambdaS     1        12.1764 % LI16:KLYS:41
     11     ampl(116)  phas(116)  lambdaS     1        12.1764 % LI16:KLYS:51
     11     ampl(117)  phas(117)  lambdaS     1        12.1764 % LI16:KLYS:61
     11     ampl(118)  phas(118)  lambdaS     1        12.1764 % LI16:KLYS:71
     11     ampl(119)  phas(119)  lambdaS     1        12.1764 % LI16:KLYS:81
     11     ampl(120)  phas(120)  lambdaS     1        12.1764 % LI17:KLYS:11
     11     ampl(121)  phas(121)  lambdaS     1        12.1764 % LI17:KLYS:21
     11     ampl(122)  phas(122)  lambdaS     1        12.1764 % LI17:KLYS:31
     11     ampl(123)  phas(123)  lambdaS     1        12.1764 % LI17:KLYS:41
     11     ampl(124)  phas(124)  lambdaS     1        12.1764 % LI17:KLYS:51
     11     ampl(125)  phas(125)  lambdaS     1        12.1764 % LI17:KLYS:61
     11     ampl(126)  phas(126)  lambdaS     1        12.1764 % LI17:KLYS:71
     11     ampl(127)  phas(127)  lambdaS     1        12.1764 % LI17:KLYS:81
     11     ampl(128)  phas(128)  lambdaS     1        12.1764 % LI18:KLYS:11
     11     ampl(129)  phas(129)  lambdaS     1        12.1764 % LI18:KLYS:21
     11     ampl(130)  phas(130)  lambdaS     1        12.1764 % LI18:KLYS:31
     11     ampl(131)  phas(131)  lambdaS     1        12.1764 % LI18:KLYS:41
     11     ampl(132)  phas(132)  lambdaS     1        12.1764 % LI18:KLYS:51
     11     ampl(133)  phas(133)  lambdaS     1        12.1764 % LI18:KLYS:61
     11     ampl(134)  phas(134)  lambdaS     1        12.1764 % LI18:KLYS:71
     11     ampl(135)  phas(135)  lambdaS     1        12.1764 % LI18:KLYS:81
     11     ampl(136)  phas(136)  lambdaS     1        12.1764 % LI19:KLYS:11
     11     ampl(137)  phas(137)  lambdaS     1        12.1764 % LI19:KLYS:21
     11     ampl(138)  phas(138)  lambdaS     1        12.1764 % LI19:KLYS:31
     11     ampl(139)  phas(139)  lambdaS     1        11.3017 % LI19:KLYS:41
     11     ampl(140)  phas(140)  lambdaS     1        12.1764 % LI19:KLYS:51
     11     ampl(141)  phas(141)  lambdaS     1        12.1764 % LI19:KLYS:61
     11     ampl(142)  phas(142)  lambdaS     1        12.1764 % LI19:KLYS:81
		-13		  E2	       1.88     -90.0	       90.0      lambdaS % SCAV energy feedback
     -6     LI20_R56   LI20_T566  E2          0         0      % LI20 R56, T566
     22     0.8E-5     0          0           0         0      % FFTB ISR energy spread
     37     0.01       1          0           0         0      % Z-cut
    -99		  0          0          0           0         0      % end
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