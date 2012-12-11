function MACH = machine_energy(state)
% MACH = get_amp_and_phase() retrieves kylstron amplitude and phase
% information with calculated feedback phases and LEM fudge factors


% Remove LI20 Klystrons which are somehow in the list
i20 = strncmp('KLYS:LI20', state.klys.name, 9);

% Remove KLYS:LI10:81 which has been replaced by S10 chicken
i81 = strncmp('KLYS:LI10:81', state.klys.name, 12);

nope = ~(i81 + i20);

% Get LI02-LI19 devices
LINAC_NAME = state.klys.name(nope); % Klystron name
LINAC_ISON = state.klys.ISON(nope); % Klystron status
LINAC_PHAS = state.klys.PHAS(nope); % Klystron phase readback
LINAC_PDES = state.klys.PDES(nope); % Klystron phase setpoint
LINAC_PACT = state.klys.PACT(nope); % Klystron total phase
LINAC_ENLD = state.klys.ENLD(nope); % Klystron max e-gain
LINAC_LEFF = state.klys.LEFF(nope); % Klystron length
LINAC_KLYZ = state.klys.Z(nope);    % Klystron z position

% Get list of klystrons that are in sectors 2-10
KLYS_02_10 = LINAC_KLYZ < state.lem.Z(2);
% Get list of klystrons that are in sectors 11-20
KLYS_11_20 = LINAC_KLYZ > state.lem.Z(2);

% Special cases for feedback phase shifters - offset particular phases
i91 = strncmp('KLYS:LI09:11', LINAC_NAME, 12);    % offset 9-1
i92 = strncmp('KLYS:LI09:21', LINAC_NAME, 12);    % offset 9-2
i17 = strncmp('KLYS:LI17', LINAC_NAME, 9);        % offset S17
i18 = strncmp('KLYS:LI18', LINAC_NAME, 9);        % offset S18

% List of non FB klystrons that are on
IND_02_10_noFB = LINAC_ISON & KLYS_02_10 & ~i91 & ~i92;
IND_11_20_noFB = LINAC_ISON & KLYS_11_20 & ~i17 & ~i18;
IND_ALL_noFB   = LINAC_ISON & ~i91 & ~i92 & ~i17 & ~i18;


% Assign subbooster index to klystrons
[~,SBST_IND] = histc(LINAC_KLYZ,state.sbst.Z);

% Get total PDES phas
LINAC_TDES = LINAC_PDES + state.sbst.PDES(SBST_IND);

% Get total cavity length per sector
SECT_LEFF = zeros(18,1);
for i=1:18
    SECT_LEFF(i) = sum(LINAC_LEFF(SBST_IND==i));
end
% Add KLYS:LI11:31 length
SECT_LEFF(10) = SECT_LEFF(10) + 6.7180;

% Get average phase per sector
SECT_PHAS = zeros(18,1);
PON = LINAC_PACT(IND_ALL_noFB);
SBS = SBST_IND(IND_ALL_noFB);
for i=1:18
    SECT_PHAS(i) = mean(PON(SBS==i));
end
% Sectors 6 and 7 are off
SECT_PHAS(6:7) = 0;
% Feedback sectors, set later
SECT_PHAS(16:17) = 0;

% Get ENLD energy gain per sector
SECT_ENLD = zeros(18,1);
ENL = LINAC_ENLD(LINAC_ISON);
SBS = SBST_IND(LINAC_ISON);
for i=1:18
    SECT_ENLD(i) = sum(ENL(SBS==i));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Apply LEM to klystrons
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Sum energy without FBCK
S10E_noFB = cumsum(LINAC_ENLD(IND_02_10_noFB).*cosd(LINAC_PACT(IND_02_10_noFB)))+1000.*state.lem.energy(1);
S20E_noFB = cumsum(LINAC_ENLD(IND_11_20_noFB).*cosd(LINAC_PACT(IND_11_20_noFB)))+1000.*state.lem.energy(2);

% Missing energy to be provided by FBCK
E10_miss = 1000*state.lem.energy(2) - S10E_noFB(end);
E20_miss = 1000*state.lem.energy(3) - S20E_noFB(end);

% Supply missing energy with FBs
if E10_miss < (LINAC_ENLD(i91) + LINAC_ENLD(i92))
    %All energy can be supplied with FB tubes, determine phase accordingly
    FB10_PHAS = acosd(E10_miss/(LINAC_ENLD(i91) + LINAC_ENLD(i92)));
