clear all;

scan = 1;

global PARAM;

%MJH_param;
MDW_param;


if scan == 0
    
    LiTrack('FACETpar');
    %LiTrack('FACETMJH2');
    
elseif scan == 1
    
    p_lo = -20.4;
    p_hi = -22.0;
    n_lo = 0.0390;
    n_hi = 0.0454;
    p_el = 64;
    n_el = 64;
    phase = linspace(p_lo,p_hi,p_el);
    NAMPL = linspace(n_lo,n_hi,n_el);
    
    chrp = zeros(1,p_el);
    phas = zeros(1,p_el);
    
    bl_fwhm = zeros(p_el,n_el,3);
    bl_sig  = zeros(p_el,n_el,3);
    z_avg   = zeros(p_el,n_el,3);
    
    e_avg   = zeros(p_el,n_el,3);
    e_fwhm  = zeros(p_el,n_el,3);
    e_sig   = zeros(p_el,n_el,3);
    e_cut   = zeros(p_el,n_el,3);
    
    I_max   = zeros(p_el,n_el,3);
    I_sig   = zeros(p_el,n_el,3);
    
    N       = zeros(p_el,n_el,3);
    
    bl      = zeros(200,p_el,n_el,3);
    es      = zeros(200,p_el,n_el,3);
    
    zz      = zeros(200,p_el,n_el,3);
    ee      = zeros(200,p_el,n_el,3);
    
    tot = p_el*n_el;
    for i = 1:p_el
        for j = 1:n_el
            
            prog = 100*((i-1)*p_el + j)/tot;
            disp(['Progress: ' num2str(prog,'%.2f') '%']);
            
            
            PARAM.LONE.PHAS = phase(i);
            PARAM.NRTL.AMPL = NAMPL(j);
            PARAM.LONE.GAIN  = (PARAM.ENRG.E1 - PARAM.ENRG.E0)/cosd(PARAM.LONE.PHAS);
            chrp(i) = -PARAM.LONE.GAIN*tand(PARAM.LONE.PHAS);
            phas(i) = PARAM.LONE.PHAS;
            
            OUT = LiTrack('FACETpar');
            
            bl_fwhm(i,j,:) = OUT.Z.FWHM;
            bl_sig(i,j,:) = OUT.Z.SIG;
            z_avg(i,j,:) = OUT.Z.AVG;
            
            e_avg(i,j,:) = OUT.E.AVG;
            e_fwhm(i,j,:) = OUT.E.FWHM;
            e_sig(i,j,:) = OUT.E.SIG;
            
            I_max(i,j,:) = OUT.I.PEAK;
            I_sig(i,j,:) = OUT.I.SIG;
            
            N(i,j,:) = OUT.I.PART;
            
            bl(:,i,j,1) = OUT.Z.HIST(:,1);
            bl(:,i,j,2) = OUT.Z.HIST(:,2);
            bl(:,i,j,3) = OUT.Z.HIST(:,3);
            
            es(:,i,j,1) = OUT.E.HIST(:,1);
            es(:,i,j,2) = OUT.E.HIST(:,2);
            es(:,i,j,3) = OUT.E.HIST(:,3);
            
            zz(:,i,j,1) = OUT.Z.AXIS(:,1);
            zz(:,i,j,2) = OUT.Z.AXIS(:,2);
            zz(:,i,j,3) = OUT.Z.AXIS(:,3);
            
            ee(:,i,j,1) = OUT.E.AXIS(:,1);
            ee(:,i,j,2) = OUT.E.AXIS(:,2);
            ee(:,i,j,3) = OUT.E.AXIS(:,3);
            
        end
    end
save('simp_scan.mat');
end