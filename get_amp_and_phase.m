function [AMPL, PHAS] = get_amp_and_phase(state_file)
% [AMPL, PHAS] = get_amp_and_phase() retrieves kylstron amplitude and phase
% information with calculated feedback phases and LEM fudge factors

%clear all;
%state_file = '../DATA/July_3/E200_1443/E200_1443_State.mat';

% Load machine state data
load(state_file);

% Remove LI20 Klystrons which are somehow in the list
i20 = strncmp('KLYS:LI20', state.klys.name, 9);

% Get LI02-LI19 devices
LINAC_NAME = state.klys.name(~i20); % Klystron name
LINAC_ISON = state.klys.ISON(~i20); % Klystron status
LINAC_PHAS = state.klys.PHAS(~i20); % Klystron phase readback
LINAC_PDES = state.klys.PDES(~i20); % Klystron phase setpoint
LINAC_PACT = state.klys.PACT(~i20); % Klystron total phase
LINAC_ENLD = state.klys.ENLD(~i20); % Klystron max e-gain
LINAC_LEFF = state.klys.LEFF(~i20); % Klystron length
LINAC_KLYZ = state.klys.Z(~i20);    % Klystron z position

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
S10E_noFB = sum(LINAC_ENLD(IND_02_10_noFB).*cos(pi/180*LINAC_PACT(IND_02_10_noFB)))+1000.*state.lem.energy(1);
S20E_noFB = sum(LINAC_ENLD(IND_11_20_noFB).*cos(pi/180*LINAC_PACT(IND_11_20_noFB)))+1000.*state.lem.energy(2);

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
if E20_miss < sum(LINAC_ENLD(i17) + LINAC_ENLD(i18))
    %All energy can be supplied with FB tubes, determine phase accordingly
    FB20_PHAS = acosd(E20_miss/sum(LINAC_ENLD(i17) + LINAC_ENLD(i18)));
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
S10E = sum(LINAC_ENLD(IND_02_10_wFB).*cos(pi/180*LINAC_PTOT(IND_02_10_wFB)))+1000.*state.lem.energy(1)
S20E = sum(LINAC_ENLD(IND_11_20_wFB).*cos(pi/180*LINAC_PTOT(IND_11_20_wFB)))+1000.*state.lem.energy(2)

%LEM 2-10
LINAC_ENLD(IND_02_10_wFB) = 1000*state.lem.energy(2)/S10E * LINAC_ENLD(IND_02_10_wFB);
RES10 = 1000*state.lem.energy(2) - sum(LINAC_ENLD(IND_02_10_wFB).*cos(pi/180*LINAC_PTOT(IND_02_10_wFB))) - 1000*state.lem.energy(1)

%Still not there?
if RES10 ~= 0
    LINAC_ENLD(i91) = LINAC_ENLD(i91) + RES10;
end

%LEM 11-20
LINAC_ENLD(IND_11_20_wFB) = 1000*state.lem.energy(3)/S20E * LINAC_ENLD(IND_11_20_wFB);
RES20 = 1000*state.lem.energy(3) - sum(LINAC_ENLD(IND_11_20_wFB).*cos(pi/180*LINAC_PTOT(IND_11_20_wFB))) - 1000*state.lem.energy(2)

%Still not there?
if RES20 ~= 0
    LINAC_ENLD(i17) = LINAC_ENLD(i17) + RES20/length(LINAC_ENLD(i17));
end

AMPL = LINAC_ENLD;
PHAS = LINAC_PTOT;

% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%% S10 CHICKEN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% % Get list of klystrons that are on in sectors 11-20
% KLYS_11_20_ind = state.klys.ISON & state.klys.Z > state.lem.Z(2) & state.klys.Z < state.lem.Z(3);
% 
% % Special cases for feedback phase shifters - offset particular phases
% i17 = strncmp('KLYS:LI17', state.klys.name, 9) & state.klys.ISON;    % offset S17
% i18 = strncmp('KLYS:LI18', state.klys.name, 9) & state.klys.ISON;    % offset S18
% KLYS_11_20_noFB = logical(KLYS_11_20_ind - i17 - i18);
% 
% % Assign subbooster index to klystrons in 11-20
% [~,SBST_11_20_ind] = histc(state.klys.Z,state.sbst.Z);
% 
% % Compute total PHAS
% LI_11_20_PHAS_noFB = state.klys.PHAS(KLYS_11_20_noFB) + state.sbst.PHAS(SBST_11_20_ind(KLYS_11_20_noFB));
% 
% % Sum energy without FBCK
% S20E_noFB = sum(state.klys.ENLD(KLYS_11_20_noFB).*cos(pi/180*LI_11_20_PHAS_noFB))+1000.*state.lem.energy(2);
% 
% % Missing energy to be provided by FBCK
% E20_miss = 1000*state.lem.energy(3) - S20E_noFB;
% 
% % Supply missing energy with FBs
% if E20_miss < (sum(state.klys.ENLD(i17)) + sum(state.klys.ENLD(i18)))
%     %All energy can be supplied with FB tubes, determine phase accordingly
%     FB20_PHAS = acosd(E20_miss/(sum(state.klys.ENLD(i17)) + sum(state.klys.ENLD(i18))));
% else
%     %All energy cannot be supplied with FB tubes, set FB phase to zero
%     FB20_PHAS = 0;    
% end
%     
% %Get new phase vector
% LI_11_20_PHAS = state.klys.PHAS(KLYS_11_20_ind) + state.sbst.PHAS(SBST_11_20_ind(KLYS_11_20_ind));
% 
% %Insert FB phases
% i17 = strncmp('KLYS:LI17', state.klys.name(KLYS_11_20_ind), 9);    % offset 9-1
% i18 = strncmp('KLYS:LI18', state.klys.name(KLYS_11_20_ind), 9);    % offset 9-2
% LI_11_20_PHAS(i17) = -FB20_PHAS;
% LI_11_20_PHAS(i18) = FB20_PHAS;
% 
% % Sum energy with FBCK
% S20E = sum(state.klys.ENLD(KLYS_11_20_ind).*cos(pi/180*LI_11_20_PHAS))+1000.*state.lem.energy(2);
% 
% %LEM
% LI_11_20_AMPL = 1000*state.lem.energy(3)/S20E * state.klys.ENLD(KLYS_11_20_ind);
% RES20 = 1000*state.lem.energy(3) - sum(LI_11_20_AMPL.*cos(pi/180*LI_11_20_PHAS)) - 1000*state.lem.energy(2);
% 
% %Still not there?
% if RES20 ~= 0
%     LI_11_20_AMPL(i17) = LI_11_20_AMPL(i17) + RES20/length(LI_11_20_AMPL(i17));
% end

