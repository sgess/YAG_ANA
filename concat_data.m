savE = 1;
save_dir = '/Users/sgess/Desktop/FACET/PLOTS/FULL_PYRO/PYRO/';
%save_dir = '/Users/sgess/Desktop/FACET/PLOTS/HALF_PYRO/PYRO/';

NRTL_PHAS = [];
NRTL_AMPL = [];

PID_BSA = [];
PID_AIDA = [];
PID_PROF = [];

BPM_2050_X = [];
BPM_2050_Y = [];
BPM_2050_TMIT = [];

BPM_2445_X = [];
BPM_2445_Y = [];
BPM_2445_TMIT = [];

BPM_3101_X = [];
BPM_3101_Y = [];
BPM_3101_TMIT = [];

BPM_3036_X = [];
BPM_3036_Y = [];
BPM_3036_TMIT = [];

TORO_2452_TMIT = [];
TORO_3163_TMIT = [];
TORO_DR13_TMIT = [];

PYRO = [];

YAG_FWHM = [];
YAG_SPEC = [];

for g=1:5
    
   NRTL_PHAS  = [NRTL_PHAS  DATA(g).NRTL.PHAS];
   NRTL_AMPL  = [NRTL_AMPL  DATA(g).NRTL.AMPL];
   
   PID_BSA    = [PID_BSA    DATA(g).PID.BSA];
   PID_AIDA   = [PID_AIDA   DATA(g).PID.AIDA];
   PID_PROF   = [PID_PROF   DATA(g).PID.PROF];
   
   BPM_2050_X = [BPM_2050_X DATA(g).BPM_2050.X];
   BPM_2050_Y = [BPM_2050_Y DATA(g).BPM_2050.Y];
   BPM_2050_TMIT = [BPM_2050_TMIT DATA(g).BPM_2050.TMIT];

   BPM_2445_X = [BPM_2445_X DATA(g).BPM_2445.X];
   BPM_2445_Y = [BPM_2445_Y DATA(g).BPM_2445.Y];
   BPM_2445_TMIT = [BPM_2445_TMIT DATA(g).BPM_2445.TMIT];

   BPM_3036_X = [BPM_3036_X DATA(g).BPM_3036.X];
   BPM_3036_Y = [BPM_3036_Y DATA(g).BPM_3036.Y];
   BPM_3036_TMIT = [BPM_3036_TMIT DATA(g).BPM_3036.TMIT];
   
   BPM_3101_X = [BPM_3101_X DATA(g).BPM_3101.X];
   BPM_3101_Y = [BPM_3101_Y DATA(g).BPM_3101.Y];
   BPM_3101_TMIT = [BPM_3101_TMIT DATA(g).BPM_3101.TMIT];
   
   TORO_2452_TMIT = [TORO_2452_TMIT DATA(g).TORO_2452.TMIT];
   TORO_3163_TMIT = [TORO_3163_TMIT DATA(g).TORO_3163.TMIT];
   TORO_DR13_TMIT = [TORO_DR13_TMIT DATA(g).TORO_DR13.TMIT];
   
   PYRO       = [PYRO       DATA(g).PYRO.VAL];
   
   YAG_FWHM   = [YAG_FWHM   DATA(g).YAG.FWHM];
   YAG_SPEC   = [YAG_SPEC   DATA(g).YAG.spectrum];
   
end

[py_sort, ind_sort] = sort(PYRO);

