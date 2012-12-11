clear all;

%arg
%data_dir = '/Users/sgess/Desktop/data/E200_DATA/E200_1443/';
%data_dir = '/Users/sgess/Desktop/data/E200_DATA/E200_1138/';

%save_dir = '/Users/sgess/Desktop/plots/E200/E200_1443/';
%save_dir = '/Users/sgess/Desktop/plots/E200/E200_1138/';

%sim_dir = '/Users/sgess/Desktop/data/LiTrack_scans/';

%mac69
data_dir = '/Users/sgess/Desktop/FACET/2012/DATA/E200_1443/';
%data_dir = '/Users/sgess/Desktop/FACET/2012/DATA/E200_1138/';

save_dir = '/Users/sgess/Desktop/FACET/PLOTS/E200_1443/';
%save_dir = '/Users/sgess/Desktop/FACET/PLOTS/E200_1138/';

sim_dir = '/Users/sgess/Desktop/FACET/2012/DATA/LiTrackScans/';

%1443
save_name  = 'NRTL_1.mat';
sim_name   = 'NRTL_scan.mat';
slim_name  = 'E200_1443_slim.mat';
state_name = 'E200_1443_State.mat';
disp_name  = 'facet_dispersion-SCAVENGY.MKB-2012-07-03-094452.mat';

%1138
% save_name  = '1138_test.mat';
% sim_name   = '5mm_scan.mat';
% slim_name  = 'E200_1138_Slim.mat';
% state_name = 'E200_1138_State.mat';
% disp_name  = 'facet_dispersion-SCAVENGY.MKB-2012-07-01-043249.mat';

load([data_dir slim_name]);
load([data_dir state_name]);
load([data_dir disp_name]);

do_disp = 1;
do_y = 0;
plot_disp = 0;
view_yag = 0;
do_plot = 0;
compare = 1;
savE = 1;

if do_disp
    [eta_yag, beam_size] = DISP_ANA(data,plot_disp,do_y,savE,save_dir);
end

%number of shots
nShots = length(good_data);

% NRTL stuff
NRTL_phas = zeros(1,nShots);
NRTL_ampl = zeros(1,nShots);

% Pulse ID stuff
pulseID = zeros(1,nShots);
aidaPID = zeros(1,nShots);
profPID = zeros(1,nShots);

% BPM stuff
BPM_2445_X = zeros(1,nShots);
BPM_2050_X = zeros(1,nShots);

BPM_2445_Y = zeros(1,nShots);
BPM_2050_Y = zeros(1,nShots);

% YAG Resolution
RES = good_data(1).YAGS_LI20_2432.prof_RES;

% YAG pixels
PIX = good_data(1).YAGS_LI20_2432.prof_roiXN;

% YAG Axis
%YAG_AX = RES*(PIX:-1:1) - RES*PIX/2;
YAG_AX = RES*(1:PIX) - RES*PIX/2;
ENG_AX = YAG_AX/(eta_yag*1e3);

% YAG Lineout
lo_line = 150;
hi_line = 175;
LINE = uint16(zeros(PIX,nShots));
cutLINE = uint16(zeros(PIX,nShots));
center = zeros(PIX,nShots);

% YAG FWHM
fwhm = zeros(1,nShots);
lo = zeros(1,nShots);
hi = zeros(1,nShots);
m_fwhm = zeros(1,nShots);
m_lo = zeros(1,nShots);
m_hi = zeros(1,nShots);

% YAG centroid
P_cent = zeros(1,nShots);
E_cent = zeros(1,nShots);
cutcent = zeros(1,nShots);
indcent = zeros(1,nShots);


% Windowing and indexing variables
win_min = 10000*ones(1,nShots);
win_max = 10000*ones(1,nShots);
i_min = zeros(1,nShots);
i_max = (length(LINE)+1)*ones(1,nShots);
i_vec = 1:PIX;
lo_win = 0;
hi_win = 0;

