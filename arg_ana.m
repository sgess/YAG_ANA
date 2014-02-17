clear all;

e200_1111 = 0;
e200_1146 = 0;
e200_1148 = 1;


if e200_1111
    data_dir = '/Users/sgess/Desktop/data/E200_DATA/E200_1111/';
end        
   
if e200_1146
    data_dir = '/Users/sgess/Desktop/data/E200_DATA/E200_1146/';
end

if e200_1148
    data_dir = '/Users/sgess/Desktop/data/E200_DATA/E200_1148/';
end

if e200_1111; save_dir = '/Users/sgess/Desktop/plots/E200/E200_1111'; end;
if e200_1146; save_dir = '/Users/sgess/Desktop/plots/E200/E200_1146'; end;
if e200_1148; save_dir = '/Users/sgess/Desktop/plots/E200/E200_1148'; end;

if e200_1111; save_name  = '1111.mat'; end;
if e200_1146; save_name  = '1146.mat'; end;
if e200_1148; save_name  = '1148.mat'; end;

if e200_1111; slim_name = 'E200_1111_Slim.mat'; end
if e200_1146; slim_name = 'E200_1146_Slim.mat'; end
if e200_1148; slim_name = 'E200_1148_Slim.mat'; end
           
if e200_1111; state_name = 'E200_1111_State.mat'; end
if e200_1146; state_name = 'E200_1146_State.mat'; end
if e200_1148; state_name = 'E200_1148_State.mat'; end


if e200_1111; disp_dir = '/Users/sgess/Desktop/data/E200_DATA/E200_1108/'; end;
if e200_1146; disp_dir = '/Users/sgess/Desktop/data/E200_DATA/July_1/'; end;
if e200_1148; disp_dir = '/Users/sgess/Desktop/data/E200_DATA/July_1/'; end;

if e200_1111; disp_name  = 'facet_dispersion-SCAVENGY.MKB-2012-06-30-054158.mat'; end;
if e200_1146 || e200_1148; disp_name  = 'facet_dispersion-SCAVENGY.MKB-2012-07-01-043249.mat'; end;

load([data_dir state_name]);
load([disp_dir disp_name]);

do_disp = 1;
do_y = 0;
plot_disp = 0;
extract = 1;
view_yag = 0;
interp = 0;
compare = 0;
do_plot = 0;
savE = 1;
too_wide = 0;

if do_disp
    disp('Analyzing dispersion data. . .');
    [eta_yag, beam_size] = disp_ana(data,plot_disp,do_y,savE,save_dir);
    if e200_1146 || e200_1148; eta_yag = 95.0; end;
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
    %for i=1:length(slim_name)
    %if full || half; load([data_dir{i} slim_name{i}]); else load([data_dir slim_name{i}]); end;
    load([data_dir slim_name]);
    nShots = length(good_data);
    DATA = extract_data(good_data,eta_yag,beam_size,lo_line,hi_line,bad_pix,nShots,view_yag,too_wide,spec);
    clear('good_data');
    %end
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

for g=1:length(1)
    
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
   cat_dat.YAG_SPEC   = [cat_dat.YAG_SPEC   DATA(g).YAG.SPECTRUM];
   cat_dat.YAG_SUM    = [cat_dat.YAG_SUM   DATA(g).YAG.SUM];
   
end

[cat_dat.py_sort, cat_dat.ind_sort] = sort(cat_dat.PYRO);
cat_dat.yag_ax = DATA.AXIS.XX/1000;
cat_dat.nshots = nShots;
if savE; save(['concat_' save_name],'cat_dat'); end;