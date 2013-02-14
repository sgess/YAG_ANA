clear all;

data_1499 = '/Users/sgess/Desktop/data/E200_DATA/MR_TCAV_1499/';
data_1500 = '/Users/sgess/Desktop/data/E200_DATA/MR_TCAV_1500/';
data_1501 = '/Users/sgess/Desktop/data/E200_DATA/MR_TCAV_1501/';

slim_1499 = 'MR_TCAV_1499_slim.mat';
slim_1500 = 'MR_TCAV_1500_slim.mat';
slim_1501 = 'MR_TCAV_1501_slim.mat';


tcav_dir = '/Users/sgess/Desktop/data/E200_DATA/TCAV_DATA/';
tcav_name = 'derp.mat';

%beam size bs
eta_yag = 111.83;
beta_yag = 4.496536;
emit = 100e-6;
gamma = 20.35/(0.510998928e-3);
beam_size = 1000*sqrt(beta_yag*emit/gamma);

%YAG lineout lines
lo_line = 100;
hi_line = 125;
bad_pix = [];
view_yag = 0;
too_wide = 0;

d_1499 = load([data_1499 slim_1499]);
nShots = length(d_1499.good_data);
DATA_1499 = extract_data(d_1499.good_data,eta_yag,beam_size,lo_line,hi_line,bad_pix,nShots,view_yag,too_wide);
clear('d_1499');

d_1500 = load([data_1500 slim_1500]);
nShots = length(d_1500.good_data);
DATA_1500 = extract_data(d_1500.good_data,eta_yag,beam_size,lo_line,hi_line,bad_pix,nShots,view_yag,too_wide);
clear('d_1500');

d_1501 = load([data_1501 slim_1501]);
nShots = length(d_1501.good_data);
DATA_1501 = extract_data(d_1501.good_data,eta_yag,beam_size,lo_line,hi_line,bad_pix,nShots,view_yag,too_wide);
clear('d_1501');

nrtl_phas = [DATA_1499.NRTL.PHAS DATA_1500.NRTL.PHAS DATA_1501.NRTL.PHAS];
yag_pid = [DATA_1499.PID.PROF DATA_1500.PID.PROF DATA_1501.PID.PROF];
aida_pid = [DATA_1499.PID.AIDA DATA_1500.PID.AIDA DATA_1501.PID.AIDA];
yag_fwhm = [DATA_1499.YAG.FWHM DATA_1500.YAG.FWHM DATA_1501.YAG.FWHM];

load([tcav_dir tcav_name]);

for i = 1:106
    
    filename{i} = pulse(i).filename;
    pulseid(i) = pulse(i).pulseid;
    kick(i) = pulse(i).kick;
    ymean(i) = pulse(i).ymean;
    tcav_on(i) = pulse(i).tcav_on;
    
end