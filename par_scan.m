clear all;

save_dir = '/Users/sgess/Desktop/data/LiTrack_scans/MEGASCAN/';
%save_dir = '/Users/sgess/Desktop/FACET/2012/DATA/LiTrackScans/MEGASCAN/';
savE = 1;

test = 0;

%global PARAM;
SJG_param;

n_out = 2;

%To be scanned
PARAM.INIT.SIGZ0 = 6.0E-3;  % RMS bunch length (m)
PARAM.INIT.SIGD0 = 8.00E-4; % RMS energy spread
PARAM.INIT.NPART = 2.2E10;  % Number of electrons per bunch
PARAM.INIT.ASYM  = -0.280;  % The Holtzapple skew

PARAM.NRTL.AMPL  = 0.04058; % RTL compressor ampl
PARAM.NRTL.PHAS  = 90;      % RTL compressor phase (deg)
PARAM.LONE.PHAS = -21.46;   % 2-10 phase
PARAM.LTWO.PHAS  = 0;       % 11-20 phase


% Init bunch length
init_z_lo = 5.6E-3;
init_z_hi = 10.4E-3;
iz_el = 16;
init_z = linspace(init_z_lo,init_z_hi,iz_el);

% Init energy spread
init_d_lo = 6E-4;
init_d_hi = 10E-4;
id_el = 16;
init_d = linspace(init_d_lo,init_d_hi,id_el);

% Init particles
init_p_lo = 1.6E10;
init_p_hi = 2.8E10;
ip_el = 16;
init_p = linspace(init_p_lo,init_p_hi,ip_el);

% Init asym
init_a_lo = -0.32;
init_a_hi = -0.08;
ia_el = 8;
init_a = linspace(init_a_lo,init_a_hi,ia_el);

% NRTL Phase range
nrtl_p_lo = 87.9;
nrtl_p_hi = 91.1;
np_el = 16;
nrtl_p = linspace(nrtl_p_lo,nrtl_p_hi,np_el);

% NRTL Ampl range
nrtl_a_lo = 0.0394;
nrtl_a_hi = 0.0426;
na_el = 16;
nrtl_a = linspace(nrtl_a_lo,nrtl_a_hi,na_el);

% S2-10 Phase range
s210_p_lo = -24.4;
s210_p_hi = -18.;
s210_el = 16;
s210_p = linspace(s210_p_lo,s210_p_hi,s210_el);

% S11-20 Phase range
s1120_p_lo = -6;
s1120_p_hi = 2;
s1120_el = 4;
s1120_p = linspace(s1120_p_lo,s1120_p_hi,s1120_el);

if test
  iz_el = 1; 
  id_el = 1;
  ip_el = 1;
  ia_el = 1;
  np_el = 1;
  s210_el = 1;
  s1120_el = 1;
end

