function [AMPL, PHAS, LEFF, NAME] = get_amp_and_phase(state_file)
% [AMPL, PHAS] = get_amp_and_phase() retrieves kylstron amplitude and phase
% information with calculated feedback phases and LEM fudge factors


% Load machine state data
load(state_file);

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

% Assign subbooster index to klystrons
[~,SBST_IND] = histc(LINAC_KLYZ,state.sbst.Z);

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

% Sum energy without FBCK
S10E_noFB = sum(LINAC_ENLD(IND_02_10_noFB).*cosd(LINAC_PACT(IND_02_10_noFB)))+1000.*state.lem.energy(1);
S20E_noFB = sum(LINAC_ENLD(IND_11_20_noFB).*cosd(LINAC_PACT(IND_11_20_noFB)))+1000.*state.lem.energy(2);

% Missing energy to be provided by FBCK
E10_miss = 1000*state.lem.energy(2) - S10E_noFB;
E20_miss = 1000*state.lem.energy(3) - S20E_noFB;

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
S10E = sum(LINAC_ENLD(IND_02_10_wFB).*cosd(LINAC_PTOT(IND_02_10_wFB)))+1000.*state.lem.energy(1);
S20E = sum(LINAC_ENLD(IND_11_20_wFB).*cosd(LINAC_PTOT(IND_11_20_wFB)))+1000.*state.lem.energy(2);

%LEM 2-10
LINAC_ENLD(IND_02_10_wFB) = 1000*state.lem.energy(2)/S10E * LINAC_ENLD(IND_02_10_wFB);
RES10 = 1000*state.lem.energy(2) - sum(LINAC_ENLD(IND_02_10_wFB).*cosd(LINAC_PTOT(IND_02_10_wFB))) - 1000*state.lem.energy(1);

%Still not there?
if RES10 ~= 0
    LINAC_ENLD(i91) = LINAC_ENLD(i91) + RES10;
end

%LEM 11-20
LINAC_ENLD(IND_11_20_wFB) = 1000*state.lem.energy(3)/S20E * LINAC_ENLD(IND_11_20_wFB);
RES20 = 1000*state.lem.energy(3) - sum(LINAC_ENLD(IND_11_20_wFB).*cosd(LINAC_PTOT(IND_11_20_wFB))) - 1000*state.lem.energy(2);

%Still not there?
if RES20 ~= 0
    LINAC_ENLD(i17 & LINAC_ISON) = LINAC_ENLD(i17 & LINAC_ISON) + RES20/length(LINAC_ENLD(i17 & LINAC_ISON));
end

AMPL = LINAC_ENLD.*LINAC_ISON/1000.;
PHAS = LINAC_PTOT;
LEFF = LINAC_LEFF;
NAME = LINAC_NAME;