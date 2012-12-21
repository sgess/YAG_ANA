%clear all;

scan = 0;

global PARAM;

%MJH_param;
%MDW_param;
%SJG_param;
temp_param;

f1 = 1;
f2 = 2;
if scan == 0
    
    
    
    
    
    
    PARAM.INIT.SIGZ0 = 6.7E-3; % 1 Part per 100 - checks
    PARAM.INIT.SIGD0 = 9.8E-4; % 1 Part per 100, more like 2 Part per 1000, not yet stable
    PARAM.INIT.ASYM  = -0.163; % 1 Part per 100, more like 4 Part per 100, not yet stable
    PARAM.INIT.NPART = 2.72E10;% 1 Part per 100, more like 1 Part per 1000, stablish
    
    PARAM.NRTL.AMPL = 41.1E-3; % 1 Part per 1000, more like 2 Part per 10000, stablish
    PARAM.NRTL.PHAS = 89.71;   % 1 Part per 1000, more like 2 Part per 10000, stablish
    PARAM.NRTL.ELO   = -0.0228;% 1 Part per 100, more like 2 Part per 1000, stablish  
    PARAM.NRTL.EHI   = 0.0228; % 1 Part per 100, more like 2 Part per 1000, stablish   
    PARAM.NRTL.R56   = 0.6026; % 1 Part per 1000, more like 2 Part per 10000, stablish
    PARAM.NRTL.T566  = 0.9215; % 1 Part per 100 - checks
    
    ramp = -2.549;               % 1 Part per 100, more like 2 Part per 1000, not yet stable
    decker = -18.7;              % 2 Part per 1000, 1 Part per 1000, stablish
    PARAM.LONE.PHAS = decker+ramp;
    
    PARAM.LI10.R56   = -0.076; % 2 Part per 1000? 1 Part per 1000, stablish
    PARAM.LI10.ELO   = -0.04;  % 2 Part per 100?
    PARAM.LI10.EHI   = 0.04;   % 2 Part per 100?
    
    
    PARAM.LTWO.PHAS = ramp;
    
    PARAM.LI20.ELO   = -0.0286;   % RTL lower momentum cut (GeV)
    PARAM.LI20.EHI   = 0.0286;    % RTL upper momentum cut (GeV)
    
    res_set = zeros(1,11);
    
    SIGZ0_i = 6.7E-3;
    SIGZ0_m = SIGZ0_i;
    PARAM.INIT.SIGZ0 = SIGZ0_i;
    SIGD0_i = 9.8E-4;
    SIGD0_m = -3*SIGD0_i/500 + SIGD0_i;
    PARAM.INIT.SIGD0 = SIGD0_m;
    ASYM_i  = -0.1728;
    PARAM.INIT.ASYM = ASYM_i;
    NPART_i = 2.72E10;
    NPART_m = NPART_i/1000 + NPART_i;
    PARAM.INIT.NPART = NPART_m;
    AMPL_i  = 41.1E-3;
    PARAM.NRTL.AMPL = AMPL_i;
    PHAS_i  = 89.71;
    PARAM.NRTL.PHAS = PHAS_i;
    NRTL_ECUT_i  = 0.0228;
    PARAM.NRTL.ELO = -NRTL_ECUT_i;
    PARAM.NRTL.EHI = NRTL_ECUT_i;
    NRTL_R56_i = 0.6027;
    PARAM.NRTL.R56 = NRTL_R56_i;
    NRTL_T566_i = 0.9123;
    PARAM.NRTL.T566 = NRTL_T566_i;
    ramp_i = -2.5286;
    ramp = ramp_i;
    decker_i = -18.7;
    decker_m = decker_i/1000 + decker_i;
    decker = decker_m;
    LI10_R56_i = -0.076;
    LI10_R56_m = -2*LI10_R56_i/1000 + LI10_R56_i;
    PARAM.LI10.R56 = LI10_R56_m;
    LI10_ECUT_i  = 0.040;
    PARAM.LI10.ELO = -LI10_ECUT_i;
    PARAM.LI10.EHI = LI10_ECUT_i;
    LI20_ECUT_i  = 0.03;
    PARAM.LI20.ELO = -LI20_ECUT_i;
    PARAM.LI20.EHI = LI20_ECUT_i;
    
    PARAM.LONE.PHAS = decker+ramp;
    PARAM.LONE.GAIN = (PARAM.ENRG.E1 - PARAM.ENRG.E0)/cosd(PARAM.LONE.PHAS);

    LiTrack('FACETpar');
    dither = 0;
    conv = 0;
    
    if dither
        
        for i=1:11
            
            %decker = (i-6)*decker_i/1000 + decker_i;
            %PARAM.LI10.R56 = (i-6)*LI10_R56_i/1000 + LI10_R56_i;
            
            
            %PARAM.NRTL.ELO = -((i-6)*(NRTL_ECUT_i)/50+(NRTL_ECUT_i));
            %PARAM.NRTL.EHI = (i-6)*NRTL_ECUT_i/50+NRTL_ECUT_i;
            
