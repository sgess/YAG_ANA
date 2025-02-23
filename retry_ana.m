clear all;

full = 0;
half = 0;
seba = 1;

%mcme
if full
data_dir = {'/Users/sgess/Desktop/FACET/2012/DATA/FULL_PYRO/E200_1103/';...
            '/Users/sgess/Desktop/FACET/2012/DATA/FULL_PYRO/E200_1104/';...
            '/Users/sgess/Desktop/FACET/2012/DATA/FULL_PYRO/E200_1105/';...
            '/Users/sgess/Desktop/FACET/2012/DATA/FULL_PYRO/E200_1106/';...
            '/Users/sgess/Desktop/FACET/2012/DATA/FULL_PYRO/E200_1107/';};
end        
   
if half
data_dir = {'/Users/sgess/Desktop/FACET/2012/DATA/HALF_PYRO/E200_1108/';...
            '/Users/sgess/Desktop/FACET/2012/DATA/HALF_PYRO/E200_1109/';...
            '/Users/sgess/Desktop/FACET/2012/DATA/HALF_PYRO/E200_1110/';...
            '/Users/sgess/Desktop/FACET/2012/DATA/HALF_PYRO/E200_1111/';...
            '/Users/sgess/Desktop/FACET/2012/DATA/HALF_PYRO/E200_1112/';};
end

if seba
    data_dir = '/Users/sgess/Desktop/FACET/2012/DATA/JULY_2_DATA/';
end

if full; save_dir = '/Users/sgess/Desktop/FACET/PLOTS/E200_1103/'; end;
if half; save_dir = '/Users/sgess/Desktop/FACET/PLOTS/E200_1108/'; end;
if seba; save_dir = '/Users/sgess/Desktop/FACET/PLOTS/JULY_2_DATA/'; end;


%sim_dir = '/Users/sgess/Desktop/data/LiTrack_scans/';

%arg
% data_dir = '/Users/sgess/Desktop/data/E200_DATA/E200_1108/';
% save_dir = '/Users/sgess/Desktop/plots/E200/E200_1108/';
% sim_dir = '/Users/sgess/Desktop/data/LiTrack_scans/';

if full; save_name  = '1103.mat'; end;
if half; save_name  = '1108.mat'; end;
if seba; save_name  = 'July2.mat'; end;


if full
slim_name  = {'E200_1103_Slim.mat';...
              'E200_1104_Slim.mat';...
              'E200_1105_Slim.mat';...
              'E200_1106_Slim.mat';...
              'E200_1107_Slim.mat';};
end

if half
slim_name  = {'E200_1108_Slim.mat';...
              'E200_1109_Slim.mat';...
              'E200_1110_Slim.mat';...
              'E200_1111_Slim.mat';...
              'E200_1112_Slim.mat';};
end
if seba
slim_name  = {'E200_1324_Slim.mat';...
              'E200_1325_Slim.mat';...
              'E200_1326_Slim.mat';...
              'E200_1327_Slim.mat';...
              'E200_1328_Slim.mat';...
              'E200_1330_Slim.mat';...
              'E200_1335_Slim.mat';};
end
           
if full; state_name = 'E200_1103_State.mat'; end;
if half; state_name = 'E200_1108_State.mat'; end;
if seba; state_name = 'E200_1324_State.mat'; end;


if full; disp_dir = '/Users/sgess/Desktop/FACET/2012/DATA/FULL_PYRO/dispersion/'; end;
if half; disp_dir = '/Users/sgess/Desktop/FACET/2012/DATA/HALF_PYRO/dispersion/'; end;
if seba; disp_dir = '/Users/sgess/Desktop/FACET/2012/DATA/JULY_2_DATA/'; end;

if full || half; disp_name  = 'facet_dispersion-SCAVENGY.MKB-2012-06-30-054158.mat'; end;
%if seba; disp_name  = 'facet_dispersion-SCAVENGY.MKB-2012-07-02-065518.mat'; end;
if seba; disp_name  = 'facet_dispersion-SCAVENGY.MKB-2012-07-02-090655.mat'; end;

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


if full || half; load([data_dir{1} state_name]); else load([data_dir state_name]); end;
load([disp_dir disp_name]);

do_disp = 1;
do_y = 1;
plot_disp = 0;
extract = 1;
view_yag = 1;
interp = 0;
compare = 0;
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
lo_line = 200;
hi_line = 225;


bad_pix = [638 639];
spec = 550;
if extract
    disp('Extracting data. . .');
    for i=1:length(slim_name)
    if full || half; load([data_dir{i} slim_name{i}]); else load([data_dir slim_name{i}]); end;
    nShots(i) = length(good_data);
    DATA(i) = extract_data(good_data,eta_yag,beam_size,lo_line,hi_line,bad_pix,nShots(i),view_yag,too_wide,spec);
    clear('good_data');
    end
    disp('Data extraction complete.');
