clear all;

%mac69
%data_dir = '/Users/sgess/Desktop/FACET/2012/DATA/MR_TCAV_1499/';
%data_dir = '/Users/sgess/Desktop/FACET/2012/DATA/MR_TCAV_1500/';
data_dir = '/Users/sgess/Desktop/FACET/2012/DATA/MR_TCAV_1501/';

disp_dir = '/Users/sgess/Desktop/FACET/2012/DATA/MR_TCAV_DISP/';

%save_dir = '/Users/sgess/Desktop/FACET/PLOTS/MR_TCAV_1499/';
%save_dir = '/Users/sgess/Desktop/FACET/PLOTS/MR_TCAV_1500/';
save_dir = '/Users/sgess/Desktop/FACET/PLOTS/MR_TCAV_1501/';
%save_dir = '/Users/sgess/Desktop/FACET/PLOTS/MR_TCAV_DISP/BEFORE/';
%save_dir = '/Users/sgess/Desktop/FACET/PLOTS/MR_TCAV_DISP/AFTER/';

%disp_dir = '/Users/sgess/Desktop/data/E200_DATA/MR_TCAV_DISP/';
%dsave_dir = '/Users/sgess/Desktop/plots/E200/MR_TCAV_DISP/BEFORE/';
%dsave_dir = '/Users/sgess/Desktop/plots/E200/MR_TCAV_DISP/AFTER/';

disp_before  = 'facet_dispersion-SCAVENGY.MKB-2012-07-03-182257.mat';
%disp_after  = 'facet_dispersion-SCAVENGY.MKB-2012-07-04-092455.mat';

%slim_name = 'MR_TCAV_sampling_1499_slim.mat';
%slim_name = 'MR_TCAV_sampling_1500_slim.mat';
slim_name = 'MR_TCAV_sampling_1501_slim.mat';

%state_name = 'MR_TCAV_sampling_1499_state.mat';
%state_name = 'MR_TCAV_sampling_1500_state.mat';
state_name = 'MR_TCAV_sampling_1501_state.mat';

tcav_name = 'derp.mat';

load([data_dir slim_name]);
load([data_dir state_name]);
load(['/Users/sgess/Desktop/FACET/2012/DATA/MR_TCAV_1499/' tcav_name]);
%load([disp_dir disp_before]);

do_disp = 0;
do_y = 0;
plot_disp = 0;
savE = 0;

do_state = 1;
plot_mach = 1;

extract = 1;
view_yag = 0;
too_wide = 0;

plot_nrtl_phas = 1;
if do_disp
    disp('Analyzing dispersion data. . .');
    [eta_yag, beam_size] = DISP_ANA(data,plot_disp,do_y,savE,dsave_dir);
    disp(['Eta = ' num2str(eta_yag,'%.2f')]);
    disp('Dispersion analyis complete.');
else
    eta_yag = 111.83;
    beta_yag = 4.496536;
    emit = 100e-6;
    gamma = 20.35/(0.510998928e-3);
    beam_size = 1000*sqrt(beta_yag*emit/gamma);
end

if do_state
    disp('Analyzing machine state. . .');
    MACH = MACH_ANA(state,plot_mach,savE,save_dir);
    disp('State analysis complete.');
end

eta_yag = 1.00*eta_yag;

%number of shots
nShots = length(good_data);

%YAG lineout lines
lo_line = 100;
hi_line = 125;

bad_pix = [];

if extract
    disp('Extracting data. . .');
    DATA = extract_data(good_data,eta_yag,beam_size,lo_line,hi_line,bad_pix,nShots,view_yag,too_wide);
    clear('good_data');
    disp('Data extraction complete.');
end

if plot_nrtl_phas
    figure(1);
    plot(DATA.NRTL.PHAS,'b*');
    xlabel('Shot Number','fontsize',14);
    ylabel('Compressor Phase (deg)','fontsize',14);
    title('NRTL Compressor Phase for MR\_TCAV\_1500','fontsize',14);
    text(3, 85, 'Pulse ID 64810');
    text(4, 87.0, 'Pulse ID 65170');
    text(11, 87.0, 'Pulse ID 67690');  
    text(20, 52, 'Pulse ID 74170');  
    text(21, 85.2, 'Pulse ID 74530');  
    
    figure(2);
    plot(DATA.AXIS.XX/1000,DATA.YAG.SPECTRUM(:,2),'r',DATA.AXIS.XX/1000,DATA.YAG.SPECTRUM(:,3),'b',DATA.AXIS.XX/1000,DATA.YAG.SPECTRUM(:,10),'g',DATA.AXIS.XX/1000,DATA.YAG.SPECTRUM(:,19),'c',DATA.AXIS.XX/1000,DATA.YAG.SPECTRUM(:,20),'m','linewidth',2);
    xlabel('X (mm)','fontsize',14);
    title('YAG Spectra','fontsize',14);
    legend('PID 64810','PID 65170','PID 67690','PID 74170','PID 74530');
    
    figure(3);
    plot(pulse(72).z,'r','linewidth',2);
    hold on; plot(pulse(73).z,'b','linewidth',2);
    plot(pulse(80).z,'g','linewidth',2);
    plot(pulse(89).z,'c','linewidth',2);
    plot(pulse(90).z,'m','linewidth',2);
    xlabel('Z (\mum)','fontsize',14);
    legend('PID 64810','PID 65170','PID 67690','PID 74170','PID 74530');
    title('Bunch Profiles','fontsize',14);
end
