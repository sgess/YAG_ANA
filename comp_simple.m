clear all;
load('../DATA/E200_1108/E200_1108_Slim.mat');

nShots = length(good_data);

eta_yag = 120;

beta_yag = 4.496536; % (m) from elegant R56 = 5mm lattice
emit = 100e-6; % assumed
gamma = 20.35/(0.510998928e-3);
beam_size = 1000*sqrt(beta_yag*emit/gamma);

lo_line = 175;
hi_line = 200;

bad_pix = [638 639];

DATA = extract_data(good_data,eta_yag,beam_size,lo_line,hi_line,bad_pix,nShots,0);




% Insert axis from data
eta_me = 1.00*eta_yag;
ENG_AX = eta_me/eta_yag*DATA.AXIS.ENG;
PIX = length(ENG_AX);

% create gaussian for convolution
e_blur = beam_size/(eta_me);
g = exp(-(ENG_AX.^2)/(2*e_blur^2));
g = g/sum(g);
%g=ones(1,PIX)/PIX;

r = 42;

ehappy = DATA.YAG.SPECTRUM(:,r)/DATA.YAG.SUM(:,r);
ex = zeros(PIX,1);

global PARAM;


E200_1108_param;

S20 = 2;



f1 = 1;
f2 = 2;
f3 = 3;
    
 decker = -17.3;
 %ramp = +0.9286;
 ramp = -1.0;
% 
PARAM.INIT.SIGZ0 = 6.70E-3;
PARAM.INIT.SIGD0 = 6.50E-4;
PARAM.INIT.NPART = 2.10E10;
PARAM.INIT.ASYM  = -0.200;
% 
 PARAM.NRTL.AMPL  = 0.0331;
 PARAM.NRTL.PHAS  = 88.70;
% 
PARAM.NRTL.ELO   = -0.0300;
PARAM.NRTL.EHI   = 0.0300;
% 
PARAM.LI10.ELO   = -0.036;
PARAM.LI10.EHI   = 0.036;
% 
PARAM.LI20.ELO   = -0.034;
PARAM.LI20.EHI   = 0.034;
% 
% PARAM.NRTL.R56   = 0.6026;
% PARAM.NRTL.T566  = 1.075;
% PARAM.LI10.R56   = -0.075786;
% 
 PARAM.LONE.PHAS = decker+ramp;
 PARAM.LTWO.PHAS = ramp;
% 
% PARAM.LI20.R56   = 0.0050;
% PARAM.LI20.T566  = 0.100;
PARAM.LI20.R16   = 110;
PARAM.LI20.T166  = 1200;
PARAM.LI20.BETA  = 5;
PARAM.LI20.EMIT  = 100e-6;

dither = 0;

if dither
    
    res_set = zeros(1,11);
    %ramp_i = -1.5;
    %decker_i = -21.315;
    %nrtl_ampl_i = 0.04045;
    nrtl_phas_i = 88.95;
    %sigz0_i = 7.7E-3;
    %sigd0_i = 7.5E-4;
    %part_i  = 2.6e10;
    
    for i=1:11
        
        %ramp = (i-6)*ramp_i/10 + ramp_i;
        %decker = (i-6)*decker_i/100 + decker_i;
        %PARAM.NRTL.AMPL = (i-6)*nrtl_ampl_i/100 + nrtl_ampl_i;
        PARAM.NRTL.PHAS = (i-6)*nrtl_phas_i/1000 + nrtl_phas_i;
        %PARAM.INIT.SIGD0 = (i-6)*sigd0_i/100 + sigd0_i;
        %PARAM.INIT.SIGZ0 = (i-6)*sigz0_i/20 + sigz0_i;
        %PARAM.INIT.NPART = (i-6)*part_i/20 + part_i;
        
        PARAM.LONE.PHAS = decker+ramp;
        
        PARAM.LONE.GAIN = (PARAM.ENRG.E1 - PARAM.ENRG.E0)/cosd(PARAM.LONE.PHAS);
        OUT = LiTrack('FACETpar');
        
        
        % Identify Max and Min of Simulated energy distribution
        e_max = OUT.E.AXIS(256,S20)/100;
        e_min = OUT.E.AXIS(1,S20)/100;
        
        % Find the Max and Min on the YAG energy axis
        [~,iMax] = min(abs(e_max - ENG_AX));
        [~,iMin] = min(abs(e_min - ENG_AX));
        N = iMax - iMin + 1;
        
        % Interpolate the simulated distribution onto the YAG axis
        xx = linspace(1,256,N);
        ES = interp1(OUT.E.HIST(:,S20)/100,xx);
        
        % Calculate the centroid and integral of the distribution
        simsum = sum(ES);
        simcent = round(sum((1:N).*ES)/simsum);
        
        % embed interpolated distribution onto energy axis, with
        % centr ros(1,PIX);
        ee(round(PIX/2-simcent):round(PIX/2-simcent+N-1)) = ES/simsum;
        
        % convolve energy spread with gaussian
        yy = conv(ES,g);
        
        % find centroid of convolution, convolution is a vector
        % that is N + PIX - 1 long
        consum = sum(yy);
        concent = round(sum((1:length(yy)).*yy)/consum);
        
        % project convolved distribution onto energy axis, with
        % centroid of distribution at delta = 0
        Eplot = yy((concent-round(PIX/2)):(concent+round(PIX/2)-1))/consum;
        
        e_res = ehappy - Eplot';
        res = sum(e_res.*e_res);
        
        res_set(i) = res;
        figure(f3);
        plot(res_set);
        
    end
    
