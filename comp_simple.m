%clear all;

scan = 0;

global PARAM;

%MJH_param;
%MDW_param;
%SJG_param;
%temp_param;
E200_1103_PARAM;

S20 = 2;

% Insert axis from data
eta_yag = DATA.BEAM.ETA;
eta_me = 0.95*eta_yag;
ENG_AX = eta_me/eta_yag*DATA.AXIS.ENG;
PIX = length(ENG_AX);
beam_size = DATA.BEAM.SIZE;

% create gaussian for convolution
e_blur = beam_size/eta_me;
g = exp(-(ENG_AX.^2)/(2*e_blur^2));
g = g/sum(g);

r = 65;

ehappy = DATA.YAG.SPECTRUM(:,r)/sum(DATA.YAG.SPECTRUM(:,r));
%ehappy = mean(DATA.YAG.SPECTRUM,2)/sum(mean(DATA.YAG.SPECTRUM,2));

f1 = 1;
f2 = 2;
f3 = 3;
if scan == 0
    
    decker = -20.3;
    ramp = -2.10;
    
    PARAM.INIT.SIGZ0 = 6.80E-3;
    PARAM.INIT.SIGD0 = 9.00E-4;
    PARAM.INIT.NPART = 2.12E10;
    PARAM.INIT.ASYM  = -0.250;
    
    PARAM.NRTL.AMPL  = 0.0398;
    PARAM.NRTL.PHAS  = 89.10;
    
    PARAM.NRTL.ELO   = -0.0340;
    PARAM.NRTL.EHI   = 0.0340;
    
    PARAM.LI10.ELO   = -0.042;
    PARAM.LI10.EHI   = 0.042;
    
    PARAM.LI20.ELO   = -0.034;
    PARAM.LI20.EHI   = 0.028;
    
    PARAM.NRTL.R56   = 0.6026;
    PARAM.NRTL.T566  = 1.075;
    PARAM.LI10.R56   = -0.075786;
    
    PARAM.LONE.PHAS = decker+ramp;
    PARAM.LTWO.PHAS = ramp;
    
    PARAM.LI20.R56   = 0.0050;
    PARAM.LI20.T566  = 0.100;
    
    dither = 0;
    
    if dither
        
        res_set = zeros(1,11);
        %ramp_i = -1.5;
        %decker_i = -21.315;
        %nrtl_ampl_i = 0.04045;
        nrtl_phas_i = 88.95;
        %sigz0_i = 7.7E-3;
        %sigd0_i = 7.5E-4;
        %part_i  = 2.6e10;
        
        for i=1:11
            
            %ramp = (i-6)*ramp_i/10 + ramp_i;
            %decker = (i-6)*decker_i/100 + decker_i;
            %PARAM.NRTL.AMPL = (i-6)*nrtl_ampl_i/100 + nrtl_ampl_i;
            PARAM.NRTL.PHAS = (i-6)*nrtl_phas_i/1000 + nrtl_phas_i;
            %PARAM.INIT.SIGD0 = (i-6)*sigd0_i/100 + sigd0_i;
            %PARAM.INIT.SIGZ0 = (i-6)*sigz0_i/20 + sigz0_i;
            %PARAM.INIT.NPART = (i-6)*part_i/20 + part_i;
            
            PARAM.LONE.PHAS = decker+ramp;
            
            PARAM.LONE.GAIN = (PARAM.ENRG.E1 - PARAM.ENRG.E0)/cosd(PARAM.LONE.PHAS);
            OUT = LiTrack('FACETpar');
            
            
            % Identify Max and Min of Simulated energy distribution
            e_max = OUT.E.AXIS(256,S20)/100;
            e_min = OUT.E.AXIS(1,S20)/100;
            
            % Find the Max and Min on the YAG energy axis
            [~,iMax] = min(abs(e_max - ENG_AX));
            [~,iMin] = min(abs(e_min - ENG_AX));
            N = iMax - iMin + 1;
            
            % Interpolate the simulated distribution onto the YAG axis
            xx = linspace(1,256,N);
            ES = interp1(OUT.E.HIST(:,S20)/100,xx);
            
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
            figure(f3);
            plot(res_set);
                        
        end
        
    else
        
        PARAM.LONE.GAIN = (PARAM.ENRG.E1 - PARAM.ENRG.E0)/cosd(PARAM.LONE.PHAS);
        OUT = LiTrack('FACETpar');
                
        % Identify Max and Min of Simulated energy distribution
        e_max = OUT.E.AXIS(256,S20)/100;
        e_min = OUT.E.AXIS(1,S20)/100;
        
        % Find the Max and Min on the YAG energy axis
        [~,iMax] = min(abs(e_max - ENG_AX));
        [~,iMin] = min(abs(e_min - ENG_AX));
        N = iMax - iMin + 1;
        
        % Interpolate the simulated distribution onto the YAG axis
        xx = linspace(1,256,N);
        ES = interp1(OUT.E.HIST(:,S20)/100,xx);
        
        % Calculate the centroid and integral of the distribution
        simsum = sum(ES);
        simcent = round(sum((1:N).*ES)/simsum);
        
        % embed interpolated distribution onto energy axis, with
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
        text(-0.05,1.5e-3,num2str(res,'%10.3e'),'fontsize',16);
        text(-0.05,1.75e-3,num2str(OUT.I.PART(S20)*PARAM.INIT.NPART/PARAM.INIT.NESIM,'%10.3e'),'fontsize',16);
        figure(f2);
        plot(OUT.Z.AXIS(:,S20),OUT.Z.HIST(:,S20));

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