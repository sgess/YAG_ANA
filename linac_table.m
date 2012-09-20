%load('/Users/sgess/Desktop/FACET/2012/DATA/July_3/E200_1443/E200_1443_State.mat');
load('/Users/sgess/Desktop/data/E200_DATA/July_3/E200_1467/E200_1467_State.mat');

%%%%%%%%%%%%%%%%%%
% Sector 02 - 10 %
%%%%%%%%%%%%%%%%%%

% Get list of klystrons that are on in sectors 2-10
KLYS_02_10_ind = state.klys.ISON & abs(state.klys.Z) < state.lem.Z(2);
n_klys = sum(KLYS_02_10_ind);

% Assign subbooster index to klystrons in 2-10
[~,SBST_02_10_ind] = histc(state.klys.Z(KLYS_02_10_ind),state.sbst.Z);

% Compute total PHAS and PDES (PHAS = phase readback, PDES = phase setpoint)
LI_02_10_PHAS = state.klys.PHAS(KLYS_02_10_ind) + state.sbst.PHAS(SBST_02_10_ind);
LI_02_10_PDES = state.klys.PDES(KLYS_02_10_ind) + state.sbst.PDES(SBST_02_10_ind);

% Special cases for feedback phase shifters - offset particular phases
i91 = strncmp('KLYS:LI09:11', state.klys.name(KLYS_02_10_ind), 12);    % offset 9-1
i92 = strncmp('KLYS:LI09:21', state.klys.name(KLYS_02_10_ind), 12);    % offset 9-2

% Correct PHAS and PDES in LI09
LI_02_10_PHAS = LI_02_10_PHAS + i91*state.phase.k_9_1 + i92*state.phase.k_9_2;
LI_02_10_PDES = LI_02_10_PDES + i91*state.phase.k_9_1 + i92*state.phase.k_9_2;


% Create Linac Cell array
LI02_LI10_cell = cell(n_klys+1,15);

% Fill in klystron names
LI02_LI10_cell(1,1) = {'KLYS NAME'};
LI02_LI10_cell(2:(n_klys+1),1) = state.klys.name(KLYS_02_10_ind);

% Fill in klystron readback phase
LI02_LI10_cell(1,2) = {'KLYS PHAS'};
LI02_LI10_cell(2:(n_klys+1),2) = num2cell(state.klys.PHAS(KLYS_02_10_ind));

% Fill in klystron readback phase
LI02_LI10_cell(1,3) = {'SBST PHAS'};
LI02_LI10_cell(2:(n_klys+1),3) = num2cell(state.sbst.PHAS(SBST_02_10_ind));

% Add KLYS SUBST PHAS
LI02_LI10_cell(1,4) = {'SUM PHAS'};
LI02_LI10_cell(2:(n_klys+1),4) = num2cell(state.klys.PHAS(KLYS_02_10_ind)+state.sbst.PHAS(SBST_02_10_ind));

% Fill in klystron setpoitnt phase
LI02_LI10_cell(1,5) = {'KLYS PDES'};
LI02_LI10_cell(2:(n_klys+1),5) = num2cell(state.klys.PDES(KLYS_02_10_ind));

% Fill in klystron setpoint phase
LI02_LI10_cell(1,6) = {'SBST PDES'};
LI02_LI10_cell(2:(n_klys+1),6) = num2cell(state.sbst.PDES(SBST_02_10_ind));

% Add KLYS SUBST PDES
LI02_LI10_cell(1,7) = {'SUM PDES'};
LI02_LI10_cell(2:(n_klys+1),7) = num2cell(state.klys.PDES(KLYS_02_10_ind)+state.sbst.PDES(SBST_02_10_ind));

% Feedbacks
LI02_LI10_cell(1,8) = {'FAST FBCK'};
LI02_LI10_cell(2:(n_klys+1),8) = num2cell(i91*state.phase.k_9_1 + i92*state.phase.k_9_2);

% Total readback phase plus fast feedback
LI02_LI10_cell(1,9) = {'FBCK PHAS'};
LI02_LI10_cell(2:(n_klys+1),9) = num2cell(LI_02_10_PHAS);

% Total setpoint phase plus fast feedback
LI02_LI10_cell(1,10) = {'FBCK PDES'};
LI02_LI10_cell(2:(n_klys+1),10) = num2cell(LI_02_10_PDES);

