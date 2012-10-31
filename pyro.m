function sig = pyro(PROF,embed,cut)
%function sig = pyro(AXIS,PROF)

%cdf3 = ones(256,1);
%
%if nargin > 1
%    L  = length(PROF);
%    FS = length(PROF);
%    df = FS/L;
%    f  = (FS-df)*linspace(0,1,L);
%    cdf3(:) = (erf((f-cut)/1.00)+erf((-f+FS-cut)/1.00))/2;
%end

%plot(cdf3);
y = fft(PROF);
filt = y.*cdf3;
sig = sum(abs(filt).^2);


%s  = (max(AXIS)-min(AXIS))/1000/3e8;  % Length of sample in s
%FS = 256/s;                    % Sampling frequency
%T = L/FS;       % Sample time
%df = FS/L;      % Sample fraction
%lb = 21*df;        % Frequency cutoff
%plot(f,cdf3);
%hold all;
%t = (0:L-1)*T;
%filt = cdf3.*y';
%plot(f(1:L/2),abs(filt(1:L/2)));
%sig = sum(abs(filt).^2);