end


cat_dat.NRTL_PHAS = [];
cat_dat.NRTL_AMPL = [];

cat_dat.PID_BSA = [];
cat_dat.PID_AIDA = [];
cat_dat.PID_PROF = [];

cat_dat.BPM_2050_X = [];
cat_dat.BPM_2050_Y = [];
cat_dat.BPM_2050_TMIT = [];

cat_dat.BPM_2445_X = [];
cat_dat.BPM_2445_Y = [];
cat_dat.BPM_2445_TMIT = [];

cat_dat.BPM_3101_X = [];
cat_dat.BPM_3101_Y = [];
cat_dat.BPM_3101_TMIT = [];

cat_dat.BPM_3036_X = [];
cat_dat.BPM_3036_Y = [];
cat_dat.BPM_3036_TMIT = [];

cat_dat.TORO_2452_TMIT = [];
cat_dat.TORO_3163_TMIT = [];
cat_dat.TORO_DR13_TMIT = [];

cat_dat.PYRO = [];

cat_dat.YAG_FWHM = [];
cat_dat.YAG_SPEC = [];
cat_dat.YAG_SUM = [];

for g=1:length(slim_name)
    
   cat_dat.NRTL_PHAS  = [cat_dat.NRTL_PHAS  DATA(g).NRTL.PHAS];
   cat_dat.NRTL_AMPL  = [cat_dat.NRTL_AMPL  DATA(g).NRTL.AMPL];
   
   cat_dat.PID_BSA    = [cat_dat.PID_BSA    DATA(g).PID.BSA];
   cat_dat.PID_AIDA   = [cat_dat.PID_AIDA   DATA(g).PID.AIDA];
   cat_dat.PID_PROF   = [cat_dat.PID_PROF   DATA(g).PID.PROF];
   
   cat_dat.BPM_2050_X = [cat_dat.BPM_2050_X DATA(g).BPM_2050.X];
   cat_dat.BPM_2050_Y = [cat_dat.BPM_2050_Y DATA(g).BPM_2050.Y];
   cat_dat.BPM_2050_TMIT = [cat_dat.BPM_2050_TMIT DATA(g).BPM_2050.TMIT];

   cat_dat.BPM_2445_X = [cat_dat.BPM_2445_X DATA(g).BPM_2445.X];
   cat_dat.BPM_2445_Y = [cat_dat.BPM_2445_Y DATA(g).BPM_2445.Y];
   cat_dat.BPM_2445_TMIT = [cat_dat.BPM_2445_TMIT DATA(g).BPM_2445.TMIT];

   cat_dat.BPM_3036_X = [cat_dat.BPM_3036_X DATA(g).BPM_3036.X];
   cat_dat.BPM_3036_Y = [cat_dat.BPM_3036_Y DATA(g).BPM_3036.Y];
   cat_dat.BPM_3036_TMIT = [cat_dat.BPM_3036_TMIT DATA(g).BPM_3036.TMIT];
   
   cat_dat.BPM_3101_X = [cat_dat.BPM_3101_X DATA(g).BPM_3101.X];
   cat_dat.BPM_3101_Y = [cat_dat.BPM_3101_Y DATA(g).BPM_3101.Y];
   cat_dat.BPM_3101_TMIT = [cat_dat.BPM_3101_TMIT DATA(g).BPM_3101.TMIT];
   
   cat_dat.TORO_2452_TMIT = [cat_dat.TORO_2452_TMIT DATA(g).TORO_2452.TMIT];
   cat_dat.TORO_3163_TMIT = [cat_dat.TORO_3163_TMIT DATA(g).TORO_3163.TMIT];
   cat_dat.TORO_DR13_TMIT = [cat_dat.TORO_DR13_TMIT DATA(g).TORO_DR13.TMIT];
   
   cat_dat.PYRO       = [cat_dat.PYRO       DATA(g).PYRO.VAL];
   
   cat_dat.YAG_FWHM   = [cat_dat.YAG_FWHM   DATA(g).YAG.FWHM];
   cat_dat.YAG_SPEC   = [cat_dat.YAG_SPEC   DATA(g).YAG.spectrum];
   cat_dat.YAG_SUM    = [cat_dat.YAG_SUM   DATA(g).YAG.SUM];
   
end

[cat_dat.py_sort, cat_dat.ind_sort] = sort(cat_dat.PYRO);
cat_dat.yag_ax = DATA(g).AXIS.xx/1000;
cat_dat.nshots = nShots;
if savE; save(['concat_' save_name],'cat_dat'); end;


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