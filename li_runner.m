%[k_microns,k_percent,ke_average,ke_fwhm,kz_fwhm,kz_average,ke_avg_cut,knum_part]=LiTrack('FACETsgess');

%[s_microns,s_percent,se_average,se_fwhm,sz_fwhm,sz_average,se_avg_cut,snum_part]=LiTrack('FACETsect');

num = 1467;
MACH = get_amp_and_phase(num,0,0,0);

Z_NAME     = cell(25,1);
Z_NAME{1}  = 'Initial Beam from NDR';
Z_NAME{2}  = 'After RTL Compressor';
Z_NAME{3}  = 'After RTL Chicane';
Z_NAME{4}  = 'END LI02';
Z_NAME{5}  = 'END LI03';
Z_NAME{6}  = 'END LI04';
Z_NAME{7}  = 'END LI05';
Z_NAME{8}  = 'END LI06';
Z_NAME{9}  = 'END LI07';
Z_NAME{10} = 'END LI08';
Z_NAME{11} = 'END LI09';
Z_NAME{12} = 'END LI10';
Z_NAME{13} = 'After S10 Energy Feedback';
Z_NAME{14} = 'After S10 Chicane w/ISR';
Z_NAME{15} = 'END LI11';
Z_NAME{16} = 'END LI12';
Z_NAME{17} = 'END LI13';
Z_NAME{18} = 'END LI14';
Z_NAME{19} = 'END LI15';
Z_NAME{20} = 'END LI16';
Z_NAME{21} = 'END LI17';
Z_NAME{22} = 'END LI18';
Z_NAME{23} = 'END LI19';
Z_NAME{24} = 'After S20 Energy Feedback';
Z_NAME{25} = 'After FACET Chicane';

Z_LIST        = zeros(25,1);         
Z_LIST(1)     = 0;                   
Z_LIST(2)     = 2.1694+86.4108;              
Z_LIST(3)     = MACH.SECT.Z(1);
Z_LIST(4:11)  = MACH.SECT.Z(1:8)+86.4108;
Z_LIST(12)    = MACH.SECT.Z(9)+86.4108 - 10;
Z_LIST(13)    = MACH.SECT.Z(9)+86.4108;
Z_LIST(14)    = MACH.SECT.Z(9)+86.4108 + 10;
Z_LIST(15:22) = MACH.SECT.Z(10:17)+86.4108;
Z_LIST(23)    = MACH.SECT.Z(18)+86.4108 - 10;
Z_LIST(24)    = MACH.SECT.Z(18)+86.4108;
Z_LIST(25)    = MACH.SECT.Z(19)+86.4108;

z = linspace(0,2100);
e1 = 1.19*ones(1,100);
e2 = 9*ones(1,100);
e3 = 20.35*ones(1,100);

plot(Z_LIST,ke_average,':',Z_LIST,se_average,'s',z,e1,'--c',z,e2,'--m',z,e3,'--y');
line([Z_LIST(12) Z_LIST(12)],[0,21],'LineStyle','--');
text(1000,8,'Sector 10 Chicane','Fontsize',16);
axis([0 2100 0 21]);
xlabel('Z (meters)','fontsize',16);
ylabel('Energy (GeV)','fontsize',16);
title('Simulated energy profile for full and sector averaged linac','fontsize',16);
l = legend('Energy Profile, All Klystrons','Energy Profile, By Sector',...
    '1.19 GeV','9 GeV','20.35 GeV','Location','Northwest');
set(l,'fontsize',13);
saveas(gca,['/Users/sgess/Desktop/plots/E200/E200_' num2str(num) '/sim_eProf.pdf']);

semilogy(Z_LIST,kz_fwhm*1000,':c',Z_LIST,sz_fwhm*1000,'sr');
line([Z_LIST(12) Z_LIST(12)],[50,12000],'LineStyle','--');
text(1000,1000,'Sector 10 Chicane','Fontsize',16);
axis([0 2100 90 13000]);
xlabel('Z (meters)','fontsize',16);
ylabel('FWHM Bunch Length (\mum)','fontsize',16);
title('Simulated bunch length for full and sector averaged linac','fontsize',16);
l = legend('Bunch Length, All Klystrons','Bunch Length, By Sector');
set(l,'fontsize',13);
saveas(gca,['/Users/sgess/Desktop/plots/E200/E200_' num2str(num) '/sim_blfwhm.pdf']);


