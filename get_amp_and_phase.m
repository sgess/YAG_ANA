function MACH = get_amp_and_phase(state, plot_tmits, plot_phase, plot_eProf, plot_sects, save_dir, savE)
% MACH = get_amp_and_phase() retrieves kylstron amplitude and phase
% information with calculated feedback phases and LEM fudge factors
% Some may ask, why is this script so long and unnecessarily complicated?
% Because the Linac is one giant exception to the rule. That's why.


if nargin == 1
    plot_tmits = 0;
    plot_phase = 0;
    plot_eProf = 0;
    plot_sects = 0;
    
    savE = 0;
    save_dir = '';
    
elseif nargin ~= 7
    error('Need to specify only "STATE" or all plotting and saving inputs');
end

j = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% QUICK TMIT ANALYSIS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get BPM TMITs and STATS
tmit = state.bpms.TMIT(1:238);
stat = state.bpms.STAT(1:238);
stat(isnan(stat)) = 0;
stat = logical(stat);

MACH.TMIT.MEAN = mean(tmit(stat));
MACH.TMIT.MEDIAN = median(tmit(stat));

if plot_tmits
    figure(j);
    j = j + 1;
    hist(tmit(stat),30);
    xlabel('Bunch Charge','fontsize',14);
    title('BPM TMITs, Whole Linac','fontsize',14);
    if savE; saveas(gca,[save_dir '/TMIT_hist.pdf']); end;
end





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Split machine into parts, determine firing and FB klystrons
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Remove LI20 Klystrons which are somehow in the list
i20 = strncmp('KLYS:LI20', state.klys.name, 9);

% Remove KLYS:LI10:81 which has been replaced by S10 chicken
i81 = strncmp('KLYS:LI10:81', state.klys.name, 12);

% 'nope' are useless klystrons
nope = ~(i81 + i20);

% Get LI02-LI19 klystrons
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
IND_02_10      = LINAC_ISON & KLYS_02_10;
IND_11_20      = LINAC_ISON & KLYS_11_20;
IND_02_10_noFB = LINAC_ISON & KLYS_02_10 & ~i91 & ~i92;
IND_11_20_noFB = LINAC_ISON & KLYS_11_20 & ~i17 & ~i18;
IND_ALL_noFB   = LINAC_ISON & ~i91 & ~i92 & ~i17 & ~i18;

% Set LI09 FB Phases
LINAC_PHAS(i91) = state.phase.k_9_1;
LINAC_PHAS(i92) = state.phase.k_9_2;






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Split machine into sectors, determine average sector values
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Assign subbooster index to klystrons
[~,SBST_IND] = histc(LINAC_KLYZ,state.sbst.Z);

% Subooster set and readback phases
SECT_PDES = state.sbst.PDES;
SECT_PHAS = state.sbst.PHAS;

% Set LI07 to zero (sector off)
SECT_PDES(6) = 0;
SECT_PHAS(6) = 0;

% Set LI08 to zero (sector off)
SECT_PDES(7) = 0;
SECT_PHAS(7) = 0;

% Set LI20 to zero (sector off)
SECT_PDES(19) = 0;
SECT_PHAS(19) = 0;

% Set LI17 and LI18 FB phases
SECT_PDES(16) = state.phase.s_17;
SECT_PHAS(16) = state.phase.s_17;
SECT_PDES(17) = state.phase.s_18;
SECT_PHAS(17) = state.phase.s_18;

% Assign sbst phases to klys
LINAC_SDES = SECT_PDES(SBST_IND);
LINAC_SPHS = SECT_PHAS(SBST_IND);

% Get total PDES phas
LINAC_TDES = LINAC_PDES + LINAC_SDES;
LINAC_KACT = LINAC_PHAS + LINAC_SPHS;

if ~isequal(LINAC_KACT(IND_ALL_noFB),LINAC_PACT(IND_ALL_noFB))
    warning('BAD KLYSTRON PHASES');
end

% Get total cavity length per sector
SECT_LEFF = zeros(18,1);
SECT_ENLD = zeros(18,1);
SECT_KACT = zeros(18,1);
for i=1:18
    SECT_LEFF(i) = sum(LINAC_LEFF(SBST_IND==i));
    SECT_ENLD(i) = sum(LINAC_ENLD(SBST_IND==i & LINAC_ISON));
    SECT_KACT(i) = mean(LINAC_KACT(SBST_IND==i & LINAC_ISON));