% On crest energy gain (MeV)
LI02_LI10_cell(1,11) = {'KLYS ENLD'};
LI02_LI10_cell(2:(n_klys+1),11) = num2cell(state.klys.ENLD(KLYS_02_10_ind));

% Energy gain using klystron readback phase (MeV)
LI02_LI10_cell(1,12) = {'PHAS EGAIN'};
LI02_LI10_cell(2:(n_klys+1),12) = num2cell(state.klys.ENLD(KLYS_02_10_ind).*cos(pi/180*LI_02_10_PHAS));

% Energy in Linac using klystron readback phase (GeV)
LI02_LI10_cell(1,13) = {'LINAC PHAS E'};
LI02_LI10_cell(2:(n_klys+1),13) = num2cell(cumsum(state.klys.ENLD(KLYS_02_10_ind).*cos(pi/180*LI_02_10_PHAS))/1000 ...
    +state.lem.energy(1));

% Energy gain using klystron readback phase (MeV)
LI02_LI10_cell(1,14) = {'PDES EGAIN'};
LI02_LI10_cell(2:(n_klys+1),14) = num2cell(state.klys.ENLD(KLYS_02_10_ind).*cos(pi/180*LI_02_10_PDES));

% Energy in Linac using klystron setpoint phase (GeV)
LI02_LI10_cell(1,15) = {'LINAC PDES E'};
LI02_LI10_cell(2:(n_klys+1),15) = num2cell(cumsum(state.klys.ENLD(KLYS_02_10_ind).*cos(pi/180*LI_02_10_PDES))/1000 ...
    +state.lem.energy(1));

fname = '/Users/sgess/Desktop/data/E200_DATA/July_3/E200_1467/LI02_LI10_table.txt';
fid = fopen(fname, 'w');
fprintf(fid, '%s \t %s \t %s \t %s \t %s \t %s \t %s \t %s \t %s \t %s \t %s \t %s \t %s \t %s \t %s\n', LI02_LI10_cell{1,:});
for row=2:(n_klys+1)
    fprintf(fid, '%s \t %6.2f \t %6.2f \t %6.2f \t %6.2f \t %6.2f \t %6.2f \t %6.2f \t %6.2f \t %6.2f \t %6.2f \t %6.2f \t %6.2f \t %6.2f \t %6.2f\n', LI02_LI10_cell{row,:});
end
fclose(fid);

%%%%%%%%%%%%%%%%%%
% Sector 11 - 20 %
%%%%%%%%%%%%%%%%%%

% Get list of klystrons that are on in sectors 11-20
KLYS_11_20_ind = state.klys.ISON & state.klys.Z > state.lem.Z(2) & state.klys.Z < state.lem.Z(3);
n_klys = sum(KLYS_11_20_ind);

% Assign subbooster index to klystrons in 11-20
[~,SBST_11_20_ind] = histc(state.klys.Z(KLYS_11_20_ind),state.sbst.Z);

% Compute total PHAS and PDES (PHAS = phase readback, PDES = phase setpoint)
LI_11_20_PHAS = state.klys.PHAS(KLYS_11_20_ind) + state.sbst.PHAS(SBST_11_20_ind);
LI_11_20_PDES = state.klys.PDES(KLYS_11_20_ind) + state.sbst.PDES(SBST_11_20_ind);

% Special cases for feedback phase shifters - offset particular phases
i17 = strncmp('KLYS:LI17', state.klys.name(KLYS_11_20_ind), 9);    % offset 9-1
i18 = strncmp('KLYS:LI18', state.klys.name(KLYS_11_20_ind), 9);    % offset 9-2

% Correct PHAS and PDES in LI09
LI_11_20_PHAS = LI_11_20_PHAS + i17*state.phase.s_17 + i18*state.phase.s_18;
LI_11_20_PDES = LI_11_20_PDES + i17*state.phase.s_17 + i18*state.phase.s_18;


% Create Linac Cell array
LI11_LI20_cell = cell(n_klys+1,15);

% Fill in klystron names
LI11_LI20_cell(1,1) = {'KLYS NAME'};
LI11_LI20_cell(2:(n_klys+1),1) = state.klys.name(KLYS_11_20_ind);

% Fill in klystron readback phase
LI11_LI20_cell(1,2) = {'KLYS PHAS'};
LI11_LI20_cell(2:(n_klys+1),2) = num2cell(state.klys.PHAS(KLYS_11_20_ind));

