clear all;
%load('/Users/sgess/Desktop/FACET/2012/DATA/E200_1443/E200_1443_slim.mat');

%data_dir = '/Users/sgess/Desktop/data/E200_DATA/E200_1443/';
data_dir = '/Users/sgess/Desktop/FACET/2012/DATA/E200_1443/';

%save_dir = '/Users/sgess/Desktop/plots/E200/E200_1443/';
save_dir = '/Users/sgess/Desktop/FACET/PLOTS/E200_1443/';

load([data_dir 'E200_1443_slim.mat']);
load([data_dir 'E200_1443_State.mat']);
load([data_dir 'facet_dispersion-SCAVENGY.MKB-2012-07-03-094452.mat']);


plot_disp = 0;
compare = 1;
savE = 0;

% Dispersion analysis
x_2050=zeros(30,7);
x_2445=zeros(30,7);
y_2050=zeros(30,7);
y_2445=zeros(30,7);

% BPM X,Y in mm
x_2050(:,:)=data.x(9,:,:);
x_2445(:,:)=data.x(19,:,:);

y_2050(:,:)=data.y(9,:,:);
y_2445(:,:)=data.y(19,:,:);

% Energy in MeV
e=zeros(30,7);
e(:,:)=data.energy(1,:,:);

% delta
d=zeros(30,7);
d=e/(20.35e3);

% fit data
px_2050=polyfit(d(:),x_2050(:),3);
px_2445=polyfit(d(:),x_2445(:),3);
py_2050=polyfit(d(:),y_2050(:),3);
py_2445=polyfit(d(:),y_2445(:),3);
fx_2050=polyval(px_2050,d(1,:));
fx_2445=polyval(px_2445,d(1,:));
fy_2050=polyval(py_2050,d(1,:));
fy_2445=polyval(py_2445,d(1,:));


    
% Optics stuff
eta_yag = 1000*(1.118329e-01);  % (mm) from elegant R56 = 5mm lattice
T166_yag= 1000*(-8.261055e-03); % (mm) from elegant R56 = 5mm lattice
eta_bpm_2050 = 1000*(1.206816e-01);  % (mm) from elegant R56 = 5mm lattice
T166_bpm_2050= 1000*(-1.207078e-01); % (mm) from elegant R56 = 5mm lattice
eta_bpm_2445 = 1000*(1.200949e-01);  % (mm) from elegant R56 = 5mm lattice
T166_bpm_2445= 1000*(1.606618e-02); % (mm) from elegant R56 = 5mm lattice

beta_yag = 4.496536; % (m) from elegant R56 = 5mm lattice
emit = 100e-6; % assumed
gamma = 20.35/(0.510998928e-3);
beam_size = 1000*sqrt(beta_yag*emit/gamma);

if plot_disp
    
    f1 = 1;
    f2 = 2;
    
    e_ax = linspace(-0.05,0.05,100);
    x_ax_2050 = eta_bpm_2050*e_ax+T166_bpm_2050*e_ax.*e_ax;
    x_ax_2445 = eta_bpm_2445*e_ax+T166_bpm_2445*e_ax.*e_ax;
    
    figure(f1);
    plot(d(:),x_2445(:),'b*');
    hold on;
    plot(e_ax(40:60),x_ax_2445(40:60)+px_2445(4),'g',d(1,:),fx_2445,'r','linewidth',2);
    axis([-0.01 0.01 -1.75 0.6]); 
    xlabel('\delta','fontsize',16);
    ylabel('X (mm)','fontsize',16);
    title('BPM 2445','fontsize',16);
    l=legend('Data','Elegant','Fit');
    set(l,'fontsize',16);
    set(l,'location','northwest');
    v = axis;
    text(0.35*v(2),0.65*v(3),['Eta = ' num2str(eta_bpm_2445,'%0.2f') ' mm'],'fontsize',14,'color','g');
    text(0.35*v(2),0.70*v(3),['T166 = ' num2str(T166_bpm_2445,'%0.2f') ' mm'],'fontsize',14,'color','g');
    text(0.35*v(2),0.80*v(3),['Eta = ' num2str(px_2445(3),'%0.2f') ' mm'],'fontsize',14,'color','r');
    text(0.35*v(2),0.85*v(3),['T166 = ' num2str(px_2445(2),'%0.2f') ' mm'],'fontsize',14,'color','r');
    hold off;
    if savE; saveas(gca,[save_dir 'bpm2445_disp.pdf']); end;
    
    figure(f2);
    plot(d(:),x_2050(:),'b*');
    hold on;
    plot(e_ax(40:60),x_ax_2050(40:60)+px_2050(4),'g',d(1,:),fx_2050,'r','linewidth',2);
    axis([-0.01 0.01 -1.35 1]); 
    xlabel('\delta','fontsize',16);
    ylabel('X (mm)','fontsize',16);
    title('BPM 2050','fontsize',16);
    l=legend('Data','Elegant','Fit');
    set(l,'fontsize',16);
    set(l,'location','northwest');
    v = axis;
    text(0.35*v(2),0.52*v(3),['Eta = ' num2str(eta_bpm_2050,'%0.2f') ' mm'],'fontsize',14,'color','g');
    text(0.35*v(2),0.60*v(3),['T166 = ' num2str(T166_bpm_2050,'%0.2f') ' mm'],'fontsize',14,'color','g');
    text(0.35*v(2),0.73*v(3),['Eta = ' num2str(px_2050(3),'%0.2f') ' mm'],'fontsize',14,'color','r');
    text(0.35*v(2),0.81*v(3),['T166 = ' num2str(px_2050(2),'%0.2f') ' mm'],'fontsize',14,'color','r');
    hold off;
    if savE; saveas(gca,[save_dir 'bpm2050_disp.pdf']); end;
