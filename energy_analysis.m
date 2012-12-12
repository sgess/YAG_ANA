clear all;

%arg
data_dir = '/Users/sgess/Desktop/data/E200_DATA/E200_1443/';
%data_dir = '/Users/sgess/Desktop/data/E200_DATA/E200_1138/';

save_dir = '/Users/sgess/Desktop/plots/E200/E200_1443/';
%save_dir = '/Users/sgess/Desktop/plots/E200/E200_1138/';

sim_dir = '/Users/sgess/Desktop/data/LiTrack_scans/';

%mac69
%data_dir = '/Users/sgess/Desktop/FACET/2012/DATA/E200_1443/';
%data_dir = '/Users/sgess/Desktop/FACET/2012/DATA/E200_1138/';

%save_dir = '/Users/sgess/Desktop/FACET/PLOTS/E200_1443/';
%save_dir = '/Users/sgess/Desktop/FACET/PLOTS/E200_1138/';

%sim_dir = '/Users/sgess/Desktop/FACET/2012/DATA/LiTrackScans/';

%1443
save_name  = 'NRTL_1.mat';
sim_name   = 'NRTL_scan.mat';
slim_name  = 'E200_1443_slim.mat';
state_name = 'E200_1443_State.mat';
disp_name  = 'facet_dispersion-SCAVENGY.MKB-2012-07-03-094452.mat';

%1138
% save_name  = '1138_test.mat';
% sim_name   = '5mm_scan.mat';
% slim_name  = 'E200_1138_Slim.mat';
% state_name = 'E200_1138_State.mat';
% disp_name  = 'facet_dispersion-SCAVENGY.MKB-2012-07-01-043249.mat';

load([data_dir slim_name]);
load([data_dir state_name]);
load([data_dir disp_name]);

do_disp = 1;
do_y = 0;
plot_disp = 0;
extract = 1;
view_yag = 0;
do_plot = 0;
compare = 0;
savE = 0;

if do_disp
    [eta_yag, beam_size] = DISP_ANA(data,plot_disp,do_y,savE,save_dir);
end

%number of shots
nShots = length(good_data);

%YAG lineout lines
lo_line = 150;
hi_line = 175;

if extract
    DATA = extract_data(good_data,eta_yag,beam_size,lo_line,hi_line,nShots,view_yag);
end

if compare

    load([sim_dir sim_name]);
    
    
    
    if savE; save([data_dir save_name],'RES','CON','e_interp','conterp','DCON','ENG_AX','center','LINESUM'); end;

end