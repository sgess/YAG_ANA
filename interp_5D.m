function INTERP = interp_5D(PIX,ENG_AX,beam_size,eta_yag,sim_file)
% Returns a struct of interpolated simulation data.
% Interpolation axis is ENG_AX. It is PIX long.
% Also returns gaussian convolved sims.

%load simulation data
load(sim_file);

%get param info
[bins, l_el, n_el, r_el, p_el, c_el, n_out] = size(es);

%interpolated energy spectrum
INTERP.E.EE = zeros(PIX,l_el*n_el*r_el*p_el*c_el);

%convolved energy spectrum
INTERP.C.CC = zeros(PIX,l_el*n_el*r_el*p_el*c_el);

%fwhm vals
INTERP.E.FWHM = zeros(l_el, n_el, r_el, p_el, c_el);
INTERP.E.LO   = zeros(l_el, n_el, r_el, p_el, c_el);
INTERP.E.HI   = zeros(l_el, n_el, r_el, p_el, c_el);
INTERP.C.FWHM = zeros(l_el, n_el, r_el, p_el, c_el);
INTERP.C.LO   = zeros(l_el, n_el, r_el, p_el, c_el);
INTERP.C.HI   = zeros(l_el, n_el, r_el, p_el, c_el);

%gaussian blurring
e_blur = beam_size/eta_yag;
g = exp(-(ENG_AX.^2)/(2*e_blur^2));
g = g/sum(g);

% Blur and interp
for m = 1:c_el % nrtl ampl
    for l = 1:p_el % nrtl phase
        for k = 1:r_el % ramp phase
            for j = 1:n_el % num part
                for i = 1:l_el % init length
                    
                    %index of interp matrix
                    ind = i + 6*(j-1) + 36*(k-1) + 216*(l-1) + 1296*(m-1);
        
                    % Identify Max and Min of Simulated energy distribution
                    e_max = ee(bins,i,j,k,l,m,n_out)/100;
                    e_min = ee(1,i,j,k,l,m,n_out)/100;
        
                    % Find the Max and Min on the YAG energy axis
                    [~,iMax] = min(abs(e_max - ENG_AX));
                    [~,iMin] = min(abs(e_min - ENG_AX));
                    N = iMax - iMin + 1;
        
                    % Interpolate the simulated distribution onto the YAG axis
                    xx = linspace(1,bins,N);
                    ES = interp1(es(:,i,j,k,l,m,n_out)/100,xx);
        
                    % Calculate the centroid and integral of the distribution
                    simsum = sum(ES);
                    simcent = round(sum((1:N).*ES)/simsum);
        
                    % embed interpolated distribution onto energy axis, with
                    % centroid of distribution at delta = 0
                    INTERP.E.EE(round(PIX/2-simcent):round(PIX/2-simcent+N-1),ind) = ES/simsum;
        
                    % convolve energy spread with gaussian
                    yy = conv(ES,g);
        
                    % find centroid of convolution, convolution is a vector
                    % that is N + PIX - 1 long
                    consum = sum(yy);
                    concent = round(sum((1:length(yy)).*yy)/consum);
        
                    % project convolved distribution onto energy axis, with
                    % centroid of distribution at delta = 0
                    INTERP.C.CC(:,ind) = yy((concent-round(PIX/2)):(concent+round(PIX/2)-1))/consum;
        
                    %fwhm of energy and convolution
                    [INTERP.E.FWHM(i,j,k,l,m),INTERP.E.LO(i,j,k,l,m),INTERP.E.HI(i,j,k,l,m)] = FWHM(ENG_AX,INTERP.E.EE(:,ind));
                    [INTERP.C.FWHM(i,j,k,l,m),INTERP.C.LO(i,j,k,l,m),INTERP.C.HI(i,j,k,l,m)] = FWHM(ENG_AX,INTERP.C.CC(:,ind));
                    
                end
            end
        end
    end
end