for j = 1:nShots
    
    % Pulse ID stuff
    pulseID(j) = good_data(j).PulseID;
    aidaPID(j) = good_data(j).aida.pulse_id;
    profPID(j) = good_data(j).YAGS_LI20_2432.prof_pid;
    
    
    % NRTL stuff
    NRTL_phas(j) = good_data(j).aida.klys.phase;
    %NRTL_ampl(j) = good_data(j).DR13_AMPL_11_VACT.val;
    
    
    % BPM stuff
    BPM_2445_X(j) = good_data(j).aida.bpms(1).x;
    BPM_2050_X(j) = good_data(j).aida.bpms(16).x;
    BPM_2445_Y(j) = good_data(j).aida.bpms(1).y;
    BPM_2050_Y(j) = good_data(j).aida.bpms(16).y;
    
    
    % YAG image alignment, centering, fwhm
    IMG_1     = rot90(good_data(j).YAGS_LI20_2432.img,2)';
    LINE(:,j) = mean(IMG_1(lo_line:hi_line,:),1);
    P_cent(j) = sum(YAG_AX.*double(LINE(:,j))')/sum(double(LINE(:,j)));
    E_cent(j) = sum(ENG_AX.*double(LINE(:,j))')/sum(double(LINE(:,j)));
    [fwhm(j),lo(j),hi(j)] = FWHM(ENG_AX,double(LINE(:,j)));
    
    %window the spectrum to cut off noise tails
    lo_win = 0;
    hi_win = 0;
    for i=11:(length(LINE(:,j))/2)
        k = length(LINE(:,j)) - i + 1;
        
        lo_win = sum(LINE((i-10):(i+10),j));
        hi_win = sum(LINE((k-10):(k+10),j)); 
        if lo_win < win_min(j)
            win_min(j) = lo_win;
            i_min(j) = i;
        end
        if hi_win < win_max(j)
            win_max(j) = hi_win;
            i_max(j) = k;
        end
        
    end

    %linout minus the BG
    cutLINE(:,j) = LINE(:,j).*uint16((i_vec > i_min(j) & i_vec < i_max(j)))';
    cutcent(j)   = sum(ENG_AX.*double(cutLINE(:,j))')/sum(double(cutLINE(:,j)));
    indcent(j)   = round(sum((1:PIX).*double(cutLINE(:,j))')/sum(double(cutLINE(:,j))));
    if indcent(j) < round(PIX/2)
        center(round(PIX/2-indcent(j)):PIX,j) = cutLINE(1:round(PIX/2+indcent(j)+1),j);
    else
        center(1:round(PIX/2+indcent(j)+1),j) = cutLINE(round(PIX/2-indcent(j)):PIX,j);
    end
    [m_fwhm(j),m_lo(j),m_hi(j)] = FWHM(ENG_AX,center(:,j));
    
    if view_yag
        s1 = 10; 
        figure(s1); 
        subplot(2,1,1); 
        imagesc(IMG_1); 
        subplot(2,1,2); 
        plot(ENG_AX,cutLINE(:,j),ENG_AX(i_min(j)),...
            cutLINE(i_min(j),j),'r*',...
            ENG_AX(i_max(j)),cutLINE(i_max(j),j),'g*',...
            ENG_AX(indcent(j)),cutLINE(indcent(j),j),'m*',...
            ENG_AX(lo(j)),cutLINE(lo(j),j),'c*',...
            ENG_AX(hi(j)),cutLINE(hi(j),j),'k*'); 
        pause;
    end
end

% area under spectrum
LINESUM = sum(center,1);

%nrtl compressor phase offset
off = 90 - median(NRTL_phas); 

if compare

    load([sim_dir sim_name]);
    
    %interpolated energy spectrum
    e_interp = zeros(PIX,64,64);
    
    %convolved energy spectrum
    conterp = zeros(PIX,64,64);
    
    %fwhm vals
    e_fwhm = zeros(64,64);
    e_lo   = zeros(64,64);
    e_hi   = zeros(64,64);
    c_fwhm = zeros(64,64);
    c_lo   = zeros(64,64);
    c_hi   = zeros(64,64);
    
    % derivative of convolved spectrum
    DCON = ones(PIX,64,64);
    
    %residual
    e_res = zeros(1,length(ENG_AX));
    ef_res = zeros(1,length(ENG_AX));
    
    %convolution residual
    co_res = zeros(1,length(ENG_AX));
    cf_res = zeros(1,length(ENG_AX));
    
    %derivative residual
    d_res = zeros(1,length(ENG_AX));
    df_res = zeros(1,length(ENG_AX));
    
    %various residual measures
    RES = zeros(64,64,90);
    ABS = zeros(64,64,90);
    RFN = zeros(64,64,90);
    RFS = zeros(64,64,90);
    
    CON = zeros(64,64,90);
    CBS = zeros(64,64,90);
    CFN = zeros(64,64,90);
    CFS = zeros(64,64,90);
    
    DES = zeros(64,64,90);
    DBS = zeros(64,64,90);
    DFN = zeros(64,64,90);
    DFS = zeros(64,64,90);
    
    %gaussian blurring
    e_blur = beam_size/eta_yag;
    g = exp(-(ENG_AX.^2)/(2*e_blur^2));    
    g = g/sum(g);
    
    % Blur and interp
    for i=1:64
        for j=1:64
            
            % Identify Max and Min of Simulated energy distribution
            e_max = ee(256,i,j,6)/100;
            e_min = ee(1,i,j,6)/100;
            
            % Find the Max and Min on the YAG energy axis
            [~,iMax] = min(abs(e_max - ENG_AX));
            [~,iMin] = min(abs(e_min - ENG_AX));
            N = iMax - iMin + 1;
            
            % Interpolate the simulated distribution onto the YAG axis
            xx = linspace(1,256,N);
            ES = interp1(es(:,i,j,6)/100,xx);
            
            % Calculate the centroid and integral of the distribution
            simsum = sum(ES);
            simcent = round(sum((1:N).*ES)/simsum);
            
            % embed interpolated distribution onto energy axis, with
            % centroid of distribution at delta = 0
            e_interp(round(PIX/2-simcent):round(PIX/2-simcent+N-1),i,j) = ES/simsum;
            
            % convolve energy spread with gaussian
            yy = conv(ES,g);
            
            % find centroid of convolution, convolution is a vector
            % that is N + PIX - 1 long
            consum = sum(yy);
            concent = round(sum((1:length(yy)).*yy)/consum);
            
            % project convolved distribution onto energy axis, with
            % centroid of distribution at delta = 0
            conterp(:,i,j) = yy((concent-round(PIX/2)):(concent+round(PIX/2)-1))/consum;
            
            %derivative of convolution
            DCON(1:(PIX-1),i,j) = 1 + abs(diff(conterp(:,i,j))/(ENG_AX(2)-ENG_AX(1)));
            
            %fwhm of energy and convolution
            [e_fwhm(i,j),e_lo(i,j),e_hi(i,j)] = FWHM(ENG_AX,e_interp(:,i,j));
            [c_fwhm(i,j),c_lo(i,j),c_hi(i,j)] = FWHM(ENG_AX,conterp(:,i,j));
        end
    end
    
    
    
    for k=1:nShots
        
        %disp(k);
        
        for i=1:64
            for j=1:64
                
                s_temp = zeros(PIX,1);
                d_temp = ones(PIX,1);
                off = c_lo(i,j) - m_lo(k);
                if off > 0
                    s_temp(1:(PIX-off)) = conterp(off:(PIX-1),i,j);
                    d_temp(1:(PIX-off)) = DCON(off:(PIX-1),i,j);
                else
                    s_temp((-off + 1):PIX) = conterp(1:(PIX+off),i,j);
                    d_temp((-off + 1):PIX) = DCON(1:(PIX+off),i,j);
                end
                
                e_temp = zeros(PIX,1);
                offe = e_lo(i,j) - m_lo(k);
                if offe > 0
                    e_temp(1:(PIX-offe)) = e_interp(offe:(PIX-1),i,j);
                else
                    e_temp((-offe + 1):PIX) = conterp(1:(PIX+offe),i,j);
                end
               
                
                if do_plot
                    %plot(ENG_AX,e_temp,ENG_AX,con_temp,ENG_AX,double(cutLINE(:,k))/LINESUM(k));
                    %plot(ENG_AX,conterp(:,i,j),ENG_AX,center(:,k)/LINESUM(k));
                    plot(ENG_AX,s_temp,ENG_AX,center(:,k)/LINESUM(k));
                    xlabel('\delta','fontsize',16);
                    axis([-0.05 0.05 0 3.5e-3]);
                    pause;
                end
                
                % Calculate residue
                e_res = e_interp(:,i,j) - center(:,k)/LINESUM(k);
                ef_res = e_temp - center(:,k)/LINESUM(k);
                co_res = conterp(:,i,j) - center(:,k)/LINESUM(k);
                cf_res = s_temp - center(:,k)/LINESUM(k);
                d_res = (conterp(:,i,j) - center(:,k)/LINESUM(k))./DCON(:,i,j);
                df_res = (s_temp - center(:,k)/LINESUM(k))./d_temp;
                
                RES(i,j,k) = sum(e_res.*e_res);
                ABS(i,j,k) = sum(abs(e_res));
                RFN(i,j,k) = sum(ef_res.*ef_res);
                RFS(i,j,k) = sum(abs(ef_res));
                
                CON(i,j,k) = sum(co_res.*co_res);
                CBS(i,j,k) = sum(abs(co_res));
                CFN(i,j,k) = sum(cf_res.*cf_res);
                CFS(i,j,k) = sum(abs(cf_res));
                
                DES(i,j,k) = sum(d_res.*d_res);
                DBS(i,j,k) = sum(abs(d_res));
                DFN(i,j,k) = sum(df_res.*df_res);
                DFS(i,j,k) = sum(abs(df_res));
                
            end
        end
    end
    
    if savE; save([data_dir save_name],'RES','ABS','RFN','RFS','CON','CBS','CFN','CFS','DES','DBS','DFN','D FS','e_interp','conterp','DCON','ENG_AX','LINESUM'); end;

end