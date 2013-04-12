clear all;

%mcme
data_dir = {'/Users/sgess/Desktop/FACET/2012/DATA/FULL_PYRO/E200_1103/';...
            '/Users/sgess/Desktop/FACET/2012/DATA/FULL_PYRO/E200_1104/';...
            '/Users/sgess/Desktop/FACET/2012/DATA/FULL_PYRO/E200_1105/';...
            '/Users/sgess/Desktop/FACET/2012/DATA/FULL_PYRO/E200_1106/';...
            '/Users/sgess/Desktop/FACET/2012/DATA/FULL_PYRO/E200_1107/';};
        
        
% data_dir = {'/Users/sgess/Desktop/FACET/2012/DATA/HALF_PYRO/E200_1108/';...
%             '/Users/sgess/Desktop/FACET/2012/DATA/HALF_PYRO/E200_1109/';...
%             '/Users/sgess/Desktop/FACET/2012/DATA/HALF_PYRO/E200_1110/';...
%             '/Users/sgess/Desktop/FACET/2012/DATA/HALF_PYRO/E200_1111/';...
%             '/Users/sgess/Desktop/FACET/2012/DATA/HALF_PYRO/E200_1112/';};
        
save_dir = '/Users/sgess/Desktop/FACET/PLOTS/E200_1103/';
%save_dir = '/Users/sgess/Desktop/FACET/PLOTS/E200_1108/';
%sim_dir = '/Users/sgess/Desktop/data/LiTrack_scans/';

%arg
% data_dir = '/Users/sgess/Desktop/data/E200_DATA/E200_1108/';
% save_dir = '/Users/sgess/Desktop/plots/E200/E200_1108/';
% sim_dir = '/Users/sgess/Desktop/data/LiTrack_scans/';

save_name  = '1103_retry.mat';
%save_name  = '1108_retry.mat';


slim_name  = {'E200_1103_Slim.mat';...
              'E200_1104_Slim.mat';...
              'E200_1105_Slim.mat';...
              'E200_1106_Slim.mat';...
              'E200_1107_Slim.mat';};

% slim_name  = {'E200_1108_Slim.mat';...
%               'E200_1109_Slim.mat';...
%               'E200_1110_Slim.mat';...
%               'E200_1111_Slim.mat';...
%               'E200_1112_Slim.mat';};
          
state_name = 'E200_1103_State.mat';
%state_name = 'E200_1108_State.mat';

disp_dir = '/Users/sgess/Desktop/FACET/2012/DATA/FULL_PYRO/dispersion/';
%disp_dir = '/Users/sgess/Desktop/FACET/2012/DATA/HALF_PYRO/dispersion/';

disp_name  = 'facet_dispersion-SCAVENGY.MKB-2012-06-30-054158.mat';

%1108
%save_name  = '1108_retry.mat';
%sim_name   = 'E200_1108_scan.mat';
%interp_name= 'E200_1108_interp95.mat';
%slim_name  = 'E200_1108_Slim.mat';
%state_name = 'E200_1108_State.mat';
%disp_dir = '/Users/sgess/Desktop/data/E200_DATA/E200_1108/'; 
%disp_name  = 'facet_dispersion-SCAVENGY.MKB-2012-06-30-054158.mat';
%disp_name  = 'facet_dispersion-SCAVENGY.MKB-2012-07-01-043249.mat';
%disp_name  = 'facet_dispersion-SCAVENGY.MKB-2012-07-01-105028.mat';


load([data_dir{1} state_name]);
load([disp_dir disp_name]);

do_disp = 1;
do_y = 1;
plot_disp = 0;
extract = 1;
view_yag = 0;
interp = 1;
compare = 1;
do_plot = 0;
savE = 0;
too_wide = 1;

if do_disp
    disp('Analyzing dispersion data. . .');
    [eta_yag, beam_size] = disp_ana(data,plot_disp,do_y,savE,save_dir);
    disp(['Eta = ' num2str(eta_yag,'%.2f')]);
    disp('Dispersion analyis complete.');
end

%YAG lineout lines
lo_line = 175;
hi_line = 200;

bad_pix = [638 639];
spec = 646;
if extract
    disp('Extracting data. . .');
    for i=1:length(data_dir)
    load([data_dir{i} slim_name{i}]);
    nShots = length(good_data);
    DATA(i) = extract_data(good_data,eta_yag,beam_size,lo_line,hi_line,bad_pix,nShots,view_yag,too_wide,spec);
    clear('good_data');
    end
    disp('Data extraction complete.');
end

% if interp
%     disp('Interpolating simulations. . .');
%     %INTERP = interp_sim(DATA.YAG.PIX,DATA.AXIS.ENG,beam_size,eta_yag,[sim_dir sim_name]);
%     %INTERP = interp_5D(DATA.YAG.MAXPIX,DATA.AXIS.ENG,beam_size,eta_yag,[sim_dir sim_name]);
%     %INTERP = interp_5D(DATA.YAG.pix,DATA.AXIS.eng,beam_size,eta_yag,[sim_dir sim_name]);
%     INTERP = interp_4D(DATA.YAG.pix,DATA.AXIS.eng,beam_size,eta_yag,[sim_dir sim_name]);
%     if savE; save([sim_dir interp_name],'INTERP'); end;
%     disp('Simulation interpolation complete.');
% else
%     disp('Loading interpolations. . .');
%     load([sim_dir interp_name]);
%     disp('Interpolations loaded.');
% end
% 
% if compare
%     disp('Calculating residuals. . .');
%     %RES = compare_data(DATA,INTERP,nShots,do_plot);
%     %RES = compare_5D(DATA,INTERP,nShots);
%     RES = compare_4D(DATA,INTERP,nShots);
%     if savE; save([save_dir save_name],'RES'); end; 
%     disp('Residual calculation complete.');
% end