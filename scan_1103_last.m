clear all;

%save_dir = '/Users/sgess/Desktop/';
file_name = 'fuck';
savE = 1;

scan = 1;
test = 0;
global PARAM;
param_tcav;
    
global A;
A = load('slac.dat');

if scan == 1
    
    n_out = 3;
    
    % particle range
    n_lo = 1.65e10;
    n_hi = 2.05e10;
    
    % comp phase range
    c_lo = 88.0;
    c_hi = 92.0;
    
    %2-10 range
    tw_lo = -26;
    tw_hi = -22;
    
    %ll-20 rang
    el_lo = -4;
    el_hi = 4;
    
    % number of sample points
    n_el = 10;
    c_el = 10;
    tw_el = 10;
    el_el = 10;
    
    if test
        n_el = 1;
        c_el = 1;
        tw_el = 1;
        el_el = 1;
    end
    
    % phase and ampl vec
    PART  = linspace(n_lo,n_hi,n_el);
    PHAS = linspace(c_lo,c_hi,c_el);
    LITW = linspace(tw_lo,tw_hi,tw_el);
    LIEL = linspace(el_lo,el_hi,el_el);
    
    bl_fwhm = zeros(n_el,c_el,tw_el,el_el);
    %bl_sig  = zeros(n_el,c_el,tw_el,el_el);
    %z_avg   = zeros(n_el,c_el,tw_el,el_el);
    
    e_avg   = zeros(n_el,c_el,tw_el,el_el);
    e_fwhm  = zeros(n_el,c_el,tw_el,el_el);
    %e_sig   = zeros(n_el,c_el,tw_el,el_el);
    e_cut   = zeros(n_el,c_el,tw_el,el_el);
    
    I_max   = zeros(n_el,c_el,tw_el,el_el);
    %I_sig   = zeros(n_el,c_el,tw_el,el_el);
    
    N       = zeros(n_el,c_el,tw_el,el_el);
    
    bl      = zeros(PARAM.SIMU.BIN,n_el,c_el,tw_el,el_el);
    es      = zeros(PARAM.SIMU.BIN,n_el,c_el,tw_el,el_el);
    sy      = zeros(PARAM.SIMU.BIN,n_el,c_el,tw_el,el_el);
    
    zz      = zeros(PARAM.SIMU.BIN,n_el,c_el,tw_el,el_el);
    ee      = zeros(PARAM.SIMU.BIN,n_el,c_el,tw_el,el_el);
    xx      = zeros(PARAM.SIMU.BIN,n_el,c_el,tw_el,el_el);
     
    
    for i = 1:n_el
        for j = 1:c_el
            for k = 1:tw_el
                for l = 1:el_el;
            

            
                        PARAM.INIT.NPART = PART(i);
                        PARAM.NRTL.PHAS  = PHAS(j);
                        PARAM.LONE.PHAS  = LITW(k);
                        PARAM.LTWO.PHAS  = LIEL(l);
                        PARAM.LONE.GAIN  = (PARAM.ENRG.E1 - PARAM.ENRG.E0)/cosd(PARAM.LONE.PHAS);
                        PARAM.LTWO.GAIN  = (PARAM.ENRG.E2 - PARAM.ENRG.E1)/cosd(PARAM.LTWO.PHAS);
                        
                        OUT = LiTrackOpt('FACETpar');
                        
                        bl_fwhm(i,j,k,l) = OUT.Z.FWHM(n_out);
                        %bl_sig(i,j,k,l)  = OUT.Z.SIG(n_out);
                        %z_avg(i,j,k,l)   = OUT.Z.AVG(n_out);
                        
                        e_avg(i,j,k,l)   = OUT.E.AVG(n_out);
                        e_fwhm(i,j,k,l)  = OUT.E.FWHM(n_out);
                        %e_sig(i,j,k,l)   = OUT.E.SIG(n_out);
                        
                        I_max(i,j,k,l)   = OUT.I.PEAK(n_out);
                        %I_sig(i,j,k,l)   = OUT.I.SIG(n_out);
                        
                        N(i,j,k,l)       = OUT.I.PART(n_out);
                        
                        
                            
                            bl(:,i,j,k,l) = OUT.Z.HIST(:,n_out);
                            es(:,i,j,k,l) = OUT.E.HIST(:,n_out);
                            zz(:,i,j,k,l) = OUT.Z.AXIS(:,n_out);
                            ee(:,i,j,k,l) = OUT.E.AXIS(:,n_out);
                            
                        
                        
                        sy(:,i,j,k,l) = OUT.X.HIST;
                        xx(:,i,j,k,l) = OUT.X.AXIS;
                    
                end
            end
        end
    end
    
    if savE
        save([file_name '.mat'],'PARAM','bl_fwhm',...
            'PART','PHAS','LITW','LIEL',...
            'e_avg','e_fwhm','I_max','N','bl','es','zz','ee','sy','xx');
    end

end