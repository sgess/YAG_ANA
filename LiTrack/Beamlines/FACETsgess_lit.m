  num = 1467;
  MACH=get_amp_and_phase(num,0,0,0);
  ampl = MACH.KLYS.AMPL;
  phas = MACH.KLYS.PHAS;
  leff = MACH.KLYS.LEFF;

  global PARAM; % Initial beam and machine parameters  
  
  % FACET energy set points. We are pretty sure about these, I think. . .
  E0        = PARAM.ENRG.E0;    % GeV ... initial energy
  E1        = PARAM.ENRG.E1;    % GeV ... energy at LBCC
  E2        = PARAM.ENRG.E2;    % GeV ... energy at FACET
  
  % NRTL compressor klystron and R56 #s
  NRTL_ampl = PARAM.NRTL.AMPL;  % AMPL DR13 11 VDES
  NRTL_phas = PARAM.NRTL.PHAS;  % on the zero-crossing
  NRTL_leff = PARAM.NRTL.LEFF;  % cavity length
  NRTL_R56  = PARAM.NRTL.R56;   % This is design val
  NRTL_T566 = PARAM.NRTL.T566;  % Design val?
  NRTL_ELO  = PARAM.NRTL.ELO;   % NRTL low energy cut
  NRTL_EHI  = PARAM.NRTL.EHI;   % NRTL high energy cut
  
  % Phase and length of 02-10
  LONE_leff = PARAM.LONE.LEFF;  % Length of LI02-LI10 (m)
  LONE_phas = PARAM.LONE.PHAS;  % Chirp phase
  LONE_gain = PARAM.LONE.GAIN;  % energy gain in LI02-LI10 (GeV)
  LONE_ampl = PARAM.LONE.FBAM;  % feedback amplitude (GV)
  
  % S10 chcn #s
  LI10_R56  = PARAM.LI10.R56;   % Measured val?
  LI10_T566 = PARAM.LI10.T566;  % Measured val?
  LI10_ISR  = PARAM.LI10.ISR;   %
  
  % Energy gain and length of 02-10
  LTWO_leff = PARAM.LTWO.LEFF;  % Length of LI02-LI10 (m)
  LTWO_phas = PARAM.LTWO.PHAS;  % Chirp phase
  LTWO_ampl = PARAM.LTWO.FBAM;  % feedback amplitude (GV)
  
  % S20 chcn R56 #s
  LI20_R56  = PARAM.LI20.R56;   % Measured val?
  LI20_T566 = PARAM.LI20.T566;  % Measured val?
  LI20_ISR  = PARAM.LI20.ISR;   %
  LI20_ELO  = PARAM.LI20.ELO;   % S20 low energy cut
  LI20_EHI  = PARAM.LI20.EHI;   % S20 high energy cut
  
  % Initial beam parameters
  inp       = 'G';		        % gaussian Z and dE/E (see sigz0 =..., sigd0 =...)
  
  % 6mm bunches coming out of the ring teensy energy spread.
  sigz0     = PARAM.INIT.SIGZ0;	% rms bunch length used when inp=G or U above [m]
  sigd0     = PARAM.INIT.SIGD0;	% rms relative energy spread used when inp=G or U above [ ]
  z0_bar    = PARAM.INIT.Z0BAR; % axial offset of bunch [m] (used also with file input - mean of file removed first)
  d0_bar    = PARAM.INIT.D0BAR; % relative energy offset of bunch [ ]  (used also with file input - mean of file removed first)
  
  % 200K sim particles = 100K electrons per sim particle
  Nesim     = PARAM.INIT.NESIM;	% number of particles to generate for simulation when inp=G or U (reasonable: ~1000 to ~100000)
  Ne        = PARAM.INIT.NPART; % number of particles initially in bunch
  
  % The Holtzapple skew. Someday they'll name a skew after me. . .
  asym      = PARAM.INIT.ASYM;	% for inp='M' or 'G': sets rise/fall time width (-1<asym<1)
  
  % Our beam has no tail? That's a tall tale! Jesus I hope no one reads this. . .
  tail      = PARAM.INIT.TAIL;  % for inp='M' or 'G': sets rise/fall time width (0<=tail<1)
  cut       = PARAM.INIT.CUT;   % for inp='G': sets rise/fall time width (0.5<=cut<inf)
   
  % Other stuff
  splots    = PARAM.SIMU.PLOT;	% if =1, use small plots and show no wakes (for publish size plots)
  plot_frac = PARAM.SIMU.FRAC;  % fraction of particles to plot in the delta-z scatter-plots (0 < plot_frac <= 1)
  Nbin      = PARAM.SIMU.BIN;   % number of bins for z-coordinate (and dE/E for plots)
  gzfit     = PARAM.SIMU.ZFIT;  % if ==1: fit Z-distribution to gaussian (defaults to no-fit if 'gzfit' not provided)
  gdfit     = PARAM.SIMU.DFIT;  % if ==1: fit dE/E-distribution to gaussian (defaults to no-fit if 'gdfit' not provided)
  contf     = PARAM.SIMU.CONT;  % if ==1: get color contour image of z-d space (defaults to scatter plot if not provided)
  
  % S-band wavelength
  lambdaS   = 2.99792458e8/2856e6;

  
  
