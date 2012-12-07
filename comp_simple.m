%clear all;

scan = 0;

global PARAM;

%MJH_param;
%MDW_param;
%SJG_param;
temp_param


if scan == 0
    
    PARAM.NRTL.AMPL = 0.0406;
    PARAM.LONE.PHAS = -21.86;
    PARAM.NRTL.PHAS = 88.86;
    %PARAM.NRTL.AMPL = 0.04154;
    %PARAM.LONE.PHAS = -21.38;
    
    
    %PARAM.NRTL.AMPL = 0.04175;
    %PARAM.LONE.PHAS = -22.25;
    
    PARAM.LONE.GAIN = (PARAM.ENRG.E1 - PARAM.ENRG.E0)/cosd(PARAM.LONE.PHAS);
    OUT = LiTrack('FACETpar');
    %LiTrack('FACETMJH2');
    plot(OUT.E.HIST(:,6));
    
elseif scan == 1
    
    n_out = 6;
    
    % Phase range
    p_lo = -20.95;
    p_hi = -22.55;
    
    % comp range
    n_lo = 0.0389;
    n_hi = 0.0421;
    
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
            
            
            PARAM.LONE.PHAS = phase(i);
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
save('5mm_scan.mat');
end