figure(1);
imagesc(DATA(g).AXIS.xx/1000,py_sort,YAG_SPEC(:,ind_sort)');
ylabel('Pyrometer');
xlabel('X (mm)');
if savE; saveas(gca,[save_dir 'waterfall.png']); end;

figure(2);
plot(YAG_FWHM,PYRO,'b*');
ylabel('Pyrometer');
xlabel('YAG FWHM (mm)');
if savE; saveas(gca,[save_dir 'pyro_v_fwhm.png']); end;


% figure(3);
% plot(NRTL_PHAS,PYRO,'b*');
% ylabel('Pyrometer');
% xlabel('NRTL Phase');
% 
% figure(4);
% plot(NRTL_PHAS,YAG_FWHM,'b*');
% ylabel('YAG FWHM (mm)');
% xlabel('NRTL Phase');



trons = linspace(1.4e10,2.1e10,100);

order = 2;

if order == 2
    
    tm_3163=polyfit(TORO_3163_TMIT,PYRO,2);
    pyCurve3163 = tm_3163(1)*trons.^2 + tm_3163(2)*trons + tm_3163(3);
    
    tm_2452=polyfit(TORO_2452_TMIT,PYRO,2);
    pyCurve2452 = tm_2452(1)*trons.^2 + tm_2452(2)*trons + tm_2452(3);
    
    tm_dr13=polyfit(TORO_DR13_TMIT,PYRO,2);
    pyCurvedr13 = tm_dr13(1)*trons.^2 + tm_dr13(2)*trons + tm_dr13(3);
    
    tm_2050=polyfit(BPM_2050_TMIT,PYRO,2);
    pyCurve2050 = tm_2050(1)*trons.^2 + tm_2050(2)*trons + tm_2050(3);
    
    tm_2445=polyfit(BPM_2445_TMIT,PYRO,2);
    pyCurve2445 = tm_2445(1)*trons.^2 + tm_2445(2)*trons + tm_2445(3);
    
    tm_3101=polyfit(BPM_3101_TMIT,PYRO,2);
    pyCurve3101 = tm_3101(1)*trons.^2 + tm_3101(2)*trons + tm_3101(3);
    
    charge = find(BPM_3036_TMIT~=0);
    tm_3036=polyfit(BPM_3036_TMIT(charge),PYRO(charge),2);
    pyCurve3036 = tm_3036(1)*trons.^2 + tm_3036(2)*trons + tm_3036(3);

elseif order == 1
    
    tm_3163=polyfit(TORO_3163_TMIT,PYRO,1);
    pyCurve3163 = tm_3163(1)*trons + tm_3163(2);
    
    tm_2452=polyfit(TORO_2452_TMIT,PYRO,1);
    pyCurve2452 = tm_2452(1)*trons + tm_2452(2);
    
    tm_dr13=polyfit(TORO_DR13_TMIT,PYRO,1);
    pyCurvedr13 = tm_dr13(1)*trons + tm_dr13(2);
    
    tm_2050=polyfit(BPM_2050_TMIT,PYRO,1);
    pyCurve2050 = tm_2050(1)*trons + tm_2050(2);
    
    tm_2445=polyfit(BPM_2445_TMIT,PYRO,1);
    pyCurve2445 = tm_2445(1)*trons + tm_2445(2);
    
    tm_3101=polyfit(BPM_3101_TMIT,PYRO,1);
    pyCurve3101 = tm_3101(1)*trons + tm_3101(2);
    
    charge = find(BPM_3036_TMIT~=0);
    tm_3036=polyfit(BPM_3036_TMIT(charge),PYRO(charge),1);
    pyCurve3036 = tm_3036(1)*trons + tm_3036(2);

end

figure(4);
plot(TORO_DR13_TMIT,PYRO,'*',trons,pyCurvedr13,'g','linewidth',3);
axis([min(TORO_DR13_TMIT) max(TORO_DR13_TMIT) min(PYRO) max(PYRO)]);
xlabel('TORO DR13');
ylabel('Pyro');
if savE; saveas(gca,[save_dir 'pyro_v_dr13.png']); end;


figure(5);
plot(TORO_3163_TMIT,PYRO,'*',trons,pyCurve3163,'g','linewidth',3);
axis([min(TORO_3163_TMIT) max(TORO_3163_TMIT) min(PYRO) max(PYRO)]);
xlabel('TORO 3163');
ylabel('Pyro');
if savE; saveas(gca,[save_dir 'pyro_v_3163.png']); end;


figure(6);
plot(TORO_2452_TMIT,PYRO,'*',trons,pyCurve2452,'g','linewidth',3);
axis([min(TORO_2452_TMIT) max(TORO_2452_TMIT) min(PYRO) max(PYRO)]);
xlabel('TORO 2452');
ylabel('Pyro');
if savE; saveas(gca,[save_dir 'pyro_v_2452.png']); end;


figure(7);
plot(BPM_2445_TMIT,PYRO,'*',trons,pyCurve2445,'g','linewidth',3);
axis([min(BPM_2445_TMIT) max(BPM_2445_TMIT) min(PYRO) max(PYRO)]);
xlabel('BPM 2445 TMIT');
ylabel('Pyro');
if savE; saveas(gca,[save_dir 'pyro_v_2445.png']); end;


figure(8);
plot(BPM_2050_TMIT,PYRO,'*',trons,pyCurve2050,'g','linewidth',3);
axis([min(BPM_2050_TMIT) max(BPM_2050_TMIT) min(PYRO) max(PYRO)]);
xlabel('BPM 2050 TMIT');
ylabel('Pyro');
if savE; saveas(gca,[save_dir 'pyro_v_2050.png']); end;

figure(9);
plot(BPM_3101_TMIT,PYRO,'*',trons,pyCurve3101,'g','linewidth',3);
axis([min(BPM_3101_TMIT) max(BPM_3101_TMIT) min(PYRO) max(PYRO)]);
xlabel('BPM 3101 TMIT');
ylabel('Pyro');
if savE; saveas(gca,[save_dir 'pyro_v_3101.png']); end;


figure(12);
plot(BPM_3036_TMIT(charge),PYRO(charge),'*',trons,pyCurve3036,'g','linewidth',3);
axis([min(BPM_3036_TMIT(charge)) max(BPM_3036_TMIT(charge)) min(PYRO) max(PYRO)]);
xlabel('BPM 3036 TMIT');
ylabel('Pyro');
if savE; saveas(gca,[save_dir 'pyro_v_3036.png']); end;

tm_mat = [tm_dr13; tm_2050; tm_2445; tm_2452; tm_3036; tm_3101; tm_3163];
if savE; dlmwrite([save_dir 'fit_ord2.txt'],tm_mat,'delimiter','\t','precision','%0.4e'); end;
