state_1051 = load('/Users/sgess/Desktop/FACET/2012/DATA/FULL_PYRO/EXTRA_STATES/E200_1051_State.mat');
state_1068 = load('/Users/sgess/Desktop/FACET/2012/DATA/FULL_PYRO/EXTRA_STATES/QS_scan_1068_State.mat');
state_1084 = load('/Users/sgess/Desktop/FACET/2012/DATA/FULL_PYRO/EXTRA_STATES/MR_TCAV_Phase_scan_1084_State.mat');
state_1096 = load('/Users/sgess/Desktop/FACET/2012/DATA/FULL_PYRO/EXTRA_STATES/E200_1096_State.mat');
state_1102 = load('/Users/sgess/Desktop/FACET/2012/DATA/FULL_PYRO/E200_1102/E200_1102_State.mat');
state_1103 = load('/Users/sgess/Desktop/FACET/2012/DATA/FULL_PYRO/E200_1103/E200_1103_State.mat');
state_1104 = load('/Users/sgess/Desktop/FACET/2012/DATA/FULL_PYRO/E200_1104/E200_1104_State.mat');
state_1105 = load('/Users/sgess/Desktop/FACET/2012/DATA/FULL_PYRO/E200_1105/E200_1105_State.mat');
state_1106 = load('/Users/sgess/Desktop/FACET/2012/DATA/FULL_PYRO/E200_1106/E200_1106_State.mat');
state_1107 = load('/Users/sgess/Desktop/FACET/2012/DATA/FULL_PYRO/E200_1107/E200_1107_State.mat');

date_1051 = datestr(state_1051.state.timestamp.start);
date_1068 = datestr(state_1068.state.timestamp.start);
date_1084 = datestr(state_1084.state.timestamp.start);
date_1096 = datestr(state_1096.state.timestamp.start);
date_1102 = datestr(state_1102.state.timestamp.start);
date_1103 = datestr(state_1103.state.timestamp.start);
date_1104 = datestr(state_1104.state.timestamp.start);
date_1105 = datestr(state_1105.state.timestamp.start);
date_1106 = datestr(state_1106.state.timestamp.start);
date_1107 = datestr(state_1107.state.timestamp.start);

save_dir_1051 = '/Users/sgess/Desktop/FACET/PLOTS/FULL_PYRO/STATES/E200_1051';
save_dir_1068 = '/Users/sgess/Desktop/FACET/PLOTS/FULL_PYRO/STATES/QS_scan_1068';
save_dir_1084 = '/Users/sgess/Desktop/FACET/PLOTS/FULL_PYRO/STATES/MR_TCAV_Phase_scan_1084';
save_dir_1096 = '/Users/sgess/Desktop/FACET/PLOTS/FULL_PYRO/STATES/E200_1096';
save_dir_1102 = '/Users/sgess/Desktop/FACET/PLOTS/FULL_PYRO/STATES/E200_1102';
save_dir_1103 = '/Users/sgess/Desktop/FACET/PLOTS/FULL_PYRO/STATES/E200_1103';
save_dir_1104 = '/Users/sgess/Desktop/FACET/PLOTS/FULL_PYRO/STATES/E200_1104';
save_dir_1105 = '/Users/sgess/Desktop/FACET/PLOTS/FULL_PYRO/STATES/E200_1105';
save_dir_1106 = '/Users/sgess/Desktop/FACET/PLOTS/FULL_PYRO/STATES/E200_1106';
save_dir_1107 = '/Users/sgess/Desktop/FACET/PLOTS/FULL_PYRO/STATES/E200_1107';

plot_tmit = 1;
plot_phas = 1;
plot_ePro = 1;
plot_sect = 1;

savE = 1;

MACH_1051 = get_amp_and_phase(state_1051.state,plot_tmit,plot_phas,plot_ePro,plot_sect,save_dir_1051,savE);
MACH_1068 = get_amp_and_phase(state_1068.state,plot_tmit,plot_phas,plot_ePro,plot_sect,save_dir_1068,savE);
MACH_1084 = get_amp_and_phase(state_1084.state,plot_tmit,plot_phas,plot_ePro,plot_sect,save_dir_1084,savE);
MACH_1096 = get_amp_and_phase(state_1096.state,plot_tmit,plot_phas,plot_ePro,plot_sect,save_dir_1096,savE);
MACH_1102 = get_amp_and_phase(state_1102.state,plot_tmit,plot_phas,plot_ePro,plot_sect,save_dir_1102,savE);
MACH_1103 = get_amp_and_phase(state_1103.state,plot_tmit,plot_phas,plot_ePro,plot_sect,save_dir_1103,savE);
MACH_1104 = get_amp_and_phase(state_1104.state,plot_tmit,plot_phas,plot_ePro,plot_sect,save_dir_1104,savE);
MACH_1105 = get_amp_and_phase(state_1105.state,plot_tmit,plot_phas,plot_ePro,plot_sect,save_dir_1105,savE);
MACH_1106 = get_amp_and_phase(state_1106.state,plot_tmit,plot_phas,plot_ePro,plot_sect,save_dir_1106,savE);
MACH_1107 = get_amp_and_phase(state_1107.state,plot_tmit,plot_phas,plot_ePro,plot_sect,save_dir_1107,savE);
