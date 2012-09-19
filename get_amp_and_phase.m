%Load machine state data
load('/Users/sgess/Desktop/data/E200_DATA/July_3/E200_1443_State.mat');

%Get list of used klystrons for sectors 2-10
KLYS_02_10_ind = state.klys.ISON & abs(state.klys.Z) < state.lem.Z(2);

%Get list of used klystrons for sectors 11-20
KLYS_11_20_ind = state.klys.ISON & abs(state.klys.Z) > state.lem.Z(2);

%Assign SBST index to klystrons in 2-10
[~,SBST_02_10_ind] = histc(state.klys.Z(KLYS_02_10_ind),state.sbst.Z);

%Assign SBST index to klystrons in 11-20
[~,SBST_11_20_ind] = histc(state.klys.Z(KLYS_11_20_ind),state.sbst.Z);