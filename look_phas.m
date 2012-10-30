%load('/Users/sgess/Desktop/FACET/2012/DATA/E200_1443/E200_1443_slim.mat');

phase = zeros(5,18);
ampl = zeros(5,18);

% Pulse ID stuff
pulseID = zeros(1,90);
aidaPID = zeros(1,90);
profPID = zeros(1,90);

%

for j = 1:18
    
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
    
    phase(1,j) = d_1(j).aida.klys.phase;
    phase(2,j) = d_2(j).aida.klys.phase;
    phase(3,j) = d_3(j).aida.klys.phase;
    phase(4,j) = d_4(j).aida.klys.phase;
    phase(5,j) = d_5(j).aida.klys.phase;
    
    ampl(1,j) = d_1(j).DR13_AMPL_11_VACT.val;
    ampl(2,j) = d_2(j).DR13_AMPL_11_VACT.val;
    ampl(3,j) = d_3(j).DR13_AMPL_11_VACT.val;
    ampl(4,j) = d_4(j).DR13_AMPL_11_VACT.val;
    ampl(5,j) = d_5(j).DR13_AMPL_11_VACT.val;
    
end

    off = 90 - median(phase(:));
    
    