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
    
end

off = 90 - median(NRTL_phas(:));
    
    