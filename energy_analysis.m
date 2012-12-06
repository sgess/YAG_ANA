clear all;

%data_dir = '/Users/sgess/Desktop/data/E200_DATA/E200_1443/';
data_dir = '/Users/sgess/Desktop/data/E200_DATA/E200_1138/';

%data_dir = '/Users/sgess/Desktop/FACET/2012/DATA/E200_1443/';

%save_dir = '/Users/sgess/Desktop/plots/E200/E200_1443/';
save_dir = '/Users/sgess/Desktop/plots/E200/E200_1138/';

%save_dir = '/Users/sgess/Desktop/FACET/PLOTS/E200_1443/';


sim_dir = '/Users/sgess/Desktop/data/LiTrack_scans/';

%sim_dir = '/Users/sgess/Desktop/FACET/2012/DATA/LiTrackScans/';

%1443
% save_name  = 'ABS_5mm_hi.mat';
% sim_name   = '5mm_scan.mat';
% slim_name  = 'E200_1443_slim.mat';
% state_name = 'E200_1443_State.mat';
% disp_name  = 'facet_dispersion-SCAVENGY.MKB-2012-07-03-094452.mat';

%1138
save_name  = '1138_test.mat';
sim_name   = '5mm_scan.mat';
slim_name  = 'E200_1138_Slim.mat';
state_name = 'E200_1138_State.mat';
disp_name  = 'facet_dispersion-SCAVENGY.MKB-2012-07-01-043249.mat';

load([data_dir slim_name]);
load([data_dir state_name]);
load([data_dir disp_name]);

do_disp = 1;
do_y = 1;
plot_disp = 0;
view_yag = 0;
do_plot = 0;
compare = 0;
savE = 0;

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
%YAG_AX = RES*(PIX:-1:1) - RES*PIX/2;``
YAG_AX = RES*(1:PIX) - RES*PIX/2;
ENG_AX = YAG_AX/(eta_yag*1e3);

% YAG Lineout
lo_line = 150;
hi_line = 175;
LINE = uint16(zeros(PIX,nShots));
cutLINE = uint16(zeros(PIX,nShots));

% YAG FWHM
fwhm = zeros(1,nShots);
lo = zeros(1,nShots);
hi = zeros(1,nShots);

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
    %NRTL_phas(j) = good_data(j).aida.klys.phase;
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
LINESUM = sum(cutLINE,1);

%nrtl compressor phase offset
off = 90 - median(NRTL_phas(:)); 

if compare

    load([sim_dir sim_name]);
    
    MAX = max(max(max(ee(:,:,:,6))))/100;
    MIN = min(min(min(ee(:,:,:,6))))/100;
    [~,iMAX] = min(abs(MAX - ENG_AX));
    [~,iMIN] = min(abs(MIN - ENG_AX));
    NMAX = iMIN - iMAX + 1;
    
    simcent = zeros(64,64);
    concent = zeros(64,64);
    simsum  = zeros(64,64);
    consum  = zeros(64,64);
    e_interp = zeros(NMAX,64,64);
    conterp  = zeros(NMAX+150,64,64);
    e_res = zeros(1,length(ENG_AX));
    co_res = zeros(1,length(ENG_AX));
    i_start = zeros(64,64,90);
    con_start = zeros(64,64,90);
    
    RES = zeros(64,64,90);
    ABS = zeros(64,64,90);
    CON = zeros(64,64,90);
    CBS = zeros(64,64,90);
    
    % Gaussian blur
    e_blur = beam_size/eta_yag;
    c_ax = ENG_AX((length(ENG_AX)/2-75):(length(ENG_AX)/2+75));
    g = exp(-(c_ax.^2)/(2*e_blur^2));
    g = g/sum(g);
    
    for k=1:90
        
        disp(k);
        
        for i=1:64
            for j=1:64
                
                
                % Identify Max and Min of Simulated energy distribution
                e_max = ee(256,i,j,6)/100;
                e_min = ee(1,i,j,6)/100;
                
                % Find the Max and Min on the YAG energy axis
                [~,iMax] = min(abs(e_max - ENG_AX));
                [~,iMin] = min(abs(e_min - ENG_AX));
                N = iMin - iMax + 1;
                
                % Interpolate the simulated distribution onto the YAG axis
                xx = linspace(1,256,N);
                ES = interp1(es(:,i,j,6)/100,xx);
                %e_interp(1:length(ES),i,j) = ES;
                
                % convolve energy spread with gaussian
                yy = conv(ES,g);
                concent(i,j) = sum((1:length(yy)).*yy)/sum(yy);
                consum(i,j) = sum(yy);
                con_start(i,j,k)=round(indcent(k)-concent(i,j));
                if con_start(i,j,k) < 1
                    con_start(i,j,k) = 1;
                end
                conterp(1:length(yy),i,j) = yy/consum(i,j);
                
                % Calculate the centroid and integral of the distribution
                simcent(i,j) = sum((1:N).*ES)/sum(ES);
                simsum(i,j) = sum(ES);
                
                % Align simulated and measured dists
                i_start(i,j,k)=round(indcent(k)-simcent(i,j));
                if i_start(i,j,k) < 1
                    i_start(i,j,k) = 1;
                end
                e_interp(1:length(ES),i,j) = ES/simsum(i,j);
                
                % embed
                e_temp=zeros(1,838);
                diff = 0;
                if (i_start(i,j,k)+length(e_interp)-1) > 838
                    diff = (i_start(i,j,k)+length(e_interp)-1) - 838;
                end
                e_temp((i_start(i,j,k)-diff):(i_start(i,j,k)+length(e_interp)-1-diff))=e_interp(:,i,j);
                
                con_temp=zeros(1,838);
                diff = 0;
                if (con_start(i,j,k)+length(conterp)-1) > 838
                    diff = (con_start(i,j,k)+length(conterp)-1) - 838;
                end
                con_temp((con_start(i,j,k)-diff):(con_start(i,j,k)+length(conterp)-1-diff))=conterp(:,i,j);
                    
                
                if do_plot
                    %plot(ENG_AX,e_temp,ENG_AX,con_temp,ENG_AX,double(cutLINE(:,k))/LINESUM(k));
                    plot(ENG_AX,e_temp,ENG_AX,double(cutLINE(:,k))/LINESUM(k));
                    xlabel('\delta','fontsize',16);
                    axis([-0.05 0.05 0 3.5e-3]);
                    pause;
                end
                
                % Calculate residue
                e_res = e_temp - double(cutLINE(:,k)')/LINESUM(k);
                co_res = con_temp - double(cutLINE(:,k)')/LINESUM(k);
                RES(i,j,k) = sum(e_res.*e_res);
                ABS(i,j,k) = sum(abs(e_res));
                CON(i,j,k) = sum(co_res.*co_res);
                CBS(i,j,k) = sum(abs(co_res));
                
            end
        end
        
    end
    
    if savE; save([data_dir save_name],'RES','ABS','CON','CBS','e_interp','conterp','i_start','con_start','ENG_AX','cutLINE','LINESUM'); end;

end