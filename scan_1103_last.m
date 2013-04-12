clear all;

save_dir = '/Users/sgess/Desktop/';
file_name = 'E200_1103_retry';
savE = 1;

scan = 1;
test = 0;
global PARAM;
param_tcav;
    
    
if scan == 1
    
    n_out = 3;
    
    % particle range
    n_lo = 1.8e10;
    n_hi = 2.10e10;
    
    % comp range
    c_lo = 0.0370;
    c_hi = 0.0410;
    
    %2-10 range
    tw_lo = -26;
    tw_hi = -22;
    
    %ll-20 rang
    el_lo = -3;
    el_hi = 3;
    
    % number of sample points
    n_el = 8;
    c_el = 8;
    tw_el = 8;
    el_el = 8;
    
    if test
        n_el = 1;
        c_el = 1;
        tw_el = 1;
        el_el = 1;
    end
    
    % phase and ampl vec
    part  = linspace(n_lo,n_hi,n_el);
    NAMPL = linspace(c_lo,c_hi,c_el);
    LITW = linspace(tw_lo,tw_hi,tw_el);
    LIEL = linspace(el_lo,el_hi,el_el);
    
    bl_fwhm = zeros(n_el,c_el,tw_el,el_el,n_out);
    bl_sig  = zeros(n_el,c_el,tw_el,el_el,n_out);
    z_avg   = zeros(n_el,c_el,tw_el,el_el,n_out);
    
    e_avg   = zeros(n_el,c_el,tw_el,el_el,n_out);
    e_fwhm  = zeros(n_el,c_el,tw_el,el_el,n_out);
    e_sig   = zeros(n_el,c_el,tw_el,el_el,n_out);
    e_cut   = zeros(n_el,c_el,tw_el,el_el,n_out);
    
    I_max   = zeros(n_el,c_el,tw_el,el_el,n_out);
    I_sig   = zeros(n_el,c_el,tw_el,el_el,n_out);
    
    N       = zeros(n_el,c_el,tw_el,el_el,n_out);
    
    bl      = zeros(PARAM.SIMU.BIN,n_el,c_el,tw_el,el_el,n_out);
    es      = zeros(PARAM.SIMU.BIN,n_el,c_el,tw_el,el_el,n_out);
    
    zz      = zeros(PARAM.SIMU.BIN,n_el,c_el,tw_el,el_el,n_out);
    ee      = zeros(PARAM.SIMU.BIN,n_el,c_el,tw_el,el_el,n_out);
    
    
    for i = 1:n_el
        for j = 1:c_el
            for k = 1:tw_el
                for l = 1:el_el;
            

            
                        PARAM.INIT.NPART= part(i);
                        PARAM.NRTL.AMPL = NAMPL(j);
                        PARAM.LONE.PHAS = LITW(k);
                        PARAM.LTWO.PHAS = LIEL(l);
                        PARAM.LONE.GAIN = (PARAM.ENRG.E1 - PARAM.ENRG.E0)/cosd(PARAM.LONE.PHAS);
                        PARAM.LTWO.GAIN = (PARAM.ENRG.E2 - PARAM.ENRG.E1)/cosd(PARAM.LTWO.PHAS);
                        
                        OUT = LiTrack('FACETpar');
                        
                        bl_fwhm(i,j,k,l,:) = OUT.Z.FWHM;
                        bl_sig(i,j,k,l,:)  = OUT.Z.SIG;
                        z_avg(i,j,k,l,:)   = OUT.Z.AVG;
                        
                        e_avg(i,j,k,l,:)   = OUT.E.AVG;
                        e_fwhm(i,j,k,l,:)  = OUT.E.FWHM;
                        e_sig(i,j,k,l,:)   = OUT.E.SIG;
                        
                        I_max(i,j,k,l,:)   = OUT.I.PEAK;
                        I_sig(i,j,k,l,:)   = OUT.I.SIG;
                        
                        N(i,j,k,l,:)       = OUT.I.PART;
                        
                        for o = 1:n_out
                            
                            bl(:,i,j,k,l,o) = OUT.Z.HIST(:,o);
                            es(:,i,j,k,l,o) = OUT.E.HIST(:,o);
                            zz(:,i,j,k,l,o) = OUT.Z.AXIS(:,o);
                            ee(:,i,j,k,l,o) = OUT.E.AXIS(:,o);
                            
                        end
                    
                end
            end
        end
    end
    
    if savE
        save([save_dir file_name '.mat'],'PARAM','bl_fwhm','bl_sig','z_avg',...
            'part','NAMPL','LITW','LIEL',...
            'e_avg','e_fwhm','e_sig','I_max','I_sig','N','bl','es','zz','ee');
    end

end