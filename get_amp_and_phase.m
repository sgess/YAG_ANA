function MACH = get_amp_and_phase(num,plot_phase,plot_eProf,plot_sect)
% [AMPL, PHAS] = get_amp_and_phase() retrieves kylstron amplitude and phase
% information with calculated feedback phases and LEM fudge factors

%state_file = ['/Users/sgess/Desktop/data/E200_DATA/E200_' num2str(num) '/E200_' num2str(num) '_State.mat'];
state_file = ['/Users/sgess/Desktop/FACET/2012/DATA/E200_' num2str(num) '/E200_' num2str(num) '_State.mat'];
% Load machine state data
load(state_file);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Split machine into parts, determine firing and FB klystrons
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Split machine into sectors, determine average sector values
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plot Phase
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(plot_phase)
    
    DIFF = LINAC_TDES(IND_ALL_noFB)-LINAC_PACT(IND_ALL_noFB);
    Ylabel = 'Phase Error (degrees)';
    Title = 'Phase error for triggered, non-feedback klystrons';
    file = 'phas_err';
    phase_bar(DIFF,LINAC_KLYZ,SBST_IND,IND_ALL_noFB,Ylabel,Title,file,num);
    
    pHAS = LINAC_PACT(IND_ALL_noFB);
    Ylabel = 'Phase Readback (degrees)';
    Title = 'Phase Readback for triggered, non-feedback klystrons';
    file = 'phas_pact';
    phase_bar(pHAS,LINAC_KLYZ,SBST_IND,IND_ALL_noFB,Ylabel,Title,file,num);
    
    pDES = LINAC_TDES(IND_ALL_noFB);
    Ylabel = 'Phase Setpoint (degrees)';
    Title = 'Phase Setpoint for triggered, non-feedback klystrons';
    file = 'phas_pdes';
    phase_bar(pDES,LINAC_KLYZ,SBST_IND,IND_ALL_noFB,Ylabel,Title,file,num);
    
    pACT = LINAC_PACT(LINAC_ISON);
    Ylabel = 'Phase Readback (degrees)';
    Title = 'Phase Readback for all triggered klystrons';
    file = 'phas_pactWFB';
    phase_bar(pACT,LINAC_KLYZ,SBST_IND,LINAC_ISON,Ylabel,Title,file,num);
    
    pTOT = LINAC_PTOT(LINAC_ISON);
    Ylabel = 'Calculate phase (degrees)';
    Title = 'Calculated phase for all triggered klystrons';
    file = 'phas_ptot';
    phase_bar(pTOT,LINAC_KLYZ,SBST_IND,LINAC_ISON,Ylabel,Title,file,num);
    
    pERR = LINAC_PTOT(LINAC_ISON)-LINAC_PACT(LINAC_ISON);
    Ylabel = 'Calculate phase error(degrees)';
    Title = 'Calculated phase error for all triggered klystrons';
    file = 'phas_cerr';
    phase_bar(pERR,LINAC_KLYZ,SBST_IND,LINAC_ISON,Ylabel,Title,file,num);
  
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plot Energy
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(plot_eProf)
    
    % No FB, No LEM
    NOFB_Z = LINAC_KLYZ(IND_02_10_noFB | IND_11_20_noFB);
    NOFB = [S10E_noFB; S20E_noFB]/1000;
    % w/FB, No LEM
    NOLEM_Z = LINAC_KLYZ(LINAC_ISON);
    NOLEM = cumsum(LINAC_ENLD(LINAC_ISON).*cosd(LINAC_PACT(LINAC_ISON)))/1000+state.lem.energy(1);
    % w/FB & LEM
    FUDG_Z = LINAC_KLYZ(LINAC_ISON);
    LI10 = state.lem.fudge(1)*cumsum(LINAC_ENLD(IND_02_10_wFB).*cosd(LINAC_PACT(IND_02_10_wFB)))/1000 + state.lem.energy(1);
    LI20 = state.lem.fudge(2)*cumsum(LINAC_ENLD(IND_11_20_wFB).*cosd(LINAC_PACT(IND_11_20_wFB)))/1000 + LI10(end);
    FUDG = [LI10; LI20];
    
    % My FB, No LEM
    WFB_Z = LINAC_KLYZ(IND_02_10_wFB | IND_11_20_wFB);
    WFB = [S10E; S20E]/1000;
    % My FB & LEM
    LEM_Z = LINAC_KLYZ(LINAC_ISON);
    LEM = cumsum(LINAC_LEM(LINAC_ISON).*cosd(LINAC_PTOT(LINAC_ISON)))/1000+state.lem.energy(1);
    
    % Plotting everything
    z = linspace(0,2000);
    e1 = 1.19*ones(1,100);
    e2 = 9*ones(1,100);
    e3 = 20.35*ones(1,100);
    set(0,'defaultlinelinewidth',2);
    plot(NOFB_Z,NOFB,NOLEM_Z,NOLEM,FUDG_Z,FUDG,WFB_Z,WFB,LEM_Z,LEM,z,e1,'--',z,e2,'--',z,e3,'--');
    line([LINAC_KLYZ(71) LINAC_KLYZ(71)],[0,21],'LineStyle','--');
    text(1000,8,'Sector 10 Chicane','Fontsize',16);
    axis([0 1950 0 21]);
    l = legend('NO FBCK KLYS','W FBCK KLYS from getMachine','W FBCK KLYS and LEM from getMachine',...
        'Calc FBCK PHAS','Calc FBCK PHAS and LEM','1.19 GeV','9 GeV','20.35 GeV','Location','Northwest');
    set(l,'fontsize',16);
    
    % Plotting only pretty stuff
    figure;
    plot(NOLEM_Z,NOLEM,FUDG_Z,FUDG,LEM_Z,LEM,z,e1,'--c',z,e2,'--m',z,e3,'--y');
    line([LINAC_KLYZ(71) LINAC_KLYZ(71)],[0,21],'LineStyle','--');
    text(1000,8,'Sector 10 Chicane','Fontsize',16);
    axis([0 1950 0 21]);
    l = legend('Machine Profile, no LEM','Machine Profile, with LEM','Profile for my FBCK PHAS and LEM',...
        '1.19 GeV','9 GeV','20.35 GeV','Location','Northwest');
    set(l,'fontsize',13);
    xlabel('Z (meters)','Fontsize',16);
    ylabel('Energy (GeV)','Fontsize',16);
    title(['Recovered energy profile for E200\_' num2str(num)],'Fontsize',16);
    saveas(gca,['/Users/sgess/Desktop/plots/E200/E200_' num2str(num) '/eProf.pdf']);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plot Sector
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(plot_sect)

    bar_h = bar(state.sbst.Z(1:18),SECT_PHAS,'barwidth',1);
    bar_child=get(bar_h,'Children');
    set(bar_child, 'CData',1:18);
    xlabel('Z (meters)','fontsize',16);
    ylabel('Phase (degrees)','fontsize',16);
    title(['Sector Averaged Phase for E200\_' num2str(num)],'fontsize',16);
    saveas(gca,['/Users/sgess/Desktop/plots/E200/E200_' num2str(num) '/sect_phase.pdf']);
    
    e = cumsum(SECT_LEM.*cosd(SECT_PHAS))/1000+state.lem.energy(1);
    z = linspace(0,2000);
    e1 = 1.19*ones(1,100);
    e2 = 9*ones(1,100);
    e3 = 20.35*ones(1,100);
    LEM = cumsum(LINAC_LEM.*LINAC_ISON.*cosd(LINAC_PTOT))/1000+state.lem.energy(1);
    plot(LINAC_KLYZ,LEM,':',state.sbst.Z(1:18)+86.4108,e,'s',z,e1,'--c',z,e2,'--m',z,e3,'--y');
    line([LINAC_KLYZ(71) LINAC_KLYZ(71)],[0,21],'LineStyle','--');
    text(1000,8,'Sector 10 Chicane','Fontsize',16);
    axis([0 1950 0 21]);
    xlabel('Z (meters)','fontsize',16);
    ylabel('Energy (GeV)','fontsize',16);
    title(['Sector Averaged energy profile for E200\_' num2str(num)],'fontsize',16);
    l = legend('Energy Profile, All Klystrons','Energy Profile, By Sector',...
        '1.19 GeV','9 GeV','20.35 GeV','Location','Northwest');
    set(l,'fontsize',13);
    saveas(gca,['/Users/sgess/Desktop/plots/E200/E200_' num2str(num) '/sect_eProf.pdf']);
end

MACH.KLYS.AMPL = LINAC_LEM.*LINAC_ISON/1000.;
MACH.KLYS.PHAS = LINAC_PTOT.*LINAC_ISON;
MACH.KLYS.LEFF = LINAC_LEFF;
MACH.KLYS.Z    = LINAC_KLYZ;
MACH.SECT.AMPL = SECT_LEM/1000;
MACH.SECT.PHAS = SECT_PHAS;
MACH.SECT.LEFF = SECT_LEFF;
MACH.SECT.Z    = state.sbst.Z;