else
    
    PARAM.LONE.GAIN = (PARAM.ENRG.E1 - PARAM.ENRG.E0)/cosd(PARAM.LONE.PHAS);
    OUT = LiTrack('FACETpar');
    
    % Identify Max and Min of Simulated energy distribution
    e_max = OUT.E.AXIS(256,S20)/100;
    e_min = OUT.E.AXIS(1,S20)/100;
    
    % Identify Max and Min of distorted energy distribution
    ex_max = OUT.X.AXIS(256)/PARAM.LI20.R16;
    ex_min = OUT.X.AXIS(1)/PARAM.LI20.R16;

    % Find the Max and Min on the YAG energy axis
    [~,iMax] = min(abs(e_max - ENG_AX));
    [~,iMin] = min(abs(e_min - ENG_AX));
    N = iMax - iMin + 1;
    
    % Find the Max and Min on the YAG energy axis
    [~,xMax] = min(abs(ex_max - ENG_AX));
    [~,xMin] = min(abs(ex_min - ENG_AX));
    Nx = xMax - xMin + 1;
    
    % Interpolate the simulated distribution onto the YAG axis
    xx = linspace(1,256,N);
    ES = interp1(OUT.E.HIST(:,S20)/100,xx);
    
    % Interpolate the simulated distribution onto the YAG axis
    xe = linspace(1,256,Nx);
    EX = interp1(OUT.X.HIST/PARAM.LI20.R16,xe);
    
    % Calculate the centroid and integral of the distribution
    simsum = sum(ES);
    simcent = round(sum((1:N).*ES)/simsum);
    
    % Calculate the centroid and integral of the distribution
    esum = sum(EX);
    ecent = round(sum((1:Nx).*EX)/esum);
    
    % embed interpolated distribution onto energy axis, with
    ee(round(PIX/2-simcent):round(PIX/2-simcent+N-1)) = ES/simsum;
    
    % embed interpolated distribution onto energy axis, with
    ex(round(PIX/2-ecent):round(PIX/2-ecent+Nx-1)) = EX/esum;
    
    % convolve energy spread with gaussian
    yy = conv(ES,g);
    
    % find centroid of convolution, convolution is a vector
    % that is N + PIX - 1 long
    consum = sum(yy);
    concent = round(sum((1:length(yy)).*yy)/consum);
    
    % project convolved distribution onto energy axis, with
    % centroid of distribution at delta = 0
    Eplot = yy((concent-round(PIX/2)):(concent+round(PIX/2)-1))/consum;
    
    e_res = ehappy - Eplot';
    res = sum(e_res.*e_res);
    
    ex_res = ehappy - ex;
    xres = sum(ex_res.^2);
    
    figure(f1);
    %plot(ENG_AX,Eplot,ENG_AX,ehappy);
    plot(ENG_AX(375:775),ex(375:775),ENG_AX(375:775),ehappy(375:775));
    %text(-0.05,1.5e-3,num2str(res,'%10.3e'),'fontsize',16);
    %text(-0.05,1.75e-3,num2str(OUT.I.PART(S20)*PARAM.INIT.NPART/PARAM.INIT.NESIM,'%10.3e'),'fontsize',16);
    text(-0.00,1.5e-3,num2str(xres,'%10.3e'),'fontsize',16);
    text(-0.00,1.75e-3,num2str(OUT.I.PART(S20)*PARAM.INIT.NPART/PARAM.INIT.NESIM,'%10.3e'),'fontsize',16);
    figure(f2);
    plot(OUT.Z.AXIS(:,S20),OUT.Z.HIST(:,S20));
    
end