end

% NRTL stuff
NRTL_phas = zeros(1,90);
NRTL_ampl = zeros(1,90);

% Pulse ID stuff
pulseID = zeros(1,90);
aidaPID = zeros(1,90);
profPID = zeros(1,90);

% BPM stuff
BPM_2445_X = zeros(1,90);
BPM_2050_X = zeros(1,90);

BPM_2445_Y = zeros(1,90);
BPM_2050_Y = zeros(1,90);

% YAG Resolution
RES = d_1(1).YAGS_LI20_2432.prof_RES;

% YAG pixels
PIX = d_1(1).YAGS_LI20_2432.prof_roiXN;

% YAG Axis
YAG_AX = RES*(PIX:-1:1) - RES*PIX/2;
ENG_AX = YAG_AX/(eta_yag*1e3);

% YAG Lineout
lo_line = 125;
hi_line = 150;
LINE = uint16(zeros(838,90));
cutLINE = uint16(zeros(838,90));

% YAG FWHM
fwhm = zeros(1,90);

% YAG centroid
cent = zeros(1,90);
cutcent = zeros(1,90);
indcent = zeros(1,90);


% Windowing and indexing variables
win_min = 10000*ones(1,90);
win_max = 10000*ones(1,90);
i_min = zeros(1,90);
i_max = (length(LINE)+1)*ones(1,90);
i_vec = 1:838;
lo_win = zeros(1,5);
hi_win = zeros(1,5);

