%clear all;

plot_nrtl_phas = 1;
savE = 1;

data_1499 = '/Users/sgess/Desktop/data/E200_DATA/MR_TCAV_1499/';
data_1500 = '/Users/sgess/Desktop/data/E200_DATA/MR_TCAV_1500/';
data_1501 = '/Users/sgess/Desktop/data/E200_DATA/MR_TCAV_1501/';

slim_1499 = 'MR_TCAV_1499_slim.mat';
slim_1500 = 'MR_TCAV_1500_slim.mat';
slim_1501 = 'MR_TCAV_1501_slim.mat';


tcav_dir = '/Users/sgess/Desktop/data/E200_DATA/TCAV_DATA/';
tcav_name = 'derp.mat';

save_dir = '/Users/sgess/Desktop/plots/E200/MR_TCAV_1501/';

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
view_yag = 1;
too_wide = 0;

if ~exist('DATA_1499')
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
end

nrtl_phas = [DATA_1499.NRTL.PHAS DATA_1500.NRTL.PHAS DATA_1501.NRTL.PHAS];

yag_pid = [DATA_1499.PID.PROF DATA_1500.PID.PROF DATA_1501.PID.PROF];
aida_pid = [DATA_1499.PID.AIDA DATA_1500.PID.AIDA DATA_1501.PID.AIDA];

yag_fwhm = [DATA_1499.YAG.FWHM DATA_1500.YAG.FWHM DATA_1501.YAG.FWHM];
yag_spec = [DATA_1499.YAG.SPECTRUM DATA_1500.YAG.SPECTRUM DATA_1501.YAG.SPECTRUM];

pyro_data = [DATA_1499.PYRO.VAL DATA_1500.PYRO.VAL DATA_1501.PYRO.VAL];

bpm_2050_x = [DATA_1499.BPM_2050.X DATA_1500.BPM_2050.X DATA_1501.BPM_2050.X];
bpm_2050_y = [DATA_1499.BPM_2050.Y DATA_1500.BPM_2050.Y DATA_1501.BPM_2050.Y];

bpm_2445_x = [DATA_1499.BPM_2445.X DATA_1500.BPM_2445.X DATA_1501.BPM_2445.X];
bpm_2445_y = [DATA_1499.BPM_2445.Y DATA_1500.BPM_2445.Y DATA_1501.BPM_2445.Y];

load([tcav_dir tcav_name]);

for i = 1:106
    
    filename{i} = pulse(i).filename;
    pulseid(i) = pulse(i).pulseid;
    kick(i) = pulse(i).kick;
    ymean(i) = pulse(i).ymean;
    tcav_on(i) = pulse(i).tcav_on;
    yrms10(i) = pulse(i).yrms10;
    
end

if plot_nrtl_phas
    
    figure(1);
    plot(nrtl_phas,'*');
    title('NRTL Compressor Phase','fontsize',14);
    xlabel('Shot Number','fontsize',14);
    ylabel('Phase (deg)','fontsize',14);
    text(70,77,['Median Phase = ' num2str(median(nrtl_phas(nrtl_phas > 80)),'%0.3f')],'fontsize',14);
    text(70,75,['Mean Phase = ' num2str(mean(nrtl_phas(nrtl_phas > 80)),'%0.3f')],'fontsize',14);
    text(70,73,['Phase RMS = ' num2str(std(nrtl_phas(nrtl_phas > 80)),'%0.3f')],'fontsize',14);
    if savE; saveas(gca,[save_dir 'nrtl_phase.pdf']); end;
    
    figure(2);
    ind = yag_fwhm/median(yag_fwhm) < .83;
    ind2 = nrtl_phas > 80;
    plot(yag_fwhm(ind),nrtl_phas(ind),'b*',yag_fwhm(~ind & ind2),nrtl_phas(~ind & ind2),'r*');
    xlabel('YAG FWHM','fontsize',14);
    ylabel('NRTL Compressor Phase','fontsize',14);
    title('NRTL Phase/YAG Spectrum Correlation','fontsize',14);
    line([0.02 0.05],[median(nrtl_phas) median(nrtl_phas)],'color','k');
    l = legend('Bad Shots','Good Shots','Median Phase','location','southwest');
    set(l,'fontsize',14);
    if savE; saveas(gca,[save_dir 'phase_and_yag.pdf']); end;
    
    figure(3);
    plot(yag_fwhm(ind),pyro_data(ind)/14.4,'b*',yag_fwhm(~ind),pyro_data(~ind)/14.4,'r*')
    xlabel('YAG FWHM','fontsize',14);
    ylabel('Pyro','fontsize',14);
    title('Pyro/YAG Spectrum Correlation','fontsize',14);
    l = legend('Bad Shots','Good Shots','location','southwest');
    set(l,'fontsize',14);
    if savE; saveas(gca,[save_dir 'pyro_and_yag.pdf']); end;
end

