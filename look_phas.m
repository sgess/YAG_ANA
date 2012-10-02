clear all;

% Parameters
global PARAM;
global LINAC;

load('/Users/sgess/Desktop/data/E200_DATA/E200_1443/E200_1443_slim.mat');

phase = zeros(5,18);
ampl = zeros(5,18);

    for j = 1:18
        
        
            
            phase(1,j) = d_1(j).aida.klys.phase;
            phase(2,j) = d_2(j).aida.klys.phase;
            phase(3,j) = d_3(j).aida.klys.phase;
            phase(4,j) = d_4(j).aida.klys.phase;
            phase(5,j) = d_5(j).aida.klys.phase;
            
            ampl(1,j) = d_1(j).DR13_AMPL_11_VACT.val;
            ampl(2,j) = d_2(j).DR13_AMPL_11_VACT.val;
            ampl(3,j) = d_3(j).DR13_AMPL_11_VACT.val;
            ampl(4,j) = d_4(j).DR13_AMPL_11_VACT.val;
            ampl(5,j) = d_5(j).DR13_AMPL_11_VACT.val;
            
    end
    
    off = 90 - median(phase(:));
    
    MDW_param;
    
    %find phase ramp?
%     PARAM.NRTL.AMPL = mean(ampl(:))*1e-3;
%     PARAM.NRTL.PHAS = 90;
%     PARAM.MACH.RAMP = -6.1;
    
    
    f = figure;
    
    for i = 1:1
        for j = 1:18
    
            PARAM.NRTL.AMPL = ampl(i,j)*1e-3;
            PARAM.NRTL.PHAS = phase(i,j)+off;
            %PARAM.NRTL.PHAS = phase(1,1);
            PARAM.MACH.RAMP  = 0;
            num = 1443;
            LINAC = get_amp_and_phase(num,0,0,0);
            LINAC.SECT.PHAS = LINAC.SECT.PHAS + PARAM.MACH.RAMP;
            [d_bl,d_es,d_eavg,d_efwhm,d_zfwhm,d_zavg,d_eavgcut,d_numpart,sigzGj,sigEGj,I_pkj,I_pkfj] = LiTrack('FACETDSECT');
            
            
            figure(f);
            
            if i==1
                d = d_1;
            elseif i==2
                d = d_2;
            elseif i==3
                d = d_3;
            elseif i==4
                d = d_4;
            elseif i==5
                d = d_5;
            end
            
            subplot(2,2,1);
            im = d(j).YAGS_LI20_2432.img;
            imup = flipdim(im',1);
            imagesc(imup);
            xlabel('Pixels','FontSize', 16);
            ylabel('Pixels','FontSize', 16);
            title(['YAG for Pulse ID ' num2str(d(j).YAGS_LI20_2432.prof_pid)],'FontSize', 12);
            
            subplot(2,2,3);
            ee = linspace(-0.0849/2,0.0849/2,838);
            plot(ee,mean(imup(240:260,:),1));
            axis([-0.04 0.04 0 100]);
            xlabel('Energy Spread','FontSize', 16);
            title(['Lineout for Pulse ID ' num2str(d(j).YAGS_LI20_2432.prof_pid)],'FontSize', 12);
            
            subplot(2,2,4);
            hist(d_es(1:d_numpart),200);
            xlabel('Energy Spread','FontSize', 16);
            h = findobj(gca,'Type','patch');
            set(h,'FaceColor','w');
            title(['LiTrack Energy Spectrum. Phase Ramp = ' num2str(PARAM.MACH.RAMP)],'FontSize', 12);
            
            subplot(2,2,2);
            hist(d_bl(1:d_numpart)*1000,200);
            xlabel('Bunch length (mm)','FontSize', 16);
            h2 = findobj(gca,'Type','patch');
            set(h2,'FaceColor','w');
            title(['LiTracl Bunch Length. Peak Current = ' num2str(I_pkj) ' kA'],'FontSize', 12);
            
            saveas(gcf,['/Users/sgess/Desktop/plots/E200/E200_1443/simmed/shot_' num2str(d(j).YAGS_LI20_2432.prof_pid) '_PR_' num2str(PARAM.MACH.RAMP) '.pdf']);
    
        end
    end

    
    
    