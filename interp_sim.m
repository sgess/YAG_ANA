function INTERP = interp_sim(PIX,ENG_AX,beam_size,eta_yag,sim_file)
% Returns a struct of interpolated simulation data.
% Interpolation axis is ENG_AX. It is PIX long.
% Also returns gaussian convolved sims.

%load simulation data
load(sim_file);

%interpolated energy spectrum
INTERP.E.EE = zeros(PIX,64,64);

%convolved energy spectrum
INTERP.C.CC = zeros(PIX,64,64);

%fwhm vals
INTERP.E.FWHM = zeros(64,64);
INTERP.E.LO   = zeros(64,64);
INTERP.E.HI   = zeros(64,64);
INTERP.C.FWHM = zeros(64,64);
INTERP.C.LO   = zeros(64,64);
INTERP.C.HI   = zeros(64,64);

%gaussian blurring
e_blur = beam_size/eta_yag;
g = exp(-(ENG_AX.^2)/(2*e_blur^2));
g = g/sum(g);

% derivative of convolved spectrum
INTERP.D.DD = ones(PIX,64,64);

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
        INTERP.E.EE(round(PIX/2-simcent):round(PIX/2-simcent+N-1),i,j) = ES/simsum;
        
        % convolve energy spread with gaussian
        yy = conv(ES,g);
        
        % find centroid of convolution, convolution is a vector
        % that is N + PIX - 1 long
        consum = sum(yy);
        concent = round(sum((1:length(yy)).*yy)/consum);
        
        % project convolved distribution onto energy axis, with
        % centroid of distribution at delta = 0
        INTERP.C.CC(:,i,j) = yy((concent-round(PIX/2)):(concent+round(PIX/2)-1))/consum;
        
        %derivative of convolution
        INTERP.D.DD(1:(PIX-1),i,j) = 1 + abs(diff(INTERP.C.CC(:,i,j))/(ENG_AX(2)-ENG_AX(1)));
        
        %fwhm of energy and convolution
        [INTERP.E.FWHM(i,j),INTERP.E.LO(i,j),INTERP.E.HI(i,j)] = FWHM(ENG_AX,INTERP.E.EE(:,i,j));
        [INTERP.C.FWHM(i,j),INTERP.C.LO(i,j),INTERP.C.HI(i,j)] = FWHM(ENG_AX,INTERP.C.CC(:,i,j));
    end
end