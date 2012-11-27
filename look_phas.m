clear all;
%load('/Users/sgess/Desktop/FACET/2012/DATA/E200_1443/E200_1443_slim.mat');
load('/Users/sgess/Desktop/data/E200_DATA/E200_1443/E200_1443_slim.mat');
load('/Users/sgess/Desktop/data/E200_DATA/E200_1443/E200_1443_State.mat');
load('/Users/sgess/Desktop/data/E200_DATA/E200_1443/facet_dispersion-SCAVENGY.MKB-2012-07-03-094452.mat');

plot_disp = 0;

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

%if plot_disp
    
    

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
ENG_AX = YAG_AX/(0.112*1e6);

% YAG Lineout
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
    
    LINE(:,j)    = mean(IMG_1(175:200,:),1);
    LINE(:,j+18) = mean(IMG_2(175:200,:),1);
    LINE(:,j+36) = mean(IMG_3(175:200,:),1);
    LINE(:,j+54) = mean(IMG_4(175:200,:),1);
    LINE(:,j+72) = mean(IMG_5(175:200,:),1);
    
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



off = 90 - median(NRTL_phas(:));

%l = LINE(:,1);
%for i = 1:838; plot(ENG_AX,l,ENG_AX(i),l(i),'r*',ENG_AX(839-i),l(839-i),'g*'); pause; end

%for i = 1:90 
%    plot(ENG_AX,cutLINE(:,i),ENG_AX(i_min(i)),cutLINE(i_min(i),i),'r*',ENG_AX(i_max(i)),cutLINE(i_max(i),i),'g*');
%    pause;
%end    
    
clear('d_1','d_2','d_3','d_4','d_5');

load('/Users/sgess/Desktop/data/LiTrack_scans/fine_scan.mat');
%for i =1:64
    %for j=1:64
    i=50;
    j=50;
        
        e_max = ee(256,i,j,6)/100;
        e_min = ee(1,i,j,6)/100;
        
        [~,iMax] = min(abs(e_max - ENG_AX));
        [~,iMin] = min(abs(e_min - ENG_AX));
        N = iMin - iMax + 1;
        xx = linspace(1,256,N);
        ES = interp1(es(:,i,j,6)/100,xx);
        EE = linspace(e_min,e_max,N);
        simcent(i,j) = sum((1:N).*ES)/sum(ES);
        
        %for k =1:90
            
            
            
            
            
        
        
        