% The follwing array of file names, "wake_fn", is the point-charge wakefield filename(s) to be used.  The pointer
% to the used filename appears in the 5th column (wake ON/OFF) of the 'beamline' array below.  A "zero" (i.e. 0)
% means no wake used, and a value of j (e.g. 1,2,...) directs the calculation to use the jth point-charge wakefield
% file (i.e. the jth row of "wake_fn") for that part of the beamline.

% We always use dat slac
  wake_fn=[ ...
    'slac.dat         '; ...
    'slacx.dat        '; ...
    'SlacL.dat        '; ...
    'Slac_cu_rw.dat   '; ...
    'SS_12700um_rw.dat'; ...
    'Al_12700um_rw.dat'; ...
  ]; % name of point-charge wakefield file(s) ["slac.dat" is default if filename not given]

  comment='FACET (sgess''s best guess)'; % text comment which appears at bottom of plots

%==============|==============================================================================================
%	CODES      |		1				2				3				4				5				6
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
% FACET
%=============================================================================================================
  
  beamline=[
      
    % RTL: The energy cut is a little tighter than in the file MJH gave me.
     -1     0		   0          0           0        0         % initial particles
    -11     NRTL_ampl  NRTL_phas  lambdaS     1        NRTL_leff % NRTL compressor
     26     NRTL_ELO   NRTL_EHI   0           0        0         % energy spread cut
     -6     NRTL_R56   NRTL_T566  E0          0        0         % NRTL R56, T566
     
    % LI02: SBST PDES ~ 0
     11     ampl(  1)  phas(  1)  lambdaS     1        leff(  1) % LI02:KLYS:21
     11     ampl(  2)  phas(  2)  lambdaS     1        leff(  2) % LI02:KLYS:11
     11     ampl(  3)  phas(  3)  lambdaS     1        leff(  3) % LI02:KLYS:31
     11     ampl(  4)  phas(  4)  lambdaS     1        leff(  4) % LI02:KLYS:41
     11     ampl(  5)  phas(  5)  lambdaS     1        leff(  5) % LI02:KLYS:51
     11     ampl(  6)  phas(  6)  lambdaS     1        leff(  6) % LI02:KLYS:61
     11     ampl(  7)  phas(  7)  lambdaS     1        leff(  7) % LI02:KLYS:71
    -11     ampl(  8)  phas(  8)  lambdaS     1        leff(  8) % LI02:KLYS:81
     
    % LI03: SBST PDES ~ 11
     11     ampl(  9)  phas(  9)  lambdaS     1        leff(  9) % LI03:KLYS:11
     11     ampl( 10)  phas( 10)  lambdaS     1        leff( 10) % LI03:KLYS:21
     11     ampl( 11)  phas( 11)  lambdaS     1        leff( 11) % LI03:KLYS:31
     11     ampl( 12)  phas( 12)  lambdaS     1        leff( 12) % LI03:KLYS:41
     11     ampl( 13)  phas( 13)  lambdaS     1        leff( 13) % LI03:KLYS:51
     11     ampl( 14)  phas( 14)  lambdaS     1        leff( 14) % LI03:KLYS:61
     11     ampl( 15)  phas( 15)  lambdaS     1        leff( 15) % LI03:KLYS:71
    -11     ampl( 16)  phas( 16)  lambdaS     1        leff( 16) % LI03:KLYS:81
     
    % LI04: SBST PDES ~ 22
     11     ampl( 17)  phas( 17)  lambdaS     1        leff( 17) % LI04:KLYS:11
     11     ampl( 18)  phas( 18)  lambdaS     1        leff( 18) % LI04:KLYS:21
     11     ampl( 19)  phas( 19)  lambdaS     1        leff( 19) % LI04:KLYS:31
     11     ampl( 20)  phas( 20)  lambdaS     1        leff( 20) % LI04:KLYS:41
     11     ampl( 21)  phas( 21)  lambdaS     1        leff( 21) % LI04:KLYS:51
     11     ampl( 22)  phas( 22)  lambdaS     1        leff( 22) % LI04:KLYS:61
     11     ampl( 23)  phas( 23)  lambdaS     1        leff( 23) % LI04:KLYS:71
    -11     ampl( 24)  phas( 24)  lambdaS     1        leff( 24) % LI04:KLYS:81
     
    % LI05: SBST PDES ~ 33
     11     ampl( 25)  phas( 25)  lambdaS     1        leff( 25) % LI05:KLYS:11
     11     ampl( 26)  phas( 26)  lambdaS     1        leff( 26) % LI05:KLYS:21
     11     ampl( 27)  phas( 27)  lambdaS     1        leff( 27) % LI05:KLYS:31
     11     ampl( 28)  phas( 28)  lambdaS     1        leff( 28) % LI05:KLYS:41
     11     ampl( 29)  phas( 29)  lambdaS     1        leff( 29) % LI05:KLYS:51
     11     ampl( 30)  phas( 30)  lambdaS     1        leff( 30) % LI05:KLYS:61
     11     ampl( 31)  phas( 31)  lambdaS     1        leff( 31) % LI05:KLYS:71
    -11     ampl( 32)  phas( 32)  lambdaS     1        leff( 32) % LI05:KLYS:81
     
    % LI06: SBST PDES ~ 44
     11     ampl( 33)  phas( 33)  lambdaS     1        leff( 33) % LI06:KLYS:11
     11     ampl( 34)  phas( 34)  lambdaS     1        leff( 34) % LI06:KLYS:21
     11     ampl( 35)  phas( 35)  lambdaS     1        leff( 35) % LI06:KLYS:31
     11     ampl( 36)  phas( 36)  lambdaS     1        leff( 36) % LI06:KLYS:41
     11     ampl( 37)  phas( 37)  lambdaS     1        leff( 37) % LI06:KLYS:51
     11     ampl( 38)  phas( 38)  lambdaS     1        leff( 38) % LI06:KLYS:61
     11     ampl( 39)  phas( 39)  lambdaS     1        leff( 39) % LI06:KLYS:71
    -11     ampl( 40)  phas( 40)  lambdaS     1        leff( 40) % LI06:KLYS:81
     
    % LI07: SECTOR OFF
     11     ampl( 41)  phas( 41)  lambdaS     1        leff( 41) % LI07:KLYS:11
     11     ampl( 42)  phas( 42)  lambdaS     1        leff( 42) % LI07:KLYS:21
     11     ampl( 43)  phas( 43)  lambdaS     1        leff( 43) % LI07:KLYS:31
     11     ampl( 44)  phas( 44)  lambdaS     1        leff( 44) % LI07:KLYS:41
     11     ampl( 45)  phas( 45)  lambdaS     1        leff( 45) % LI07:KLYS:51
     11     ampl( 46)  phas( 46)  lambdaS     1        leff( 46) % LI07:KLYS:61
     11     ampl( 47)  phas( 47)  lambdaS     1        leff( 47) % LI07:KLYS:71
    -11     ampl( 48)  phas( 48)  lambdaS     1        leff( 48) % LI07:KLYS:81
     
    % LI08: SECTOR OFF
     11     ampl( 49)  phas( 49)  lambdaS     1        leff( 49) % LI08:KLYS:11
     11     ampl( 50)  phas( 50)  lambdaS     1        leff( 50) % LI08:KLYS:21
     11     ampl( 51)  phas( 51)  lambdaS     1        leff( 51) % LI08:KLYS:31
     11     ampl( 52)  phas( 52)  lambdaS     1        leff( 52) % LI08:KLYS:41
     11     ampl( 53)  phas( 53)  lambdaS     1        leff( 53) % LI08:KLYS:51
     11     ampl( 54)  phas( 54)  lambdaS     1        leff( 54) % LI08:KLYS:61
     11     ampl( 55)  phas( 55)  lambdaS     1        leff( 55) % LI08:KLYS:71
    -11     ampl( 56)  phas( 56)  lambdaS     1        leff( 56) % LI08:KLYS:81
    
    % LI09: SBST PDES ~ 0, 9-1 and 9-2 are FB tubes w/fast phase shifters
     11     ampl( 57)  phas( 57)  lambdaS     1        leff( 57) % LI09:KLYS:11
     11     ampl( 58)  phas( 58)  lambdaS     1        leff( 58) % LI09:KLYS:21
     11     ampl( 59)  phas( 59)  lambdaS     1        leff( 59) % LI09:KLYS:31
     11     ampl( 60)  phas( 60)  lambdaS     1        leff( 60) % LI09:KLYS:41
     11     ampl( 61)  phas( 61)  lambdaS     1        leff( 61) % LI09:KLYS:51
     11     ampl( 62)  phas( 62)  lambdaS     1        leff( 62) % LI09:KLYS:61
     11     ampl( 63)  phas( 63)  lambdaS     1        leff( 63) % LI09:KLYS:71
    -11     ampl( 64)  phas( 64)  lambdaS     1        leff( 64) % LI09:KLYS:81
     
    % LI10: SBST PDES ~ 55, The facet_getMachine state has the LI10:KLYS:81 
    %       but I removed it in get_amp_and_phase because it was replaced 
    %       by the S10 chicken 
     11     ampl( 65)  phas( 65)  lambdaS     1        leff( 65) % LI10:KLYS:11
     11     ampl( 66)  phas( 66)  lambdaS     1        leff( 66) % LI10:KLYS:21
     11     ampl( 67)  phas( 67)  lambdaS     1        leff( 67) % LI10:KLYS:31
     11     ampl( 68)  phas( 68)  lambdaS     1        leff( 68) % LI10:KLYS:41
     11     ampl( 69)  phas( 69)  lambdaS     1        leff( 69) % LI10:KLYS:51
     11     ampl( 70)  phas( 70)  lambdaS     1        leff( 70) % LI10:KLYS:61
    -11     ampl( 71)  phas( 71)  lambdaS     1        leff( 71) % LI10:KLYS:71
    -13     E1         LONE_ampl  -90         90       lambdaS   % Energy feedback to set 9GeV in chicane
     
    % S10 CHCKN: MJH file has S10 chicken in two sections but only need one
	  7	    LI10_R56   E1	      0           0        0         % LBCC chicane
     22     LI10_ISR   0          0           0        0         % LBCC ISR energy spread
    -37     0.01       1          0           0        0         % Z-cut
    
    % LI11: SBST PDES ~ 0, LI11:KLYS:31 does not show up in Nate's list so
    %       it is added by hand
     11     ampl( 72)  phas( 72)  lambdaS     1        leff( 72) % LI11:KLYS:11
     11     ampl( 73)  phas( 73)  lambdaS     1        leff( 73) % LI11:KLYS:21
     11     0          0          lambdaS     1        6.7180    % LI11:KLYS:31
     11     ampl( 74)  phas( 74)  lambdaS     1        leff( 74) % LI11:KLYS:41
     11     ampl( 75)  phas( 75)  lambdaS     1        leff( 75) % LI11:KLYS:51
     11     ampl( 76)  phas( 76)  lambdaS     1        leff( 76) % LI11:KLYS:61
     11     ampl( 77)  phas( 77)  lambdaS     1        leff( 77) % LI11:KLYS:71
    -11     ampl( 78)  phas( 78)  lambdaS     1        leff( 78) % LI11:KLYS:81
    
    % LI12: SBST PDES ~ 0
     11     ampl( 79)  phas( 79)  lambdaS     1        leff( 79) % LI12:KLYS:11
     11     ampl( 80)  phas( 80)  lambdaS     1        leff( 80) % LI12:KLYS:21
     11     ampl( 81)  phas( 81)  lambdaS     1        leff( 81) % LI12:KLYS:31
     11     ampl( 82)  phas( 82)  lambdaS     1        leff( 82) % LI12:KLYS:41
     11     ampl( 83)  phas( 83)  lambdaS     1        leff( 83) % LI12:KLYS:51
     11     ampl( 84)  phas( 84)  lambdaS     1        leff( 84) % LI12:KLYS:61
     11     ampl( 85)  phas( 85)  lambdaS     1        leff( 85) % LI12:KLYS:71
    -11     ampl( 86)  phas( 86)  lambdaS     1        leff( 86) % LI12:KLYS:81
     
    % LI13: SBST PDES ~ 0
     11     ampl( 87)  phas( 87)  lambdaS     1        leff( 87) % LI13:KLYS:11
     11     ampl( 88)  phas( 88)  lambdaS     1        leff( 88) % LI13:KLYS:21
     11     ampl( 89)  phas( 89)  lambdaS     1        leff( 89) % LI13:KLYS:31
     11     ampl( 90)  phas( 90)  lambdaS     1        leff( 90) % LI13:KLYS:41
     11     ampl( 91)  phas( 91)  lambdaS     1        leff( 91) % LI13:KLYS:51
     11     ampl( 92)  phas( 92)  lambdaS     1        leff( 92) % LI13:KLYS:61
     11     ampl( 93)  phas( 93)  lambdaS     1        leff( 93) % LI13:KLYS:71
    -11     ampl( 94)  phas( 94)  lambdaS     1        leff( 94) % LI13:KLYS:81
     
    % LI14: SBST PDES ~ 0
     11     ampl( 95)  phas( 95)  lambdaS     1        leff( 95) % LI14:KLYS:11
     11     ampl( 96)  phas( 96)  lambdaS     1        leff( 96) % LI14:KLYS:21
     11     ampl( 97)  phas( 97)  lambdaS     1        leff( 97) % LI14:KLYS:31
     11     ampl( 98)  phas( 98)  lambdaS     1        leff( 98) % LI14:KLYS:41
     11     ampl( 99)  phas( 99)  lambdaS     1        leff( 99) % LI14:KLYS:51
     11     ampl(100)  phas(100)  lambdaS     1        leff(100) % LI14:KLYS:61
     11     ampl(101)  phas(101)  lambdaS     1        leff(101) % LI14:KLYS:71
    -11     ampl(102)  phas(102)  lambdaS     1        leff(102) % LI14:KLYS:81
     
    % LI15: SBST PDES ~ 0
     11     ampl(103)  phas(103)  lambdaS     1        leff(103) % LI15:KLYS:11
     11     ampl(104)  phas(104)  lambdaS     1        leff(104) % LI15:KLYS:21
     11     ampl(105)  phas(105)  lambdaS     1        leff(105) % LI15:KLYS:31
     11     ampl(106)  phas(106)  lambdaS     1        leff(106) % LI15:KLYS:41
     11     ampl(107)  phas(107)  lambdaS     1        leff(107) % LI15:KLYS:51
     11     ampl(108)  phas(108)  lambdaS     1        leff(108) % LI15:KLYS:61
     11     ampl(109)  phas(109)  lambdaS     1        leff(109) % LI15:KLYS:71
    -11     ampl(110)  phas(110)  lambdaS     1        leff(110) % LI15:KLYS:81
     
    % LI16: SBST PDES ~ 0
     11     ampl(111)  phas(111)  lambdaS     1        leff(111) % LI16:KLYS:11
     11     ampl(112)  phas(112)  lambdaS     1        leff(112) % LI16:KLYS:21
     11     ampl(113)  phas(113)  lambdaS     1        leff(113) % LI16:KLYS:31
     11     ampl(114)  phas(114)  lambdaS     1        leff(114) % LI16:KLYS:41
     11     ampl(115)  phas(115)  lambdaS     1        leff(115) % LI16:KLYS:51
     11     ampl(116)  phas(116)  lambdaS     1        leff(116) % LI16:KLYS:61
     11     ampl(117)  phas(117)  lambdaS     1        leff(117) % LI16:KLYS:71
    -11     ampl(118)  phas(118)  lambdaS     1        leff(118) % LI16:KLYS:81
     
    % LI17: Entire sector phase set by fast FB phase shifter
     11     ampl(119)  phas(119)  lambdaS     1        leff(119) % LI17:KLYS:11
     11     ampl(120)  phas(120)  lambdaS     1        leff(120) % LI17:KLYS:21
     11     ampl(121)  phas(121)  lambdaS     1        leff(121) % LI17:KLYS:31
     11     ampl(122)  phas(122)  lambdaS     1        leff(122) % LI17:KLYS:41
     11     ampl(123)  phas(123)  lambdaS     1        leff(123) % LI17:KLYS:51
     11     ampl(124)  phas(124)  lambdaS     1        leff(124) % LI17:KLYS:61
     11     ampl(125)  phas(125)  lambdaS     1        leff(125) % LI17:KLYS:71
    -11     ampl(126)  phas(126)  lambdaS     1        leff(126) % LI17:KLYS:81
     
    % LI18: Entire sector phase set by fast FB phase shifter (opposite S18)
     11     ampl(127)  phas(127)  lambdaS     1        leff(127) % LI18:KLYS:11
     11     ampl(128)  phas(128)  lambdaS     1        leff(128) % LI18:KLYS:21
     11     ampl(129)  phas(129)  lambdaS     1        leff(129) % LI18:KLYS:31
     11     ampl(130)  phas(130)  lambdaS     1        leff(130) % LI18:KLYS:41
     11     ampl(131)  phas(131)  lambdaS     1        leff(131) % LI18:KLYS:51
     11     ampl(132)  phas(132)  lambdaS     1        leff(132) % LI18:KLYS:61
     11     ampl(133)  phas(133)  lambdaS     1        leff(133) % LI18:KLYS:71
    -11     ampl(134)  phas(134)  lambdaS     1        leff(134) % LI18:KLYS:81
     
    % LI19: SBST PDES ~ 0
     11     ampl(135)  phas(135)  lambdaS     1        leff(135) % LI19:KLYS:11
     11     ampl(136)  phas(136)  lambdaS     1        leff(136) % LI19:KLYS:21
     11     ampl(137)  phas(137)  lambdaS     1        leff(137) % LI19:KLYS:31
     11     ampl(138)  phas(138)  lambdaS     1        leff(138) % LI19:KLYS:41
     11     ampl(139)  phas(139)  lambdaS     1        leff(139) % LI19:KLYS:51
     11     ampl(140)  phas(140)  lambdaS     1        leff(140) % LI19:KLYS:61
    -11     ampl(141)  phas(141)  lambdaS     1        leff(141) % LI19:KLYS:81
    -13		E2	       LTWO_ampl  -90.0	      90.0     lambdaS   % SCAV energy feedback

    % LI20: FACET CHICANE
      6     LI20_R56   LI20_T566  E2          0        0         % LI20 R56, T566
     22     LI20_ISR   0          0           0        0         % FFTB ISR energy spread
     37     0.01       1          0           0        0         % Z-cut
    -99		0          0          0           0        0         % end
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