end
% Add KLYS:LI11:31 length
SECT_LEFF(10) = SECT_LEFF(10) + 6.7180;
% Set LI07 and LI08 to zero (sector off)
SECT_KACT(6) = 0;
SECT_KACT(7) = 0;









%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Apply LEM to klystrons
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Sum energy without FBCK
S10E_noFB = cumsum(LINAC_ENLD(IND_02_10_noFB).*cosd(LINAC_PACT(IND_02_10_noFB)))+1000.*state.lem.energy(1);
S20E_noFB = cumsum(LINAC_ENLD(IND_11_20_noFB).*cosd(LINAC_PACT(IND_11_20_noFB)))+1000.*state.lem.energy(2);
E_noFB = [S10E_noFB; S20E_noFB]/1000;

% Sum energy without LEM
S10E_noLEM = cumsum(LINAC_ENLD(IND_02_10).*cosd(LINAC_KACT(IND_02_10)))+1000.*state.lem.energy(1);
S20E_noLEM = cumsum(LINAC_ENLD(IND_11_20).*cosd(LINAC_KACT(IND_11_20)))+1000.*state.lem.energy(2);
E_noLEM = [S10E_noLEM; S20E_noLEM]/1000;

% Missing energy to be adjusted by LEM
E10_miss = 1000*state.lem.energy(2) - S10E_noLEM(end);
E20_miss = 1000*state.lem.energy(3) - S20E_noLEM(end);
E10_fudge = 1000*state.lem.energy(2)/S10E_noLEM(end);
E20_fudge = 1000*state.lem.energy(3)/S20E_noLEM(end);

% Add a little bit to each klystron according to phase
S10ADD = E10_miss/sum(IND_02_10)./cosd(LINAC_KACT(IND_02_10));
S20ADD = E20_miss/sum(IND_11_20)./cosd(LINAC_KACT(IND_11_20));
LINAC_LEM = LINAC_ENLD;
LINAC_LEM(IND_02_10) = LINAC_ENLD(IND_02_10) + S10ADD;
LINAC_LEM(IND_11_20) = LINAC_ENLD(IND_11_20) + S20ADD;

% Final energy profile
E_S10 = cumsum(LINAC_LEM(IND_02_10).*cosd(LINAC_KACT(IND_02_10)))+1000.*state.lem.energy(1);
C_S10 = cumsum(LINAC_LEM(IND_02_10).*sind(LINAC_KACT(IND_02_10)));
E_S20 = cumsum(LINAC_LEM(IND_11_20).*cosd(LINAC_KACT(IND_11_20)))+1000.*state.lem.energy(2);
C_S20 = cumsum(LINAC_LEM(IND_11_20).*sind(LINAC_KACT(IND_11_20)));
E = [E_S10; E_S20]/1000;
C = [C_S10; C_S20]/1000;

CHIRP_ENG = C_S10(end)/1000;
CHIRP_PHA = atand(CHIRP_ENG/(state.lem.energy(2) - state.lem.energy(1)));






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Apply LEM to sectors
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

e_check = sum(SECT_ENLD.*cosd(SECT_PHAS(1:18)))/1000+state.lem.energy(1);
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

% Final energy profile
ESB_S10 = cumsum(SECT_LEM(1:9).*cosd(SECT_PHAS(1:9)))+1000.*state.lem.energy(1);
CSB_S10 = cumsum(SECT_LEM(1:9).*sind(SECT_PHAS(1:9)));
ESB_S20 = cumsum(SECT_LEM(10:18).*cosd(SECT_PHAS(10:18)))+1000.*state.lem.energy(2);
CSB_S20 = cumsum(SECT_LEM(10:18).*sind(SECT_PHAS(10:18)));
ESB = [ESB_S10; ESB_S20]/1000;
CSB = [CSB_S10; CSB_S20]/1000;








