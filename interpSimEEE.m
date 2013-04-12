function SIM_SPEC = interpSimEEE(ee,es,spectrum_axis,nBin,center)

% Identify Max and Min of Simulated energy distribution
e_max = ee(nBin);
e_min = ee(1);

% Find the Max and Min on the YAG energy axis
[dumb,iMax] = min(abs(e_max - spectrum_axis));
[crap,iMin] = min(abs(e_min - spectrum_axis));
N = iMax - iMin + 1;

% Interpolate the simulated distribution onto the YAG axis
ee = linspace(1,nBin,N);
SE = interp1(es,ee);
sim_sum = sum(SE);
sim_cen = round(sum((1:N).*SE)/sim_sum);

% Embed onto spectrum axis
PIX = length(spectrum_axis);
SIM_SPEC = zeros(PIX,1);
bin = spectrum_axis(2) - spectrum_axis(1);
offset = round(center/bin);
max_bin = offset + PIX/2 - sim_cen + N - 1;
min_bin = offset + PIX/2 - sim_cen;
if max_bin > PIX
    warning('Center = %0.4f is too high and moves spectrum out of range.',center);
    top_bin = PIX/2 + sim_cen - offset + 1;
    %SIM_SPEC(min_bin:PIX) = SX(1:top_bin)/sim_sum;
    SIM_SPEC(min_bin:PIX) = SE(1:top_bin);
elseif min_bin < 1
    warning('Center = %0.4f is too low and moves spectrum out of range.',center);
    bot_bin = 2 - min_bin;
    %SIM_SPEC(1:max_bin) = SX(bot_bin:N)/sim_sum;
    SIM_SPEC(1:max_bin) = SE(bot_bin:N);
else 
    %SIM_SPEC(min_bin:max_bin) = SX/sim_sum;
    SIM_SPEC(min_bin:max_bin) = SE;
end