%             PARAM.LI10.ELO = -((i-6)*(LI10_ECUT_i)/25+(LI10_ECUT_i));
%             PARAM.LI10.EHI = (i-6)*LI10_ECUT_i/25+LI10_ECUT_i;
            
            PARAM.LI20.ELO = -((i-6)*(LI20_ECUT_i)/25+(LI20_ECUT_i));
            PARAM.LI20.EHI = (i-6)*LI20_ECUT_i/25+LI20_ECUT_i;
            
            PARAM.LONE.PHAS = decker+ramp;
            
            PARAM.LONE.GAIN = (PARAM.ENRG.E1 - PARAM.ENRG.E0)/cosd(PARAM.LONE.PHAS);
            OUT = LiTrack('FACETpar');
            
            
            % Identify Max and Min of Simulated energy distribution
            e_max = OUT.E.AXIS(256,6)/100;
            e_min = OUT.E.AXIS(1,6)/100;
            
            % Find the Max and Min on the YAG energy axis
            [~,iMax] = min(abs(e_max - ENG_AX));
            [~,iMin] = min(abs(e_min - ENG_AX));
            N = iMax - iMin + 1;
            
            % Interpolate the simulated distribution onto the YAG axis
            xx = linspace(1,256,N);
            ES = interp1(OUT.E.HIST(:,6)/100,xx);
            
            % Calculate the centroid and integral of the distribution
            simsum = sum(ES);
            simcent = round(sum((1:N).*ES)/simsum);
            
            % embed interpolated distribution onto energy axis, with
            % centr ros(1,PIX);
            ee(round(PIX/2-simcent):round(PIX/2-simcent+N-1)) = ES/simsum;
            
            % convolve energy spread with gaussian
            yy = conv(ES,g);
            
            % find centroid of convolution, convolution is a vector
            % that is N + PIX - 1 long
            consum = sum(yy);
            concent = round(sum((1:length(yy)).*yy)/consum);
            
            % project convolved distribution onto energy axis, with
            % centroid of distribution at delta = 0
            Eplot = yy((concent-round(PIX/2)):(concent+round(PIX/2)-1))/consum;
            
            e_res = ehappy - Eplot';
            res = sum(e_res.*e_res);
            
            res_set(i) = res;
                        
        end
        
    elseif conv
        %PARAM.NRTL.R56 = 0*NRTL_R56_i/200 + NRTL_R56_i;
        PARAM.LONE.GAIN = (PARAM.ENRG.E1 - PARAM.ENRG.E0)/cosd(PARAM.LONE.PHAS);
        OUT = LiTrack('FACETpar');
        
        
        % Identify Max and Min of Simulated energy distribution
        e_max = OUT.E.AXIS(256,6)/100;
        e_min = OUT.E.AXIS(1,6)/100;
        
        % Find the Max and Min on the YAG energy axis
        [~,iMax] = min(abs(e_max - ENG_AX));
        [~,iMin] = min(abs(e_min - ENG_AX));
        N = iMax - iMin + 1;
        
        % Interpolate the simulated distribution onto the YAG axis
        xx = linspace(1,256,N);
        ES = interp1(OUT.E.HIST(:,6)/100,xx);
        
        % Calculate the centroid and integral of the distribution
        simsum = sum(ES);
        simcent = round(sum((1:N).*ES)/simsum);
        
        % embed interpolated distribution onto energy axis, with
        % centr ros(1,PIX);
        ee(round(PIX/2-simcent):round(PIX/2-simcent+N-1)) = ES/simsum;
        
        % convolve energy spread with gaussian
        yy = conv(ES,g);
        
        % find centroid of convolution, convolution is a vector
        % that is N + PIX - 1 long
        consum = sum(yy);
        concent = round(sum((1:length(yy)).*yy)/consum);
        
        % project convolved distribution onto energy axis, with
        % centroid of distribution at delta = 0
        Eplot = yy((concent-round(PIX/2)):(concent+round(PIX/2)-1))/consum;
        
        e_res = ehappy - Eplot';
        res = sum(e_res.*e_res);
            
        figure(f1);
        plot(ENG_AX,Eplot,ENG_AX,ehappy);
        text(-0.04,0.5e-3,num2str(res,'%10.3e'));
        figure(f2);
        plot(OUT.Z.AXIS(:,6),OUT.Z.HIST(:,6));

    end
    
