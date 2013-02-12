clear all;

%mac69
%data_dir = '/Users/sgess/Desktop/FACET/2012/DATA/MR_TCAV_1499/';
%data_dir = '/Users/sgess/Desktop/FACET/2012/DATA/MR_TCAV_1500/';
%data_dir = '/Users/sgess/Desktop/FACET/2012/DATA/MR_TCAV_1501/';

%disp_dir = '/Users/sgess/Desktop/FACET/2012/DATA/DISP/';

%save_dir = '/Users/sgess/Desktop/FACET/PLOTS/MR_TCAV_1499/';
%save_dir = '/Users/sgess/Desktop/FACET/PLOTS/MR_TCAV_1500/';
%save_dir = '/Users/sgess/Desktop/FACET/PLOTS/MR_TCAV_1501/';

disp_dir = '/Users/sgess/Desktop/data/E200_DATA/MR_TCAV_DISP/';
%save_dir = '/Users/sgess/Desktop/plots/E200/MR_TCAV_DISP/BEFORE/';
save_dir = '/Users/sgess/Desktop/plots/E200/MR_TCAV_DISP/AFTER/';

disp_before  = 'facet_dispersion-SCAVENGY.MKB-2012-07-03-182257.mat';
disp_after  = 'facet_dispersion-SCAVENGY.MKB-2012-07-04-092455.mat';

%load([data_dir slim_name]);
%load([data_dir state_name]);
load([disp_dir disp_after]);

do_disp = 1;
do_y = 1;
plot_disp = 1;
savE = 0;

if do_disp
    disp('Analyzing dispersion data. . .');
    [eta_yag, beam_size] = DISP_ANA(data,plot_disp,do_y,savE,save_dir);
    disp(['Eta = ' num2str(eta_yag,'%.2f')]);
    disp('Dispersion analyis complete.');
end