else
    %All energy cannot be supplied with FB tubes, set FB phase to zero
    FB10_PHAS = 0;    
end

% Supply missing energy with FBs
if E20_miss < (sum(LINAC_ENLD(i17 & LINAC_ISON)) + sum(LINAC_ENLD(i18 & LINAC_ISON)))
    %All energy can be supplied with FB tubes, determine phase accordingly
    FB20_PHAS = acosd(E20_miss/(sum(LINAC_ENLD(i17 & LINAC_ISON)) + sum(LINAC_ENLD(i18 & LINAC_ISON))));
else
    %All energy cannot be supplied with FB tubes, set FB phase to zero
    FB20_PHAS = 0;    
end

%Get new phase vector
LINAC_PTOT = LINAC_PACT;
LINAC_PTOT(i91) = -FB10_PHAS;
LINAC_PTOT(i92) =  FB10_PHAS;
LINAC_PTOT(i17) = -FB20_PHAS;
LINAC_PTOT(i18) =  FB20_PHAS;

% List of all klystrons that are on
IND_02_10_wFB = LINAC_ISON & KLYS_02_10;
IND_11_20_wFB = LINAC_ISON & KLYS_11_20;

% Sum energy with FBCK
S10E = cumsum(LINAC_ENLD(IND_02_10_wFB).*cosd(LINAC_PTOT(IND_02_10_wFB)))+1000.*state.lem.energy(1);
S20E = cumsum(LINAC_ENLD(IND_11_20_wFB).*cosd(LINAC_PTOT(IND_11_20_wFB)))+1000.*state.lem.energy(2);

% Get residual energy if feedback hasn't made it up
RES10 = 1000.*state.lem.energy(2) - S10E(end);
RES20 = 1000.*state.lem.energy(3) - S20E(end);

% Add a little bit to each klystron according to phase
S10ADD = RES10/sum(IND_02_10_wFB)./cosd(LINAC_PTOT(IND_02_10_wFB));
S20ADD = RES20/sum(IND_11_20_wFB)./cosd(LINAC_PTOT(IND_11_20_wFB));
LINAC_LEM = LINAC_ENLD;
LINAC_LEM(IND_02_10_wFB) = LINAC_ENLD(IND_02_10_wFB) + S10ADD;
LINAC_LEM(IND_11_20_wFB) = LINAC_ENLD(IND_11_20_wFB) + S20ADD;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Apply LEM to sectors
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

e_check = sum(SECT_ENLD.*cosd(SECT_PHAS))/1000+state.lem.energy(1);
if(e_check > 20.35)
    error('You are gonna have to write more code');
end

% Sum energy with FBCK PHAS = 0
Sect10E = cumsum(SECT_ENLD(1:9).*cosd(SECT_PHAS(1:9)))+1000.*state.lem.energy(1);
Sect20E = cumsum(SECT_ENLD(10:18).*cosd(SECT_PHAS(10:18)))+1000.*state.lem.energy(2);

% Get residual energy if feedback hasn't made it up
SectRES10 = 1000.*state.lem.energy(2) - Sect10E(end);
SectRES20 = 1000.*state.lem.energy(3) - Sect20E(end);

% Add a little bit to each sector according to phase
Sect10ADD = SectRES10/7./cosd(SECT_PHAS(1:9));
Sect20ADD = SectRES20/9./cosd(SECT_PHAS(10:18));
SECT_LEM = SECT_ENLD;
SECT_LEM(1:5) = SECT_ENLD(1:5) + Sect10ADD(1:5);
SECT_LEM(8:9) = SECT_ENLD(8:9) + Sect10ADD(8:9);
SECT_LEM(10:18) = SECT_ENLD(10:18) + Sect20ADD;


MACH.KLYS.AMPL = LINAC_LEM.*LINAC_ISON/1000.;
MACH.KLYS.PHAS = LINAC_PTOT.*LINAC_ISON;
MACH.KLYS.LEFF = LINAC_LEFF;
MACH.KLYS.Z    = LINAC_KLYZ;
MACH.KLYS.ENLD = LINAC_ENLD;
MACH.SECT.ENLD = SECT_ENLD;
MACH.SECT.AMPL = SECT_LEM/1000;
MACH.SECT.PHAS = SECT_PHAS;
MACH.SECT.LEFF = SECT_LEFF;
MACH.SECT.Z    = state.sbst.Z;