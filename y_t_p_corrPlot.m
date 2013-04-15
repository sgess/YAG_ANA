fp_save_dir = '/Users/sgess/Desktop/plots/E200/FULL_PYRO/';
hp_save_dir = '/Users/sgess/Desktop/plots/E200/HALF_PYRO/';
savE = 1;

fp = load('concat_full_pyro.mat');
hp = load('concat_half_pyro.mat');

half = 1;
full = 1;

if half

figure(1);
plot(hp.cat_dat.BPM_2445_Y,hp.cat_dat.PYRO,'*');
xlabel('BPM 2445 Y');
ylabel('Pyro');
title('Half Pyro Data');
if savE; saveas(gca,[hp_save_dir 'BPM_2445_Y_v_PYRO.png']); end;

figure(2);
plot(hp.cat_dat.BPM_2445_Y,hp.cat_dat.BPM_2445_TMIT,'*');
xlabel('BPM 2445 Y');
ylabel('BPM 2445 TMIT');
title('Half Pyro Data');
if savE; saveas(gca,[hp_save_dir 'BPM_2445_Y_v_BPM_2445_TMIT.png']); end;

figure(3);
plot(hp.cat_dat.BPM_2445_TMIT,hp.cat_dat.PYRO,'*');
xlabel('BPM 2445 TMIT');
ylabel('Pyro');
title('Half Pyro Data');
if savE; saveas(gca,[hp_save_dir 'BPM_2445_TMIT_v_PYRO.png']); end;

figure(4);
plot(hp.cat_dat.BPM_2050_X,hp.cat_dat.BPM_2445_Y,'*');
xlabel('BPM 2050 X');
ylabel('BPM 2445 Y');
title('Half Pyro Data');
if savE; saveas(gca,[hp_save_dir 'BPM_2050_X_v_BPM_2445_Y.png']); end;

figure(5);
plot(hp.cat_dat.BPM_2050_X,hp.cat_dat.BPM_2445_TMIT,'*');
xlabel('BPM 2050 X');
ylabel('BPM 2445 TMIT');
title('Half Pyro Data');
if savE; saveas(gca,[hp_save_dir 'BPM_2050_X_v_BPM_2445_TMIT.png']); end;

figure(6);
plot(hp.cat_dat.BPM_2050_X,hp.cat_dat.PYRO,'*');
xlabel('BPM 2050 X');
ylabel('Pyro');
title('Half Pyro Data');
if savE; saveas(gca,[hp_save_dir 'BPM_2050_X_v_PYRO.png']); end;

[bpm_y_2445,hp_ind_2445_y] = sort(hp.cat_dat.BPM_2445_Y);
[bpm_t_2445,hp_ind_2445_t] = sort(hp.cat_dat.BPM_2445_TMIT);
[bpm_x_2050,hp_ind_2050_x] = sort(hp.cat_dat.BPM_2050_X);

figure(7);
imagesc(fliplr(bpm_y_2445),hp.cat_dat.yag_ax,hp.cat_dat.YAG_SPEC(:,hp_ind_2445_y));
xlabel('BPM 2445 Y (mm)');
ylabel('X (mm)');
title('Half Pyro Data');
if savE; saveas(gca,[hp_save_dir 'YAG_SORT_BPM_2445_Y.png']); end;

figure(8);
imagesc(fliplr(bpm_t_2445),hp.cat_dat.yag_ax,hp.cat_dat.YAG_SPEC(:,hp_ind_2445_t));
set(gca,'xdir','reverse');
xlabel('BPM 2445 TMIT');
ylabel('X (mm)');
title('Half Pyro Data');
if savE; saveas(gca,[hp_save_dir 'YAG_SORT_BPM_2445_TMIT.png']); end;

figure(9);
imagesc(fliplr(hp.cat_dat.py_sort),hp.cat_dat.yag_ax,hp.cat_dat.YAG_SPEC(:,hp.cat_dat.ind_sort));
xlabel('Pyro');
ylabel('X (mm)');
title('Half Pyro Data');
if savE; saveas(gca,[hp_save_dir 'YAG_SORT_PYRO.png']); end;

figure(10);
imagesc(fliplr(bpm_x_2050),hp.cat_dat.yag_ax,hp.cat_dat.YAG_SPEC(:,hp_ind_2050_x));
set(gca,'xdir','reverse');
xlabel('BPM 2050 X');
ylabel('X (mm)');
title('Half Pyro Data');
if savE; saveas(gca,[hp_save_dir 'YAG_SORT_BPM_2050_X.png']); end;

hp.cat_dat.PYRO(hp.cat_dat.ind_sort(end))
hp.cat_dat.BPM_2445_Y(hp.cat_dat.ind_sort(end))
hp.cat_dat.BPM_2445_TMIT(hp.cat_dat.ind_sort(end))

figure(11);
plot(hp.cat_dat.yag_ax,hp.cat_dat.YAG_SPEC(:,hp.cat_dat.ind_sort(end)));

hp.cat_dat.PYRO(hp.cat_dat.ind_sort(1))
hp.cat_dat.BPM_2445_Y(hp.cat_dat.ind_sort(1))
hp.cat_dat.BPM_2445_TMIT(hp.cat_dat.ind_sort(1))

