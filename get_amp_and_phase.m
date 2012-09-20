function [LI_02_10_AMPL, LI_02_10_PHAS, LI_11_20_AMPL, LI_11_20_PHAS] = get_amp_and_phase(file)
% Load machine state data
load(file);

% Get list of klystrons that are on in sectors 2-10
KLYS_02_10_ind = state.klys.ISON & abs(state.klys.Z) < state.lem.Z(2);

% Special cases for feedback phase shifters - offset particular phases
i91 = strncmp('KLYS:LI09:11', state.klys.name, 12);    % offset 9-1
i92 = strncmp('KLYS:LI09:21', state.klys.name, 12);    % offset 9-2
KLYS_02_10_noFB = logical(KLYS_02_10_ind - i91 - i92);

% Assign subbooster index to klystrons in 2-10
[~,SBST_02_10_ind] = histc(state.klys.Z,state.sbst.Z);

% Compute total PHAS
LI_02_10_PHAS_noFB = state.klys.PHAS(KLYS_02_10_noFB) + state.sbst.PHAS(SBST_02_10_ind(KLYS_02_10_noFB));

% Sum energy without FBCK
S10E_noFB = sum(state.klys.ENLD(KLYS_02_10_noFB).*cos(pi/180*LI_02_10_PHAS_noFB))+1000.*state.lem.energy(1);

% Missing energy to be provided by FBCK
E10_miss = 1000*state.lem.energy(2) - S10E_noFB;

% Supply missing energy with FBs
if E10_miss < (state.klys.ENLD(i91) + state.klys.ENLD(i92))
    %All energy can be supplied with FB tubes, determine phase accordingly
    FB10_PHAS = acosd(E10_miss/(state.klys.ENLD(i91) + state.klys.ENLD(i92)));
else
    %All energy cannot be supplied with FB tubes, set FB phase to zero
    FB10_PHAS = 0;    
end
    
%Get new phase vector
LI_02_10_PHAS = state.klys.PHAS(KLYS_02_10_ind) + state.sbst.PHAS(SBST_02_10_ind(KLYS_02_10_ind));

%Insert FB phases
i91 = strncmp('KLYS:LI09:11', state.klys.name(KLYS_02_10_ind), 12);    % offset 9-1
i92 = strncmp('KLYS:LI09:21', state.klys.name(KLYS_02_10_ind), 12);    % offset 9-2
LI_02_10_PHAS(i91) = -FB10_PHAS;
LI_02_10_PHAS(i92) = FB10_PHAS;

% Sum energy with FBCK
S10E = sum(state.klys.ENLD(KLYS_02_10_ind).*cos(pi/180*LI_02_10_PHAS))+1000.*state.lem.energy(1);

%LEM
LI_02_10_AMPL = 1000*state.lem.energy(2)/S10E * state.klys.ENLD(KLYS_02_10_ind);
RES10 = 1000*state.lem.energy(2) - sum(LI_02_10_AMPL.*cos(pi/180*LI_02_10_PHAS)) - 1000*state.lem.energy(1);

%Still not there?
if RES10 ~= 0
    LI_02_10_AMPL(i91) = LI_02_10_AMPL(i91) + RES10;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% S10 CHICKEN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get list of klystrons that are on in sectors 11-20
KLYS_11_20_ind = state.klys.ISON & state.klys.Z > state.lem.Z(2) & state.klys.Z < state.lem.Z(3);

% Special cases for feedback phase shifters - offset particular phases
i17 = strncmp('KLYS:LI17', state.klys.name, 9) & state.klys.ISON;    % offset S17
i18 = strncmp('KLYS:LI18', state.klys.name, 9) & state.klys.ISON;    % offset S18
KLYS_11_20_noFB = logical(KLYS_11_20_ind - i17 - i18);

% Assign subbooster index to klystrons in 11-20
[~,SBST_11_20_ind] = histc(state.klys.Z,state.sbst.Z);

% Compute total PHAS
LI_11_20_PHAS_noFB = state.klys.PHAS(KLYS_11_20_noFB) + state.sbst.PHAS(SBST_11_20_ind(KLYS_11_20_noFB));

% Sum energy without FBCK
S20E_noFB = sum(state.klys.ENLD(KLYS_11_20_noFB).*cos(pi/180*LI_11_20_PHAS_noFB))+1000.*state.lem.energy(2);

% Missing energy to be provided by FBCK
E20_miss = 1000*state.lem.energy(3) - S20E_noFB;

% Supply missing energy with FBs
if E20_miss < (sum(state.klys.ENLD(i17)) + sum(state.klys.ENLD(i18)))
    %All energy can be supplied with FB tubes, determine phase accordingly
    FB20_PHAS = acosd(E20_miss/(sum(state.klys.ENLD(i17)) + sum(state.klys.ENLD(i18))));
else
    %All energy cannot be supplied with FB tubes, set FB phase to zero
    FB20_PHAS = 0;    
end
    
%Get new phase vector
LI_11_20_PHAS = state.klys.PHAS(KLYS_11_20_ind) + state.sbst.PHAS(SBST_11_20_ind(KLYS_11_20_ind));

%Insert FB phases
i17 = strncmp('KLYS:LI17', state.klys.name(KLYS_11_20_ind), 9);    % offset 9-1
i18 = strncmp('KLYS:LI18', state.klys.name(KLYS_11_20_ind), 9);    % offset 9-2
LI_11_20_PHAS(i17) = -FB20_PHAS;
LI_11_20_PHAS(i18) = FB20_PHAS;

% Sum energy with FBCK
S20E = sum(state.klys.ENLD(KLYS_11_20_ind).*cos(pi/180*LI_11_20_PHAS))+1000.*state.lem.energy(2);

%LEM
LI_11_20_AMPL = 1000*state.lem.energy(3)/S20E * state.klys.ENLD(KLYS_11_20_ind);
RES20 = 1000*state.lem.energy(3) - sum(LI_11_20_AMPL.*cos(pi/180*LI_11_20_PHAS)) - 1000*state.lem.energy(2);

%Still not there?
if RES20 ~= 0
    LI_11_20_AMPL(i17) = LI_11_20_AMPL(i17) + RES20/length(LI_11_20_AMPL(i17));
end