elseif scan == 1
    
    n_out = 6;
    
    % Phase range
    %p_lo = -20.95;
    %p_hi = -22.55;
    p_lo = 88.7;
    p_hi = 90.3;
    
    % comp range
    n_lo = 0.0394;
    n_hi = 0.0426;
    
    % number of sample points
    p_el = 64;
    n_el = 64;
    
    % phase and ampl vec
    phase = linspace(p_lo,p_hi,p_el);
    NAMPL = linspace(n_lo,n_hi,n_el);
    
    chrp = zeros(1,p_el);
    phas = zeros(1,p_el);
    
    bl_fwhm = zeros(p_el,n_el,n_out);
    bl_sig  = zeros(p_el,n_el,n_out);
    z_avg   = zeros(p_el,n_el,n_out);
    
    e_avg   = zeros(p_el,n_el,n_out);
    e_fwhm  = zeros(p_el,n_el,n_out);
    e_sig   = zeros(p_el,n_el,n_out);
    e_cut   = zeros(p_el,n_el,n_out);
    
    I_max   = zeros(p_el,n_el,n_out);
    I_sig   = zeros(p_el,n_el,n_out);
    
    N       = zeros(p_el,n_el,n_out);
    
    bl      = zeros(PARAM.SIMU.BIN,p_el,n_el,n_out);
    es      = zeros(PARAM.SIMU.BIN,p_el,n_el,n_out);
    
    zz      = zeros(PARAM.SIMU.BIN,p_el,n_el,n_out);
    ee      = zeros(PARAM.SIMU.BIN,p_el,n_el,n_out);
    
    tot = p_el*n_el;
    for i = 1:p_el
        for j = 1:n_el
            
            prog = 100*((i-1)*p_el + j)/tot;
            disp(['Progress: ' num2str(prog,'%.2f') '%']);
            
            
            PARAM.NRTL.PHAS = phase(i);
            PARAM.NRTL.AMPL = NAMPL(j);
            PARAM.LONE.GAIN = (PARAM.ENRG.E1 - PARAM.ENRG.E0)/cosd(PARAM.LONE.PHAS);
            chrp(i)         = -PARAM.LONE.GAIN*tand(PARAM.LONE.PHAS);
            phas(i)         = PARAM.LONE.PHAS;
            
            OUT = LiTrack('FACETpar');
            
            bl_fwhm(i,j,:) = OUT.Z.FWHM;
            bl_sig(i,j,:)  = OUT.Z.SIG;
            z_avg(i,j,:)   = OUT.Z.AVG;
            
            e_avg(i,j,:)   = OUT.E.AVG;
            e_fwhm(i,j,:)  = OUT.E.FWHM;
            e_sig(i,j,:)   = OUT.E.SIG;
            
            I_max(i,j,:)   = OUT.I.PEAK;
            I_sig(i,j,:)   = OUT.I.SIG;
            
            N(i,j,:)       = OUT.I.PART;
            
            for o = 1:n_out
                
                bl(:,i,j,o) = OUT.Z.HIST(:,o);
                es(:,i,j,o) = OUT.E.HIST(:,o);
                zz(:,i,j,o) = OUT.Z.AXIS(:,o);
                ee(:,i,j,o) = OUT.E.AXIS(:,o);
            
            end
            
        end
    end
save('NRTL_scan.mat');
end