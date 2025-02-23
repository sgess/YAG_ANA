clear all;

%arg
%data_dir = '/Users/sgess/Desktop/data/E200_DATA/E200_1443/';
%data_dir = '/Users/sgess/Desktop/data/E200_DATA/E200_1138/';
%data_dir = '/Users/sgess/Desktop/data/E200_DATA/E200_1103/';
%data_dir = '/Users/sgess/Desktop/data/E200_DATA/E200_1108/';

%save_dir = '/Users/sgess/Desktop/plots/E200/E200_1443/';
%save_dir = '/Users/sgess/Desktop/plots/E200/E200_1138/';
%save_dir = '/Users/sgess/Desktop/plots/E200/E200_1103/';
%save_dir = '/Users/sgess/Desktop/plots/E200/E200_1108/';

%sim_dir = '/Users/sgess/Desktop/data/LiTrack_scans/';

%mac69
%data_dir = '/Users/sgess/Desktop/FACET/2012/DATA/E200_1443/';
%data_dir = '/Users/sgess/Desktop/FACET/2012/DATA/E200_1138/';
%data_dir = '/Users/sgess/Desktop/FACET/2012/DATA/E200_1103/';
data_dir = '/Users/sgess/Desktop/FACET/2012/DATA/HALF_PYRO/E200_1108/';


%save_dir = '/Users/sgess/Desktop/FACET/PLOTS/E200_1443/';
%save_dir = '/Users/sgess/Desktop/FACET/PLOTS/E200_1138/';
%save_dir = '/Users/sgess/Desktop/FACET/PLOTS/E200_1103/';
save_dir = '/Users/sgess/Desktop/FACET/PLOTS/HALF_PYRO/E200_1108/';


%sim_dir = '/Users/sgess/Desktop/FACET/2012/DATA/LiTrackScans/E200_1103/';
%sim_dir = '/Users/sgess/Desktop/FACET/2012/DATA/LiTrackScans/E200_1108/';

%1443
%save_name  = 'NRTL_struct.mat';
%sim_name   = 'NRTL_scan.mat';
%slim_name  = 'E200_1443_slim.mat';
%state_name = 'E200_1443_State.mat';
%disp_name  = 'facet_dispersion-SCAVENGY.MKB-2012-07-03-094452.mat';

%1138
% save_name  = '1138_test.mat';
% sim_name   = '5mm_scan.mat';
% slim_name  = 'E200_1138_Slim.mat';
% state_name = 'E200_1138_State.mat';
% disp_name  = 'facet_dispersion-SCAVENGY.MKB-2012-07-01-043249.mat';

%1103
% save_name  = '1103_95yag.mat';
% sim_name   = 'E200_1103_scan2.mat';
% interp_name= 'E200_1103_interp2.mat';
% slim_name  = 'E200_1103_Slim.mat';
% state_name = 'E200_1103_State.mat';
% disp_name  = 'facet_dispersion-SCAVENGY.MKB-2012-06-30-054158.mat';

%1108
save_name  = '1108_eta95.mat';
sim_name   = 'E200_1108_scan.mat';
interp_name= 'E200_1108_interp95.mat';
slim_name  = 'E200_1108_Slim.mat';
state_name = 'E200_1108_State.mat';
disp_dir = '/Users/sgess/Desktop/FACET/2012/DATA/HALF_PYRO/dispersion/'; 
disp_name  = 'facet_dispersion-SCAVENGY.MKB-2012-06-30-054158.mat';
%disp_name  = 'facet_dispersion-SCAVENGY.MKB-2012-07-01-043249.mat';
%disp_name  = 'facet_dispersion-SCAVENGY.MKB-2012-07-01-105028.mat';

load([data_dir slim_name]);
load([data_dir state_name]);
load([disp_dir disp_name]);

do_disp = 1;
do_y = 0;
plot_disp = 0;
extract = 1;
view_yag = 1;
interp = 0;
compare = 0;
do_plot = 0;
savE = 0;

if do_disp
    disp('Analyzing dispersion data. . .');
    [eta_yag, beam_size] = DISP_ANA(data,plot_disp,do_y,savE,save_dir);
    disp(['Eta = ' num2str(eta_yag,'%.2f')]);
    disp('Dispersion analyis complete.');
end

eta_yag = 1.00*eta_yag;

%number of shots
nShots = length(good_data);

%YAG lineout lines
lo_line = 175;
hi_line = 200;

bad_pix = [638 639];

if extract
    disp('Extracting data. . .');
    DATA = extract_data(good_data,eta_yag,beam_size,lo_line,hi_line,bad_pix,nShots,view_yag);
    clear('good_data');
    disp('Data extraction complete.');
end

if interp
    disp('Interpolating simulations. . .');
    %INTERP = interp_sim(DATA.YAG.PIX,DATA.AXIS.ENG,beam_size,eta_yag,[sim_dir sim_name]);
    %INTERP = interp_5D(DATA.YAG.MAXPIX,DATA.AXIS.ENG,beam_size,eta_yag,[sim_dir sim_name]);
    %INTERP = interp_5D(DATA.YAG.pix,DATA.AXIS.eng,beam_size,eta_yag,[sim_dir sim_name]);
    INTERP = interp_4D(DATA.YAG.pix,DATA.AXIS.eng,beam_size,eta_yag,[sim_dir sim_name]);
    if savE; save([sim_dir interp_name],'INTERP'); end;
    disp('Simulation interpolation complete.');
else
    disp('Loading interpolations. . .');
    load([sim_dir interp_name]);
    disp('Interpolations loaded.');
end

if compare
    disp('Calculating residuals. . .');
    %RES = compare_data(DATA,INTERP,nShots,do_plot);
    %RES = compare_5D(DATA,INTERP,nShots);
    RES = compare_4D(DATA,INTERP,nShots);
    if savE; save([save_dir save_name],'RES'); end; 
    disp('Residual calculation complete.');
end
