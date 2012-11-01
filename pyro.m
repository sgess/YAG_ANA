function [sig, filt,LF,HF] = pyro(PROF,zz,squigs)
%function sig = pyro(AXIS,PROF)

% embed profile in longer window
base = zeros(1024,1);
base(385:640)=PROF;

% determine highest and lowest frequencies
fs = zz(end)-zz(end-1);
ps = 4*(zz(end)-zz(1));
LF = 1/ps;
HF = 1/fs;

% generate rosensweig filter
cdf3 = LF*ones(1024,1);
rosy = 1-exp(-cdf3.^2/squigs^2);

% transform and filter
y = fft(base);
filt = y.*rosy;
sig = sum(abs(filt(1:512)).^2);