clear all;

%mac69
%data_dir = '/Users/sgess/Desktop/FACET/2012/DATA/MR_TCAV_1499/';
%data_dir = '/Users/sgess/Desktop/FACET/2012/DATA/MR_TCAV_1500/';
%data_dir = '/Users/sgess/Desktop/FACET/2012/DATA/MR_TCAV_1501/';

%data_dir = '/Users/sgess/Desktop/data/E200_DATA/MR_TCAV_1499/';
%data_dir = '/Users/sgess/Desktop/data/E200_DATA/MR_TCAV_1500/';
data_dir = '/Users/sgess/Desktop/data/E200_DATA/MR_TCAV_1501/';

%disp_dir = '/Users/sgess/Desktop/FACET/2012/DATA/MR_TCAV_DISP/';

%save_dir = '/Users/sgess/Desktop/FACET/PLOTS/MR_TCAV_1499/';
%save_dir = '/Users/sgess/Desktop/FACET/PLOTS/MR_TCAV_1500/';
%save_dir = '/Users/sgess/Desktop/FACET/PLOTS/MR_TCAV_1501/';
%save_dir = '/Users/sgess/Desktop/FACET/PLOTS/MR_TCAV_DISP/BEFORE/';
%save_dir = '/Users/sgess/Desktop/FACET/PLOTS/MR_TCAV_DISP/AFTER/';
%save_dir = '/Users/sgess/Desktop/plots/E200/MR_TCAV_1500/';
save_dir = '/Users/sgess/Desktop/plots/E200/MR_TCAV_1501/';


disp_dir = '/Users/sgess/Desktop/data/E200_DATA/MR_TCAV_DISP/';
%dsave_dir = '/Users/sgess/Desktop/plots/E200/MR_TCAV_DISP/BEFORE/';
%dsave_dir = '/Users/sgess/Desktop/plots/E200/MR_TCAV_DISP/AFTER/';

disp_before  = 'facet_dispersion-SCAVENGY.MKB-2012-07-03-182257.mat';
%disp_after  = 'facet_dispersion-SCAVENGY.MKB-2012-07-04-092455.mat';

%slim_name = 'MR_TCAV_1499_slim.mat';
%slim_name = 'MR_TCAV_1500_slim.mat';
slim_name = 'MR_TCAV_1501_slim.mat';

%state_name = 'MR_TCAV_sampling_1499_state.mat';
%state_name = 'MR_TCAV_sampling_1500_state.mat';
%state_name = 'MR_TCAV_sampling_1501_state.mat';

tcav_dir = '/Users/sgess/Desktop/data/E200_DATA/TCAV_DATA/';

tcav_name = 'derp.mat';

load([data_dir slim_name]);
%load([data_dir state_name]);
load([tcav_dir tcav_name]);
%load([disp_dir disp_before]);

%parse derp
ind_1499 = 1;
ind_1500 = 36;
ind_1501 = 72;
total_shots = length(pulse);

pid_1499 = [];
pid_1500 = [];
pid_1501 = [];

for i = 1:total_shots
    
    if i < ind_1500
        pid_1499 = [pid_1499 pulse(i).pulseid];
        ind_1499 = [ind_1499 i];
    elseif i >= ind_1501
        pid_1501 = [pid_1501 pulse(i).pulseid];
        ind_1501 = [ind_1501 i];
    else
        pid_1500 = [pid_1500 pulse(i).pulseid];
        ind_1500 = [ind_1500 i];
    end
    
end

do_disp = 0;
do_y = 0;
plot_disp = 0;
savE = 0;

do_state = 0;
plot_mach = 0;

extract = 1;
view_yag = 0;
too_wide = 0;

plot_nrtl_phas = 0;

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
    title('NRTL Compressor Phase for MR\_TCAV\_1501','fontsize',14);
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
    plot(pulse(72).yprof,'r','linewidth',2);
    hold on; plot(pulse(73).yprof,'b','linewidth',2);
    plot(pulse(80).yprof,'g','linewidth',2);
    plot(pulse(89).yprof,'c','linewidth',2);
    plot(pulse(90).yprof,'m','linewidth',2);
    xlabel('Z (\mum)','fontsize',14);
    legend('PID 64810','PID 65170','PID 67690','PID 74170','PID 74530');
    title('Bunch Profiles','fontsize',14);
    hold off
end


nrtl_phas = [];
yag_fwhm = [];
y_mean = [];
for i=1:length(DATA.NRTL.PHAS)
    
    if DATA.NRTL.PHAS(i) < 88; continue; end;
    
    ind = find(pid_1501 == DATA.PID.AIDA(i));
    if isempty(ind); continue; end;
    
    nrtl_phas = [nrtl_phas DATA.NRTL.PHAS(i)];
    yag_fwhm = [yag_fwhm DATA.YAG.FWHM(i)];
    y_mean = [y_mean pulse(ind_1501(ind)).ymean];
    
end

figure(4);
plot(nrtl_phas,yag_fwhm,'*');
xlabel('Compressor Phase','fontsize',14);
ylabel('YAG FWHM','fontsize',14);

figure(5);
plot(nrtl_phas,y_mean,'*');
xlabel('Compressor Phase','fontsize',14);
ylabel('USTHz Y Mean','fontsize',14);