figure(12);
plot(hp.cat_dat.yag_ax,hp.cat_dat.YAG_SPEC(:,hp.cat_dat.ind_sort(1)));


end

if full


% full pyro
figure(1);
plot(fp.cat_dat.BPM_2445_Y,fp.cat_dat.PYRO,'*');
xlabel('BPM 2445 Y');
ylabel('Pyro');
title('Full Pyro Data');
if savE; saveas(gca,[fp_save_dir 'BPM_2445_Y_v_PYRO.png']); end;

figure(2);
plot(fp.cat_dat.BPM_2445_Y,fp.cat_dat.BPM_2445_TMIT,'*');
xlabel('BPM 2445 Y');
ylabel('BPM 2445 TMIT');
title('Full Pyro Data');
if savE; saveas(gca,[fp_save_dir 'BPM_2445_Y_v_BPM_2445_TMIT.png']); end;

figure(3);
plot(fp.cat_dat.BPM_2445_TMIT,fp.cat_dat.PYRO,'*');
xlabel('BPM 2445 TMIT');
ylabel('Pyro');
title('Full Pyro Data');
if savE; saveas(gca,[fp_save_dir 'BPM_2445_TMIT_v_PYRO.png']); end;

figure(4);
plot(fp.cat_dat.BPM_2050_X,fp.cat_dat.BPM_2445_Y,'*');
xlabel('BPM 2050 X');
ylabel('BPM 2445 Y');
title('Full Pyro Data');
if savE; saveas(gca,[fp_save_dir 'BPM_2050_X_v_BPM_2445_Y.png']); end;

figure(5);
plot(fp.cat_dat.BPM_2050_X,fp.cat_dat.BPM_2445_TMIT,'*');
xlabel('BPM 2050 X');
ylabel('BPM 2445 TMIT');
title('Full Pyro Data');
if savE; saveas(gca,[fp_save_dir 'BPM_2050_X_v_BPM_2445_TMIT.png']); end;

figure(6);
plot(fp.cat_dat.BPM_2050_X,fp.cat_dat.PYRO,'*');
xlabel('BPM 2050 X');
ylabel('Pyro');
title('Full Pyro Data');
if savE; saveas(gca,[fp_save_dir 'BPM_2050_X_v_PYRO.png']); end;

[bpm_y_2445,fp_ind_2445_y] = sort(fp.cat_dat.BPM_2445_Y);
[bpm_t_2445,fp_ind_2445_t] = sort(fp.cat_dat.BPM_2445_TMIT);
[bpm_x_2050,fp_ind_2050_x] = sort(fp.cat_dat.BPM_2050_X);

figure(7);
imagesc(fliplr(bpm_y_2445),fp.cat_dat.yag_ax,fp.cat_dat.YAG_SPEC(:,fp_ind_2445_y));
set(gca,'xdir','reverse');
xlabel('BPM 2445 Y (mm)');
ylabel('X (mm)');
title('Full Pyro Data');
if savE; saveas(gca,[fp_save_dir 'YAG_SORT_BPM_2445_Y.png']); end;

figure(8);
imagesc(fliplr(bpm_t_2445),fp.cat_dat.yag_ax,fp.cat_dat.YAG_SPEC(:,fp_ind_2445_t));
set(gca,'xdir','reverse');
xlabel('BPM 2445 TMIT');
ylabel('X (mm)');
title('Full Pyro Data');
if savE; saveas(gca,[fp_save_dir 'YAG_SORT_BPM_2445_TMIT.png']); end;

figure(9);
imagesc(fp.cat_dat.py_sort,fp.cat_dat.yag_ax,fp.cat_dat.YAG_SPEC(:,fp.cat_dat.ind_sort));
xlabel('Pyro');
ylabel('X (mm)');
title('Full Pyro Data');
if savE; saveas(gca,[fp_save_dir 'YAG_SORT_PYRO.png']); end;

figure(10);
imagesc(fliplr(bpm_x_2050),fp.cat_dat.yag_ax,fp.cat_dat.YAG_SPEC(:,fp_ind_2050_x));
set(gca,'xdir','reverse');
xlabel('BPM 2050 X');
ylabel('X (mm)');
title('Full Pyro Data');
if savE; saveas(gca,[fp_save_dir 'YAG_SORT_BPM_2050_X.png']); end;

fp.cat_dat.PYRO(fp.cat_dat.ind_sort(end))
fp.cat_dat.BPM_2445_Y(fp.cat_dat.ind_sort(end))
fp.cat_dat.BPM_2445_TMIT(fp.cat_dat.ind_sort(end))

figure(11);
plot(fp.cat_dat.yag_ax,fp.cat_dat.YAG_SPEC(:,fp.cat_dat.ind_sort(end)));

fp.cat_dat.PYRO(fp.cat_dat.ind_sort(1))
fp.cat_dat.BPM_2445_Y(fp.cat_dat.ind_sort(1))
fp.cat_dat.BPM_2445_TMIT(fp.cat_dat.ind_sort(1))

figure(12);
plot(fp.cat_dat.yag_ax,fp.cat_dat.YAG_SPEC(:,fp.cat_dat.ind_sort(1)));

end





