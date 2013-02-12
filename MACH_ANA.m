function MACH = MACH_ANA(state,plot_mach,savE,save_dir)

% TMIT ANA
tmit = state.bpms.TMIT(1:238);
stat = state.bpms.STAT(1:238);
stat(isnan(stat)) = 0;
stat = logical(stat);

MACH.TMIT.MEAN = mean(tmit(stat));
MACH.TMIT.MEDIAN = median(tmit(stat));

if plot_mach
    hist(tmit(stat),30);
    xlabel('Bunch Charge','fontsize',14);
    title('BPM TMITs, Whole Linac','fontsize',14);
    if savE; saveas(gca,[save_dir 'TMIT_hist.pdf']); end;
end



% KLYS ANA
% Remove bad klys
i20 = strncmp('KLYS:LI20', state.klys.name, 9);
i81 = strncmp('KLYS:LI10:81', state.klys.name, 12);
nope = ~(i81 + i20);

% Get KLYS lists
KLYS_NAME = state.klys.name(nope);
KLYS_ISON = state.klys.ISON(nope);
KLYS_PHAS = state.klys.PHAS(nope);
KLYS_PDES = state.klys.PDES(nope);
KLYS_PACT = state.klys.PACT(nope);
KLYS_ENLD = state.klys.ENLD(nope);
KLYS_LEFF = state.klys.LEFF(nope);
KLYS_ZPOS = state.klys.Z(nope);

% Assign subbooster index to klystrons
[~,SBST_IND] = histc(KLYS_ZPOS,state.sbst.Z);

% Calculate totle PHAS and PDE
KLYS_TPHS = KLYS_PHAS + state.sbst.PHAS(SBST_IND);
KLYS_TPDS = KLYS_PDES + state.sbst.PDES(SBST_IND);

% Get list of klystrons that are in sectors 2-10
KLYS_02_10 = KLYS_ZPOS < state.lem.Z(2);
% Get list of klystrons that are in sectors 11-20
KLYS_11_20 = KLYS_ZPOS > state.lem.Z(2);

% Get FB KLYS list
i91 = strncmp('KLYS:LI09:11', KLYS_NAME, 12);    % offset 9-1
i92 = strncmp('KLYS:LI09:21', KLYS_NAME, 12);    % offset 9-2
i17 = strncmp('KLYS:LI17', KLYS_NAME, 9);        % offset S17
i18 = strncmp('KLYS:LI18', KLYS_NAME, 9);        % offset S18

% List of non FB klystrons that are on
IND_02_10_noFB = KLYS_ISON & KLYS_02_10 & ~i91 & ~i92;
IND_11_20_noFB = KLYS_ISON & KLYS_11_20 & ~i17 & ~i18;

% Compute 2-10 PACT energy gain, chirp, and angle 
PACT_EADD = KLYS_ENLD(IND_02_10_noFB).*cosd(KLYS_PACT(IND_02_10_noFB));
PACT_CHRP = KLYS_ENLD(IND_02_10_noFB).*sind(KLYS_PACT(IND_02_10_noFB));
pact_gain = sum(PACT_EADD/1000);
pact_chrp = -sum(PACT_CHRP/1000);
pact_deck = atand(-sum(PACT_CHRP/1000)/sum(PACT_EADD/1000));
pact_hard = atand(-sum(PACT_CHRP/1000)/7.81);

% Compute 2-10 PHAS energy gain, chirp, and angle 
PHAS_EADD = KLYS_ENLD(IND_02_10_noFB).*cosd(KLYS_TPHS(IND_02_10_noFB));
PHAS_CHRP = KLYS_ENLD(IND_02_10_noFB).*sind(KLYS_TPHS(IND_02_10_noFB));
phas_gain = sum(PHAS_EADD/1000);
phas_chrp = -sum(PHAS_CHRP/1000);
phas_deck = atand(-sum(PHAS_CHRP/1000)/sum(PHAS_EADD/1000));
phas_hard = atand(-sum(PHAS_CHRP/1000)/7.81);

% Compute 2-10 PDES energy gain, chirp, and angle 
PDES_EADD = KLYS_ENLD(IND_02_10_noFB).*cosd(KLYS_TPDS(IND_02_10_noFB));
PDES_CHRP = KLYS_ENLD(IND_02_10_noFB).*sind(KLYS_TPDS(IND_02_10_noFB));
pdes_gain = sum(PDES_EADD/1000);
pdes_chrp = -sum(PDES_CHRP/1000);
pdes_deck = atand(-sum(PDES_CHRP/1000)/sum(PDES_EADD/1000));
pdes_hard = atand(-sum(PDES_CHRP/1000)/7.81);

MACH.CHRP.PACT = pact_chrp;
MACH.CHRP.PDES = pdes_chrp;