% Fill in klystron readback phase
LI11_LI20_cell(1,3) = {'SBST PHAS'};
LI11_LI20_cell(2:(n_klys+1),3) = num2cell(state.sbst.PHAS(SBST_11_20_ind));

% Add KLYS SUBST PHAS
LI11_LI20_cell(1,4) = {'SUM PHAS'};
LI11_LI20_cell(2:(n_klys+1),4) = num2cell(state.klys.PHAS(KLYS_11_20_ind)+state.sbst.PHAS(SBST_11_20_ind));

% Fill in klystron setpoitnt phase
LI11_LI20_cell(1,5) = {'KLYS PDES'};
LI11_LI20_cell(2:(n_klys+1),5) = num2cell(state.klys.PDES(KLYS_11_20_ind));

% Fill in klystron setpoint phase
LI11_LI20_cell(1,6) = {'SBST PDES'};
LI11_LI20_cell(2:(n_klys+1),6) = num2cell(state.sbst.PDES(SBST_11_20_ind));

% Add KLYS SUBST PDES
LI11_LI20_cell(1,7) = {'SUM PDES'};
LI11_LI20_cell(2:(n_klys+1),7) = num2cell(state.klys.PDES(KLYS_11_20_ind)+state.sbst.PDES(SBST_11_20_ind));

% Feedbacks
LI11_LI20_cell(1,8) = {'FAST FBCK'};
LI11_LI20_cell(2:(n_klys+1),8) = num2cell(i17*state.phase.s_17 + i18*state.phase.s_18);

% Total readback phase plus fast feedback
LI11_LI20_cell(1,9) = {'FBCK PHAS'};
LI11_LI20_cell(2:(n_klys+1),9) = num2cell(LI_11_20_PHAS);

% Total setpoint phase plus fast feedback
LI11_LI20_cell(1,10) = {'FBCK PDES'};
LI11_LI20_cell(2:(n_klys+1),10) = num2cell(LI_11_20_PDES);

% On crest energy gain (MeV)
LI11_LI20_cell(1,11) = {'KLYS ENLD'};
LI11_LI20_cell(2:(n_klys+1),11) = num2cell(state.klys.ENLD(KLYS_11_20_ind));

% Energy gain using klystron readback phase (MeV)
LI11_LI20_cell(1,12) = {'PHAS EGAIN'};
LI11_LI20_cell(2:(n_klys+1),12) = num2cell(state.klys.ENLD(KLYS_11_20_ind).*cos(pi/180*LI_11_20_PHAS));

% Energy in Linac using klystron readback phase (GeV)
LI11_LI20_cell(1,13) = {'LINAC PHAS E'};
LI11_LI20_cell(2:(n_klys+1),13) = num2cell(cumsum(state.klys.ENLD(KLYS_11_20_ind).*cos(pi/180*LI_11_20_PHAS))/1000 ...
    +state.lem.energy(2));

% Energy gain using klystron readback phase (MeV)
LI11_LI20_cell(1,14) = {'PDES EGAIN'};
LI11_LI20_cell(2:(n_klys+1),14) = num2cell(state.klys.ENLD(KLYS_11_20_ind).*cos(pi/180*LI_11_20_PDES));

% Energy in Linac using klystron setpoint phase (GeV)
LI11_LI20_cell(1,15) = {'LINAC PDES E'};
LI11_LI20_cell(2:(n_klys+1),15) = num2cell(cumsum(state.klys.ENLD(KLYS_11_20_ind).*cos(pi/180*LI_11_20_PDES))/1000 ...
    +state.lem.energy(2));

fname = '/Users/sgess/Desktop/data/E200_DATA/July_3/E200_1467/LI11_LI20_table.txt';
fid = fopen(fname, 'w');
fprintf(fid, '%s \t %s \t %s \t %s \t %s \t %s \t %s \t %s \t %s \t %s \t %s \t %s \t %s \t %s \t %s\n', LI11_LI20_cell{1,:});
for row=2:(n_klys+1)
    fprintf(fid, '%s \t %6.2f \t %6.2f \t %6.2f \t %6.2f \t %6.2f \t %6.2f \t %6.2f \t %6.2f \t %6.2f \t %6.2f \t %6.2f \t %6.2f \t %6.2f \t %6.2f\n', LI11_LI20_cell{row,:});
end
fclose(fid);