function MACH = des_amp_and_phase(lattice)
% MACH = des_amp_and_phase() retrieves kylstron amplitude and phase
% information with calculated feedback phases and LEM fudge factors

global PARAM;
E0        = PARAM.ENRG.E0;    % GeV ... initial energy
E1        = PARAM.ENRG.E1;    % GeV ... energy at LBCC
E2        = PARAM.ENRG.E2;    % GeV ... energy at FACET

LONE_phas = PARAM.LONE.PHAS;
LTWO_phas = PARAM.LTWO.PHAS;
LONE_gain = PARAM.LONE.GAIN;

MACH.SECT.Z = [101.6000; % Start LI02
               203.2000; % Start LI03
               304.8000; % Start LI04
               406.4000; % Start LI05
               508.0000; % Start LI06
               609.6000; % Start LI07
               711.2000; % Start LI08
               812.8000; % Start LI09
               914.4000; % Start LI10
               1016.000; % Start LI11
               1117.600; % Start LI12
               1219.200; % Start LI13
               1320.800; % Start LI14
               1422.400; % Start LI15
               1524.000; % Start LI16
               1625.600; % Start LI17
               1727.200; % Start LI18
               1828.800; % Start LI19
               1930.400];% Start LI20
           
MACH.SECT.LEFF = [75.4737; % Length LI02
                  96.0120; % Length LI03
                  84.0105; % Length LI04
                  97.4112; % Length LI05
                  97.4112; % Length LI06
                  97.4112; % Length LI07
                  97.4112; % Length LI08
                  97.4112; % Length LI09
                  66.9702; % Length LI10
                  82.7858; % Length LI11
                  96.5365; % Length LI12
                  97.4112; % Length LI13
                  97.4112; % Length LI14
                  97.4112; % Length LI15
                  97.4112; % Length LI16
                  97.4112; % Length LI17
                  97.4112; % Length LI18
                  84.3601];% Length LI19
              
if strcmp(lattice,'uniform')
    
    if LONE_gain == 0
        Egain = E1 - E0;
        Eampl = Egain/cosd(LONE_phas);
    else
        Eampl = LONE_gain;
    end
    L0210 = sum(MACH.SECT.LEFF(1:9));
    MACH.SECT.AMPL(1:9) = Eampl*MACH.SECT.LEFF(1:9)/L0210;
    MACH.SECT.PHAS(1:9) = LONE_phas;
    
    Egain = E2 - E1;
    Eampl = Egain/cosd(LTWO_phas);
    L1120 = sum(MACH.SECT.LEFF(10:18));
    MACH.SECT.AMPL(10:18) = Eampl*MACH.SECT.LEFF(10:18)/L1120;
    MACH.SECT.PHAS(10:18) = LTWO_phas;
    
end
    
MACH.SECT.AMPL = MACH.SECT.AMPL';
MACH.SECT.PHAS = MACH.SECT.PHAS';
           
               
               