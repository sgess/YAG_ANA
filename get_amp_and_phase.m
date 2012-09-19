% Load machine state data
%load('/Users/sgess/Desktop/data/E200_DATA/July_3/E200_1443_State.mat');
load('/Users/sgess/Desktop/FACET/2012/DATA/July_3/E200_1443/E200_1443_State.mat');

% Get list of klystrons that are on in sectors 2-10
KLYS_02_10_ind = state.klys.ISON & abs(state.klys.Z) < state.lem.Z(2);

% Assign subbooster index to klystrons in 2-10
[~,SBST_02_10_ind] = histc(state.klys.Z(KLYS_02_10_ind),state.sbst.Z);

% Compute total PHAS and PDES (PHAS = phase readback, PDES = phase setpoint)
LI_02_10_PHAS = state.klys.PHAS(KLYS_02_10_ind) + state.sbst.PHAS(SBST_02_10_ind);
LI_02_10_PDES = state.klys.PDES(KLYS_02_10_ind) + state.sbst.PDES(SBST_02_10_ind);

% Special cases for feedback phase shifters - offset particular phases
i91 = strncmp('KLYS:LI09:11', state.klys.name(KLYS_02_10_ind), 12);    % offset 9-1
i92 = strncmp('KLYS:LI09:21', state.klys.name(KLYS_02_10_ind), 12);    % offset 9-2

% Correct PHAS in LI09
LI_02_10_PHAS(i91) = LI_02_10_PHAS(i91) + state.phase.k_9_1;
LI_02_10_PHAS(i92) = LI_02_10_PHAS(i92) + state.phase.k_9_2;

% Correct PDES in LI09
LI_02_10_PDES(i91) = LI_02_10_PDES(i91) + state.phase.k_9_1;
LI_02_10_PDES(i92) = LI_02_10_PDES(i92) + state.phase.k_9_2;

% LEM check sum
sum(state.klys.ENLD(KLYS_02_10_ind).*cos(pi/180*LI_02_10_PHAS))+1000*state.lem.energy(1)
sum(state.klys.ENLD(KLYS_02_10_ind).*cos(pi/180*LI_02_10_PDES))*state.lem.fudge(1)+1000*state.lem.energy(1)


% Get list of klystrons that are on in sectors 11-20
%KLYS_11_20_ind = state.klys.ISON & abs(state.klys.Z) > state.lem.Z(2);

% Assign SBST index to klystrons in 11-20
%[~,SBST_11_20_ind] = histc(state.klys.Z(KLYS_11_20_ind),state.sbst.Z);