for j = 1:18
    
    % Pulse ID stuff
    pulseID(j)    = d_1(j).PulseID;
    pulseID(j+18) = d_2(j).PulseID;
    pulseID(j+36) = d_3(j).PulseID;
    pulseID(j+54) = d_4(j).PulseID;
    pulseID(j+72) = d_5(j).PulseID;
    
    aidaPID(j)    = d_1(j).aida.pulse_id;
    aidaPID(j+18) = d_2(j).aida.pulse_id;
    aidaPID(j+36) = d_3(j).aida.pulse_id;
    aidaPID(j+54) = d_4(j).aida.pulse_id;
    aidaPID(j+72) = d_5(j).aida.pulse_id;
    
    profPID(j)    = d_1(j).YAGS_LI20_2432.prof_pid;
    profPID(j+18) = d_2(j).YAGS_LI20_2432.prof_pid;
    profPID(j+36) = d_3(j).YAGS_LI20_2432.prof_pid;
    profPID(j+54) = d_4(j).YAGS_LI20_2432.prof_pid;
    profPID(j+72) = d_5(j).YAGS_LI20_2432.prof_pid;
    
    % NRTL stuff
    NRTL_phas(j)    = d_1(j).aida.klys.phase;
    NRTL_phas(j+18) = d_2(j).aida.klys.phase;
    NRTL_phas(j+36) = d_3(j).aida.klys.phase;
    NRTL_phas(j+54) = d_4(j).aida.klys.phase;
    NRTL_phas(j+72) = d_5(j).aida.klys.phase;
    
    NRTL_ampl(j)    = d_1(j).DR13_AMPL_11_VACT.val;
    NRTL_ampl(j+18) = d_2(j).DR13_AMPL_11_VACT.val;
    NRTL_ampl(j+36) = d_3(j).DR13_AMPL_11_VACT.val;
    NRTL_ampl(j+54) = d_4(j).DR13_AMPL_11_VACT.val;
    NRTL_ampl(j+72) = d_5(j).DR13_AMPL_11_VACT.val;
    
    % BPM stuff
    BPM_2445_X(j)    = d_1(j).aida.bpms(1).x;
    BPM_2445_X(j+18) = d_2(j).aida.bpms(1).x;
    BPM_2445_X(j+36) = d_3(j).aida.bpms(1).x;
    BPM_2445_X(j+54) = d_4(j).aida.bpms(1).x;
    BPM_2445_X(j+72) = d_5(j).aida.bpms(1).x;
    
    BPM_2050_X(j)    = d_1(j).aida.bpms(16).x;
    BPM_2050_X(j+18) = d_2(j).aida.bpms(16).x;
    BPM_2050_X(j+36) = d_3(j).aida.bpms(16).x;
    BPM_2050_X(j+54) = d_4(j).aida.bpms(16).x;
    BPM_2050_X(j+72) = d_5(j).aida.bpms(16).x;
    
    BPM_2445_Y(j)    = d_1(j).aida.bpms(1).y;
    BPM_2445_Y(j+18) = d_2(j).aida.bpms(1).y;
    BPM_2445_Y(j+36) = d_3(j).aida.bpms(1).y;
    BPM_2445_Y(j+54) = d_4(j).aida.bpms(1).y;
    BPM_2445_Y(j+72) = d_5(j).aida.bpms(1).y;
    
    BPM_2050_Y(j)    = d_1(j).aida.bpms(16).y;
    BPM_2050_Y(j+18) = d_2(j).aida.bpms(16).y;
    BPM_2050_Y(j+36) = d_3(j).aida.bpms(16).y;
    BPM_2050_Y(j+54) = d_4(j).aida.bpms(16).y;
    BPM_2050_Y(j+72) = d_5(j).aida.bpms(16).y;
    
    % YAG stuff
    IMG_1 = rot90(d_1(j).YAGS_LI20_2432.img,2)';
    IMG_2 = rot90(d_2(j).YAGS_LI20_2432.img,2)';
    IMG_3 = rot90(d_3(j).YAGS_LI20_2432.img,2)';
    IMG_4 = rot90(d_4(j).YAGS_LI20_2432.img,2)';
    IMG_5 = rot90(d_5(j).YAGS_LI20_2432.img,2)';
    
    LINE(:,j)    = mean(IMG_1(lo_line:hi_line,:),1);
    LINE(:,j+18) = mean(IMG_2(lo_line:hi_line,:),1);
    LINE(:,j+36) = mean(IMG_3(lo_line:hi_line,:),1);
    LINE(:,j+54) = mean(IMG_4(lo_line:hi_line,:),1);
    LINE(:,j+72) = mean(IMG_5(lo_line:hi_line,:),1);
    
    fwhm(j)    = FWHM(ENG_AX,LINE(:,j));
    fwhm(j+18) = FWHM(ENG_AX,LINE(:,j+18));
    fwhm(j+36) = FWHM(ENG_AX,LINE(:,j+36));
    fwhm(j+54) = FWHM(ENG_AX,LINE(:,j+54));
    fwhm(j+72) = FWHM(ENG_AX,LINE(:,j+72));
    
    cent(j)    = sum(ENG_AX.*double(LINE(:,j))')/sum(double(LINE(:,j)));
    cent(j+18) = sum(ENG_AX.*double(LINE(:,j+18))')/sum(double(LINE(:,j)));
    cent(j+36) = sum(ENG_AX.*double(LINE(:,j+36))')/sum(double(LINE(:,j)));
    cent(j+54) = sum(ENG_AX.*double(LINE(:,j+54))')/sum(double(LINE(:,j)));
    cent(j+72) = sum(ENG_AX.*double(LINE(:,j+72))')/sum(double(LINE(:,j)));
    
    lo_win(:) = 0;
    hi_win(:) = 0;
    for i=11:(length(LINE(:,j))/2)
        
        k = length(LINE(:,j)) - i + 1;
        
        lo_win(1) = sum(LINE((i-10):(i+10),j));
        lo_win(2) = sum(LINE((i-10):(i+10),j+18));
        lo_win(3) = sum(LINE((i-10):(i+10),j+36));
        lo_win(4) = sum(LINE((i-10):(i+10),j+54));
        lo_win(5) = sum(LINE((i-10):(i+10),j+72));
        
        hi_win(1) = sum(LINE((k-10):(k+10),j));
        hi_win(2) = sum(LINE((k-10):(k+10),j+18));
        hi_win(3) = sum(LINE((k-10):(k+10),j+36));
        hi_win(4) = sum(LINE((k-10):(k+10),j+54));
        hi_win(5) = sum(LINE((k-10):(k+10),j+72));
        
        for n=1:5
            if lo_win(n) < win_min(j+(n-1)*18)
                win_min(j+(n-1)*18) = lo_win(n);
                i_min(j+(n-1)*18) = i;
            end
            if hi_win(n) < win_max(j+(n-1)*18)
                win_max(j+(n-1)*18) = hi_win(n);
                i_max(j+(n-1)*18) = k;
            end
        end
    end

    cutLINE(:,j) = LINE(:,j).*uint16((i_vec > i_min(j) & i_vec < i_max(j)))';
    cutLINE(:,j+18) = LINE(:,j+18).*uint16((i_vec > i_min(j+18) & i_vec < i_max(j+18)))';
    cutLINE(:,j+36) = LINE(:,j+36).*uint16((i_vec > i_min(j+36) & i_vec < i_max(j+36)))';
    cutLINE(:,j+54) = LINE(:,j+54).*uint16((i_vec > i_min(j+54) & i_vec < i_max(j+54)))';
    cutLINE(:,j+72) = LINE(:,j+72).*uint16((i_vec > i_min(j+72) & i_vec < i_max(j+72)))';
    
    cutcent(j)    = sum(ENG_AX.*double(cutLINE(:,j))')/sum(double(cutLINE(:,j)));
    cutcent(j+18) = sum(ENG_AX.*double(cutLINE(:,j+18))')/sum(double(cutLINE(:,j)));
    cutcent(j+36) = sum(ENG_AX.*double(cutLINE(:,j+36))')/sum(double(cutLINE(:,j)));
    cutcent(j+54) = sum(ENG_AX.*double(cutLINE(:,j+54))')/sum(double(cutLINE(:,j)));
    cutcent(j+72) = sum(ENG_AX.*double(cutLINE(:,j+72))')/sum(double(cutLINE(:,j)));
    
    indcent(j)    = sum((1:838).*double(cutLINE(:,j))')/sum(double(cutLINE(:,j)));
    indcent(j+18) = sum((1:838).*double(cutLINE(:,j+18))')/sum(double(cutLINE(:,j)));
    indcent(j+36) = sum((1:838).*double(cutLINE(:,j+36))')/sum(double(cutLINE(:,j)));
    indcent(j+54) = sum((1:838).*double(cutLINE(:,j+54))')/sum(double(cutLINE(:,j)));
    indcent(j+72) = sum((1:838).*double(cutLINE(:,j+72))')/sum(double(cutLINE(:,j)));
    
    
    
end


LINESUM = sum(cutLINE,1);
off = 90 - median(NRTL_phas(:));

%l = LINE(:,1);
%for i = 1:838; plot(ENG_AX,l,ENG_AX(i),l(i),'r*',ENG_AX(839-i),l(839-i),'g*'); pause; end

%for i = 1:90 
%    plot(ENG_AX,cutLINE(:,i),ENG_AX(i_min(i)),cutLINE(i_min(i),i),'r*',ENG_AX(i_max(i)),cutLINE(i_max(i),i),'g*');
%    pause;
%end    
    
clear('d_1','d_2','d_3','d_4','d_5');
sim_dir = '/Users/sgess/Desktop/FACET/2012/DATA/LiTrackScans/';
if compare

    load([sim_dir '5mm_scan.mat']);
    
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
    CON = zeros(64,64,90);
    % Gaussian blur
    e_blur = beam_size/eta_yag;
    c_ax = ENG_AX((length(ENG_AX)/2-75):(length(ENG_AX)/2+75));
    g = exp(-(c_ax.^2)/(2*e_blur^2));
    g = g/sum(g);
    
    for k=1:90
        
        disp(k);
        
        for i=30:64
            for j=30:64
                
                
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
                    
                %plot(ENG_AX,e_temp,ENG_AX,con_temp,ENG_AX,double(cutLINE(:,k))/LINESUM(k));
                plot(ENG_AX,e_temp,ENG_AX,double(cutLINE(:,k))/LINESUM(k));
                xlabel('\delta','fontsize',16);
                axis([-0.05 0.05 0 3.5e-3]);
                pause;
                
                % Calculate residue
                e_res = e_temp - double(cutLINE(:,k)')/LINESUM(k);
                co_res = con_temp - double(cutLINE(:,k)')/LINESUM(k);
                RES(i,j,k) = sum(e_res.*e_res);
                CON(i,j,k) = sum(co_res.*co_res);
                
            end
        end
        
    end
    
    if savE; save([data_dir 'RES_5mm_hi.mat'],'RES','CON','e_interp','conterp','i_start','con_start','ENG_AX','cutLINE','LINESUM'); end;

end