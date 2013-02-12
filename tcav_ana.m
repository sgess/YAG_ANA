clear all;

%mac69
%data_dir = '/Users/sgess/Desktop/FACET/2012/DATA/MR_TCAV_1499/';
%data_dir = '/Users/sgess/Desktop/FACET/2012/DATA/MR_TCAV_1500/';
data_dir = '/Users/sgess/Desktop/FACET/2012/DATA/MR_TCAV_1501/';

disp_dir = '/Users/sgess/Desktop/FACET/2012/DATA/DISP/';

save_dir = '/Users/sgess/Desktop/FACET/PLOTS/MR_TCAV_1499/';
%save_dir = '/Users/sgess/Desktop/FACET/PLOTS/MR_TCAV_1500/';
%save_dir = '/Users/sgess/Desktop/FACET/PLOTS/MR_TCAV_1501/';

disp_before  = 'facet_dispersion-SCAVENGY.MKB-2012-07-03-182257.mat';
disp_after  = 'facet_dispersion-SCAVENGY.MKB-2012-07-04-092455.mat';

load([data_dir slim_name]);
load([data_dir state_name]);
load([data_dir disp_name]);

do_disp = 1;
do_y = 1;
plot_disp = 1;
extract = 0;
view_yag = 0;
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
