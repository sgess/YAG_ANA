function [sig,filt,LF,HF] = pyro(PROF,zz,squigs,cut)
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
cdf3 = LF*(0:1023)';
rosy = 1-exp(-(cdf3/squigs).^2);

% transform and filter
y = fft(base);
filt = y.*rosy;
m = max(abs(filt(1:512)));
i = find(abs(filt(2:512))/m < cut, 1);
if isempty(i)
    i = 512;
end
sig = sum(abs(filt(1:i)).^2);