% loop over initial bunch length
for a = 1:iz_el
    PARAM.INIT.SIGZ0 = init_z(a);
    % loop over initial energy spread
    for b = 1:id_el
        PARAM.INIT.SIGD0 = init_d(b);
        % loop over initial number of particles
        for c = 1:ip_el
            PARAM.INIT.NPART = init_p(c);
            % loop over inital asymetry
            for d = 1:ia_el
                PARAM.INIT.ASYM = init_a(d);
                % loop over 11-20 phase
                for e = 1:s1120_el
                    PARAM.LTWO.PHAS = s1120_p(e);
                    
                    % Sim data
                    bl_fwhm = zeros(s210_el,np_el,na_el,n_out);
                    bl_sig  = zeros(s210_el,np_el,na_el,n_out);
                    z_avg   = zeros(s210_el,np_el,na_el,n_out);
                    
                    e_avg   = zeros(s210_el,np_el,na_el,n_out);
                    e_fwhm  = zeros(s210_el,np_el,na_el,n_out);
                    e_sig   = zeros(s210_el,np_el,na_el,n_out);
                    e_cut   = zeros(s210_el,np_el,na_el,n_out);
                    
                    I_max   = zeros(s210_el,np_el,na_el,n_out);
                    I_sig   = zeros(s210_el,np_el,na_el,n_out);
                    
                    N       = uint16(zeros(s210_el,np_el,na_el,n_out));
                    
                    bl      = uint16(zeros(PARAM.SIMU.BIN,s210_el,np_el,na_el,n_out));
                    es      = uint16(zeros(PARAM.SIMU.BIN,s210_el,np_el,na_el,n_out));
                    
                    zz      = zeros(PARAM.SIMU.BIN,s210_el,np_el,na_el,n_out);
                    ee      = zeros(PARAM.SIMU.BIN,s210_el,np_el,na_el,n_out);
                    
                    % loop over 2-10 phase
                    for f = 1:s210_el
                        PARAM.LONE.PHAS = s210_p(f);
                        PARAM.LONE.GAIN = (PARAM.ENRG.E1 - PARAM.ENRG.E0)/cosd(PARAM.LONE.PHAS);
                        % loop over nrtl phase
                        for g = 1:np_el
                            PARAM.NRTL.PHAS = nrtl_p(g);

                            try
                                matlabpool;
                                
                                % loop over nrtl amplitude
                                parfor h = 1:na_el
                            
                                    %PARAM.NRTL.AMPL = nrtl_a(h);
                                    
                                    OUT = LiTrack_PAR('FACETpar4',PARAM,nrtl_a(h));
                                    
                                    bl_fwhm(f,g,h,:) = OUT.Z.FWHM;
                                    bl_sig(f,g,h,:)  = OUT.Z.SIG;
                                    z_avg(f,g,h,:)   = OUT.Z.AVG;
                                    
                                    e_avg(f,g,h,:)   = OUT.E.AVG;
                                    e_fwhm(f,g,h,:)  = OUT.E.FWHM;
                                    e_sig(f,g,h,:)   = OUT.E.SIG;
                                    
                                    I_max(f,g,h,:)   = OUT.I.PEAK;
                                    I_sig(f,g,h,:)   = OUT.I.SIG;
                                    
                                    N(f,g,h,:)       = uint16(OUT.I.PART);
                                    
                                    for o = 1:n_out
                                        
                                        bl(:,f,g,h,o) = uint16(OUT.Z.HIST(:,o));
                                        es(:,f,g,h,o) = uint16(OUT.E.HIST(:,o));
                                        zz(:,f,g,h,o) = OUT.Z.AXIS(:,o);
                                        ee(:,f,g,h,o) = OUT.E.AXIS(:,o);
                                        
                                    end
                                  
                                % end loop over nrtl amplitude    
                                end
                                
                            catch err
                                
                                for h = 1:na_el
                                
                                    PARAM.NRTL.AMPL = nrtl_a(h);
                                    
                                    OUT = LiTrack_PAR('FACETpar4',PARAM,nrtl_a(h));
                                    
                                    bl_fwhm(f,g,h,:) = OUT.Z.FWHM;
                                    bl_sig(f,g,h,:)  = OUT.Z.SIG;
                                    z_avg(f,g,h,:)   = OUT.Z.AVG;
                                    
                                    e_avg(f,g,h,:)   = OUT.E.AVG;
                                    e_fwhm(f,g,h,:)  = OUT.E.FWHM;
                                    e_sig(f,g,h,:)   = OUT.E.SIG;
                                    
                                    I_max(f,g,h,:)   = OUT.I.PEAK;
                                    I_sig(f,g,h,:)   = OUT.I.SIG;
                                    
                                    N(f,g,h,:)       = uint16(OUT.I.PART);
                                    
                                    for o = 1:n_out
                                        
                                        bl(:,f,g,h,o) = uint16(OUT.Z.HIST(:,o));
                                        es(:,f,g,h,o) = uint16(OUT.E.HIST(:,o));
                                        zz(:,f,g,h,o) = OUT.Z.AXIS(:,o);
                                        ee(:,f,g,h,o) = OUT.E.AXIS(:,o);
                                        
                                    end
                                    
                                % end loop over nrtl amplitude    
                                end
                            % end PARALLEL TRY    
                            end
                        % end loop over nrtl phase    
                        end
                    % end loop over 2-10 phase    
                    end
                    
                    if savE
                        file_name = ['test_' num2str(a) '_' num2str(b) '_' num2str(c) '_' num2str(d) '_' num2str(e)];
                        save([save_dir file_name '.mat'],'PARAM','init_z','init_d','init_p','init_a',...
                            'nrtl_p','nrtl_a','s210_p','s1120_p','bl_fwhm','bl_sig','z_avg',...
                            'e_avg','e_fwhm','e_sig','e_cut','I_max','I_sig','N','bl','es','zz','ee');
                    end
                    
                % end loop over 11-20 phase    
                end
            % end loop over inital asymetry    
            end
        % end loop over initial number of particles    
        end
    % end loop over initial energy spread    
    end
% end loop over initial bunch length                                        
end
