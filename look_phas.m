%load('/Users/sgess/Desktop/FACET/2012/DATA/E200_1443/E200_1443_slim.mat');
load('/Users/sgess/Desktop/data/E200_DATA/E200_1443/E200_1443_slim.mat');

% NRTL stuff
NRTL_phas = zeros(1,90);
NRTL_ampl = zeros(1,90);

% Pulse ID stuff
pulseID = zeros(1,90);
aidaPID = zeros(1,90);
profPID = zeros(1,90);

% BPM stuff
BPM_2445_X = zeros(1,90);
BPM_2050_X = zeros(1,90);

BPM_2445_Y = zeros(1,90);
BPM_2050_Y = zeros(1,90);

% YAG centroid
YAG_X = zeros(1,90);

for j = 1:18
    
    % Pulse ID stuff
    pulseID(j)    = d_1(j).PulseID;
    pulseID(j+18) = d_2(j).PulseID;
    pulseID(j+36) = d_3(j).PulseID;
    pulseID(j+54) = d_4(j).PulseID;
    pulseID(j+72) = d_5(j).PulseID;
    
    aidaPID(j)    = d_1(j).aida.pulse_id;
    aidaPID(j+18) = d_2(j).aida.pulse_id;
    aidaPID(j+36) = d_3(j).aida.pulse_id;
    aidaPID(j+54) = d_4(j).aida.pulse_id;
    aidaPID(j+72) = d_5(j).aida.pulse_id;
    
    profPID(j)    = d_1(j).YAGS_LI20_2432.prof_pid;
    profPID(j+18) = d_2(j).YAGS_LI20_2432.prof_pid;
    profPID(j+36) = d_3(j).YAGS_LI20_2432.prof_pid;
    profPID(j+54) = d_4(j).YAGS_LI20_2432.prof_pid;
    profPID(j+72) = d_5(j).YAGS_LI20_2432.prof_pid;
    
    % NRTL stuff
    NRTL_phas(j)    = d_1(j).aida.klys.phase;
    NRTL_phas(j+18) = d_2(j).aida.klys.phase;
    NRTL_phas(j+36) = d_3(j).aida.klys.phase;
    NRTL_phas(j+54) = d_4(j).aida.klys.phase;
    NRTL_phas(j+72) = d_5(j).aida.klys.phase;
    
    NRTL_ampl(j)    = d_1(j).DR13_AMPL_11_VACT.val;
    NRTL_ampl(j+18) = d_2(j).DR13_AMPL_11_VACT.val;
    NRTL_ampl(j+36) = d_3(j).DR13_AMPL_11_VACT.val;
    NRTL_ampl(j+54) = d_4(j).DR13_AMPL_11_VACT.val;
    NRTL_ampl(j+72) = d_5(j).DR13_AMPL_11_VACT.val;
    
    % BPM stuff
    BPM_2445_X(j)    = d_1(j).aida.bpms(1).x;
    BPM_2445_X(j+18) = d_2(j).aida.bpms(1).x;
    BPM_2445_X(j+36) = d_3(j).aida.bpms(1).x;
    BPM_2445_X(j+54) = d_4(j).aida.bpms(1).x;
    BPM_2445_X(j+72) = d_5(j).aida.bpms(1).x;
    
    BPM_2050_X(j)    = d_1(j).aida.bpms(16).x;
    BPM_2050_X(j+18) = d_2(j).aida.bpms(16).x;
    BPM_2050_X(j+36) = d_3(j).aida.bpms(16).x;
    BPM_2050_X(j+54) = d_4(j).aida.bpms(16).x;
    BPM_2050_X(j+72) = d_5(j).aida.bpms(16).x;
    
    BPM_2445_Y(j)    = d_1(j).aida.bpms(1).y;
    BPM_2445_Y(j+18) = d_2(j).aida.bpms(1).y;
    BPM_2445_Y(j+36) = d_3(j).aida.bpms(1).y;
    BPM_2445_Y(j+54) = d_4(j).aida.bpms(1).y;
    BPM_2445_Y(j+72) = d_5(j).aida.bpms(1).y;
    
    BPM_2050_Y(j)    = d_1(j).aida.bpms(16).y;
    BPM_2050_Y(j+18) = d_2(j).aida.bpms(16).y;
    BPM_2050_Y(j+36) = d_3(j).aida.bpms(16).y;
    BPM_2050_Y(j+54) = d_4(j).aida.bpms(16).y;
    BPM_2050_Y(j+72) = d_5(j).aida.bpms(16).y;
    
    % YAG stuff
    IMG_1  = rot90(d_1(j).YAGS_LI20_2432.img);
    LINE_1 = mean(IMG_1(175:200,:),1);
end

off = 90 - median(NRTL_phas(:));
    
    