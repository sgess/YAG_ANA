clear all;

save_dir = '/Users/sgess/Desktop/E200_1108/';
file_name = 'E200_1108_scan';
savE = 1;

scan = 1;
test = 0;
global PARAM;


E200_1108_param;
decker = -17.4;    
    
if scan == 1
    
    n_out = 2;
    
    % bunch length range
    l_lo = 5.8e-3;
    l_hi = 8.2e-3;
    
    % ramp phase range
    r_lo = -0.5;
    r_hi = +1.5;
    
    % nrtl Phase range
    p_lo = 88.5;
    p_hi = 89.5;
    
    % comp range
    c_lo = 0.0315;
    c_hi = 0.0355;
    
    % number of sample points
    l_el = 8;
    r_el = 8;
    p_el = 8;
    c_el = 8;
    
    if test
        l_el = 1;
        r_el = 1;
        p_el = 1;
        c_el = 1;
    end
    
    % phase and ampl vec
    length= linspace(l_lo,l_hi,l_el);
    ramp  = linspace(r_lo,r_hi,r_el);
    phase = linspace(p_lo,p_hi,p_el);
    NAMPL = linspace(c_lo,c_hi,c_el);
    
    bl_fwhm = zeros(l_el,r_el,p_el,c_el,n_out);
    bl_sig  = zeros(l_el,r_el,p_el,c_el,n_out);
    z_avg   = zeros(l_el,r_el,p_el,c_el,n_out);
    
    e_avg   = zeros(l_el,r_el,p_el,c_el,n_out);
    e_fwhm  = zeros(l_el,r_el,p_el,c_el,n_out);
    e_sig   = zeros(l_el,r_el,p_el,c_el,n_out);
    e_cut   = zeros(l_el,r_el,p_el,c_el,n_out);
    
    I_max   = zeros(l_el,r_el,p_el,c_el,n_out);
    I_sig   = zeros(l_el,r_el,p_el,c_el,n_out);
    
    N       = zeros(l_el,r_el,p_el,c_el,n_out);
    
    bl      = zeros(PARAM.SIMU.BIN,l_el,r_el,p_el,c_el,n_out);
    es      = zeros(PARAM.SIMU.BIN,l_el,r_el,p_el,c_el,n_out);
    
    zz      = zeros(PARAM.SIMU.BIN,l_el,r_el,p_el,c_el,n_out);
    ee      = zeros(PARAM.SIMU.BIN,l_el,r_el,p_el,c_el,n_out);
    
    for i = 1:l_el
        for k = 1:r_el
            for l = 1:p_el;
                for m = 1:c_el;
                    disp(i);
                    
                    
                    
                    PARAM.INIT.SIGZ0= length(i);
                    PARAM.LONE.PHAS = decker + ramp(k);
                    PARAM.NRTL.PHAS = phase(l);
                    PARAM.NRTL.AMPL = NAMPL(m);
                    PARAM.LONE.GAIN = (PARAM.ENRG.E1 - PARAM.ENRG.E0)/cosd(PARAM.LONE.PHAS);
                    
                    OUT = LiTrack('FACETpar');
                    
                    bl_fwhm(i,k,l,m,:) = OUT.Z.FWHM;
                    bl_sig(i,k,l,m,:)  = OUT.Z.SIG;
                    z_avg(i,k,l,m,:)   = OUT.Z.AVG;
                    
                    e_avg(i,k,l,m,:)   = OUT.E.AVG;
                    e_fwhm(i,k,l,m,:)  = OUT.E.FWHM;
                    e_sig(i,k,l,m,:)   = OUT.E.SIG;
                    
                    I_max(i,k,l,m,:)   = OUT.I.PEAK;
                    I_sig(i,k,l,m,:)   = OUT.I.SIG;
                    
                    N(i,k,l,m,:)       = OUT.I.PART;
                    
                    for o = 1:n_out
                        
                        bl(:,i,k,l,m,o) = OUT.Z.HIST(:,o);
                        es(:,i,k,l,m,o) = OUT.E.HIST(:,o);
                        zz(:,i,k,l,m,o) = OUT.Z.AXIS(:,o);
                        ee(:,i,k,l,m,o) = OUT.E.AXIS(:,o);
                        
                    end
                end
            end
        end
    end
    
    if savE
        save([save_dir file_name '.mat'],'PARAM','bl_fwhm','bl_sig','z_avg',...
            'length','ramp','phase','NAMPL','decker',...
            'e_avg','e_fwhm','e_sig','I_max','I_sig','N','bl','es','zz','ee');
    end

end