%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plot Phase
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(plot_phase)
    
    % Phase bars, no fb
    figure(j);
    j = j + 1;
    
    pHAS = LINAC_KACT(IND_ALL_noFB);
    Ylabel = 'Phase Readback (degrees)';
    Title = 'Phase Readback for triggered, non-feedback klystrons';
    file = 'phas_nofb';
    phase_bar(pHAS,LINAC_KLYZ,SBST_IND,IND_ALL_noFB,Ylabel,Title,file,save_dir,savE);
    
    % Phase bars, with fb
    figure(j);
    j = j + 1;
    
    pHAS = LINAC_KACT(LINAC_ISON);
    Ylabel = 'Phase Readback (degrees)';
    Title = 'Phase Readback for all triggered klystrons';
    file = 'phas_wfb';
    phase_bar(pHAS,LINAC_KLYZ,SBST_IND,LINAC_ISON,Ylabel,Title,file,save_dir,savE);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plot Energy
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(plot_eProf)

    % Energy profile
    figure(j);
    j = j + 1;
    
    z = linspace(0,2000);
    e1 = 1.19*ones(1,100);
    e2 = 9*ones(1,100);
    e3 = 20.35*ones(1,100);
    set(0,'defaultlinelinewidth',2);
    
    plot(LINAC_KLYZ(IND_ALL_noFB),E_noFB,LINAC_KLYZ(LINAC_ISON),E_noLEM,LINAC_KLYZ(LINAC_ISON),E,z,e1,'--c',z,e2,'--m',z,e3,'--y');
    line([LINAC_KLYZ(71) LINAC_KLYZ(71)],[0,21],'LineStyle','--');
    text(1000,8,'Sector 10 Chicane','Fontsize',16);
    axis([0 1950 0 21]);
    l = legend('No Feedback','With Feedback, No LEM','With Feedback and LEM',...
        '1.19 GeV','9 GeV','20.35 GeV','Location','Northwest');
    set(l,'fontsize',13);
    xlabel('Z (meters)','Fontsize',16);
    ylabel('Energy (GeV)','Fontsize',16);
    title('Energy profile','Fontsize',16);
    if savE; saveas(gca,[save_dir '/eProf.pdf']); end;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plot Sector
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(plot_sects)

    %Sector phase bars
    figure(j);
    j = j + 1;
    
    bar_h = bar(state.sbst.Z(1:18),SECT_PHAS(1:18),'barwidth',1);
    bar_child=get(bar_h,'Children');
    set(bar_child, 'CData',1:18);
    xlabel('Z (meters)','fontsize',16);
    ylabel('Phase (degrees)','fontsize',16);
    title('Sector Averaged Phase','fontsize',16);
    if savE; saveas(gca,[save_dir '/sect_phase.pdf']); end;
    
    
    %Sector energy profile
    figure(j);
    j = j + 1;
    
    z = linspace(0,2000);
    e1 = 1.19*ones(1,100);
    e2 = 9*ones(1,100);
    e3 = 20.35*ones(1,100);
    
    plot(LINAC_KLYZ(LINAC_ISON),E,':',state.sbst.Z(1:18)+86.4108,ESB,'s',z,e1,'--c',z,e2,'--m',z,e3,'--y');
    line([LINAC_KLYZ(71) LINAC_KLYZ(71)],[0,21],'LineStyle','--');
    text(1000,8,'Sector 10 Chicane','Fontsize',16);
    axis([0 1950 0 21]);
    xlabel('Z (meters)','fontsize',16);
    ylabel('Energy (GeV)','fontsize',16);
    title('Sector Averaged energy profile','fontsize',16);
    l = legend('Energy Profile, All Klystrons','Energy Profile, By Sector',...
        '1.19 GeV','9 GeV','20.35 GeV','Location','Northwest');
    set(l,'fontsize',13);
    if savE; saveas(gca,[save_dir '/sect_eProf.pdf']); end;
    
    
    %Sector phase arrow
    figure(j);
    j = j + 1;
    clf;
    sectarrow(SECT_LEM(1:9)/1000,SECT_PHAS(1:9),CHIRP_ENG,CHIRP_PHA,state.lem.energy(2)-state.lem.energy(1),save_dir,savE);
    
    
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Return Important Info
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

MACH.LEM.E0    = state.lem.energy(1);
MACH.LEM.E1    = state.lem.energy(2);
MACH.LEM.E2    = state.lem.energy(3);
MACH.LEM.Fudge_1 = E10_fudge;
MACH.LEM.Fudge_2 = E20_fudge;

MACH.CHRP.E    = CHIRP_ENG;
MACH.CHRP.P    = CHIRP_PHA;

MACH.KLYS.KACT = LINAC_KACT.*LINAC_ISON;
MACH.KLYS.LEFF = LINAC_LEFF;
MACH.KLYS.Z    = LINAC_KLYZ;
MACH.KLYS.ENLD = LINAC_ENLD;
MACH.KLYS.LEM  = LINAC_LEM.*LINAC_ISON/1000;  % good enld

MACH.SECT.ENLD = SECT_ENLD;
MACH.SECT.AMPL = SECT_LEM/1000;
MACH.SECT.PHAS = SECT_PHAS;
MACH.SECT.LEFF = SECT_LEFF;
MACH.SECT.Z    = state.sbst.Z;