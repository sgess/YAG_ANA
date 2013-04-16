function DATA = extract_data(good_data,eta_yag,beam_size,lo_line,hi_line,bad_pix,nShots,view_yag,too_wide,spec_pix)
% Extract data from slimmed directory

% NRTL stuff
DATA.NRTL.PHAS = zeros(1,nShots);
DATA.NRTL.AMPL = zeros(1,nShots);

% Pulse ID stuff
DATA.PID.BSA = zeros(1,nShots);
DATA.PID.AIDA = zeros(1,nShots);
DATA.PID.PROF = zeros(1,nShots);

% BPM stuff
DATA.BPM_2445.X = zeros(1,nShots);
DATA.BPM_2050.X = zeros(1,nShots);
DATA.BPM_3101.X = zeros(1,nShots);
DATA.BPM_3036.X = zeros(1,nShots);

DATA.BPM_2445.Y = zeros(1,nShots);
DATA.BPM_2050.Y = zeros(1,nShots);
DATA.BPM_3101.Y = zeros(1,nShots);
DATA.BPM_3036.Y = zeros(1,nShots);

DATA.BPM_2445.TMIT = zeros(1,nShots);
DATA.BPM_2050.TMIT = zeros(1,nShots);
DATA.BPM_3101.TMIT = zeros(1,nShots);
DATA.BPM_3036.TMIT = zeros(1,nShots);

% TORO stuff
DATA.TORO_2452.TMIT = zeros(1,nShots);
DATA.TORO_3163.TMIT = zeros(1,nShots);
DATA.TORO_DR13.TMIT = zeros(1,nShots);



%PYRO
DATA.PYRO.VAL = zeros(1,nShots);

% YAG Resolution
%DATA.YAG.RES = good_data(1).YAGS_LI20_2432.prof_RES;
DATA.YAG.RES = 9.62;

% YAG pixels
DATA.YAG.PIX = good_data(1).YAGS_LI20_2432.prof_roiXN;
DATA.YAG.MAXPIX = 0;
DATA.YAG.pix = 0;

% YAG Axis
DATA.BEAM.ETA = eta_yag;
DATA.BEAM.SIZE = beam_size;
DATA.AXIS.XX = DATA.YAG.RES*(1:DATA.YAG.PIX) - DATA.YAG.RES*DATA.YAG.PIX/2;
DATA.AXIS.ENG = DATA.AXIS.XX/(DATA.BEAM.ETA*1e3);

% YAG Lineout
LINE = uint16(zeros(DATA.YAG.PIX,nShots));
cutLINE = uint16(zeros(DATA.YAG.PIX,nShots));
DATA.YAG.SPECTRUM = zeros(DATA.YAG.PIX,nShots);
DATA.YAG.SUM = zeros(1,nShots);

% YAG FWHM
fwhm = zeros(1,nShots);
lo = zeros(1,nShots);
hi = zeros(1,nShots);
DATA.YAG.FWHM = zeros(1,nShots);
DATA.YAG.LO = zeros(1,nShots);
DATA.YAG.HI = zeros(1,nShots);
DATA.YAG.SUM = zeros(1,nShots);

% YAG centroid
P_cent = zeros(1,nShots);
E_cent = zeros(1,nShots);
DATA.YAG.ECENT = zeros(1,nShots);
indcent = zeros(1,nShots);


% Windowing and indexing variables
win_min = 10000*ones(1,nShots);
win_max = 10000*ones(1,nShots);
i_min = zeros(1,nShots);
i_max = (length(LINE)+1)*ones(1,nShots);
i_vec = 1:DATA.YAG.PIX;

for j = 1:nShots
    
    % Pulse ID stuff
    DATA.PID.BSA(j) = good_data(j).PulseID;
    DATA.PID.AIDA(j) = good_data(j).aida.pulse_id;
    DATA.PID.PROF(j) = good_data(j).YAGS_LI20_2432.prof_pid;
    
    
    % NRTL stuff
    DATA.NRTL.PHAS(j) = good_data(j).aida.klys.phase;
    if isfield(good_data(j),'DR13_AMPL_11_VACT')
        if ~isempty(good_data(j).DR13_AMPL_11_VACT.val)
            DATA.NRTL.AMPL(j) = good_data(j).DR13_AMPL_11_VACT.val;
        end
    end
    
    
    % BPM stuff
    DATA.BPM_2445.X(j) = good_data(j).aida.bpms(1).x;
    DATA.BPM_2050.X(j) = good_data(j).aida.bpms(16).x;
    DATA.BPM_3036.X(j) = good_data(j).aida.bpms(27).x;
    DATA.BPM_3101.X(j) = good_data(j).aida.bpms(26).x;
    
    DATA.BPM_2445.Y(j) = good_data(j).aida.bpms(1).y;
    DATA.BPM_2050.Y(j) = good_data(j).aida.bpms(16).y;
    DATA.BPM_3036.Y(j) = good_data(j).aida.bpms(27).y;
    DATA.BPM_3101.Y(j) = good_data(j).aida.bpms(26).y;
    
    DATA.BPM_2445.TMIT(j) = good_data(j).aida.bpms(1).tmit;
    DATA.BPM_2050.TMIT(j) = good_data(j).aida.bpms(16).tmit;
    DATA.BPM_3036.TMIT(j) = good_data(j).aida.bpms(27).tmit;
    DATA.BPM_3101.TMIT(j) = good_data(j).aida.bpms(26).tmit;
    
    % Toro stuff
    DATA.TORO_2452.TMIT(j) = good_data(j).aida.toro(3).tmit;
    DATA.TORO_3163.TMIT(j) = good_data(j).aida.toro(2).tmit;
    DATA.TORO_DR13.TMIT(j) = good_data(j).aida.toro(4).tmit;
    
    % PYRO Stuff
    DATA.PYRO.VAL(j) = good_data(j).BLEN_LI20_3158_BRAW.val;
    
    % YAG image alignment, centering, fwhm
    IMG_1 = rot90(good_data(j).YAGS_LI20_2432.img,2)';
    BG = IMG_1(:,800:end);
    DATA.YAG.SUM(j) = sum(IMG_1(:));
    
    %set bad pixel values to adjacent
    if ~isempty(bad_pix)
        for b = 1:length(bad_pix)
            IMG_1(:,bad_pix(b)) = IMG_1(:,bad_pix(b)-1);
        end
    end
    LINE(:,j) = mean(IMG_1(lo_line:hi_line,:),1);
    P_cent(j) = sum(DATA.AXIS.XX.*double(LINE(:,j))')/sum(double(LINE(:,j)));
    E_cent(j) = sum(DATA.AXIS.ENG.*double(LINE(:,j))')/sum(double(LINE(:,j)));
    [fwhm(j),lo(j),hi(j)] = FWHM(DATA.AXIS.ENG,double(LINE(:,j)));
    
    %window the spectrum to cut off noise tails
    lo_win = 0;
    hi_win = 0;
    for i=11:(length(LINE(:,j))/2)
        k = length(LINE(:,j)) - i + 1;
        
        lo_win = sum(LINE((i-10):(i+10),j));
        hi_win = sum(LINE((k-10):(k+10),j)); 
        if lo_win < win_min(j)
            win_min(j) = lo_win;
            i_min(j) = i;
        end
        if hi_win < win_max(j)
            win_max(j) = hi_win;
            i_max(j) = k;
        end
        
    end

    %linout minus the BG
    cutLINE(:,j) = LINE(:,j).*uint16((i_vec > i_min(j) & i_vec < i_max(j)))';
    
    %find the center
    DATA.YAG.ECENT(j) = sum(DATA.AXIS.ENG.*double(cutLINE(:,j))')/sum(double(cutLINE(:,j)));
    indcent(j) = round(sum((1:DATA.YAG.PIX).*double(cutLINE(:,j))')/sum(double(cutLINE(:,j))));
    
    %embed at center
    if indcent(j) < round(DATA.YAG.PIX/2)
        DATA.YAG.SPECTRUM(round(DATA.YAG.PIX/2-indcent(j)):DATA.YAG.PIX,j) = cutLINE(1:round(DATA.YAG.PIX/2+indcent(j)+1),j);
    else
        DATA.YAG.SPECTRUM(1:round(DATA.YAG.PIX/2+indcent(j)+1),j) = cutLINE(round(DATA.YAG.PIX/2-indcent(j)):DATA.YAG.PIX,j);
    end
    
    % FWHM of tailored spectrum
    [DATA.YAG.FWHM(j),DATA.YAG.LO(j),DATA.YAG.HI(j)] = FWHM(DATA.AXIS.ENG,DATA.YAG.SPECTRUM(:,j));
    lopix = find(DATA.YAG.SPECTRUM(:,j),1,'first');
    hipix = find(DATA.YAG.SPECTRUM(:,j),1,'last');
    pixels = hipix - lopix;
    if pixels > DATA.YAG.MAXPIX
        DATA.YAG.MAXPIX = pixels;
    end
    
    % Integral of tailored spectrum
    DATA.YAG.SUM(j) = sum(DATA.YAG.SPECTRUM(:,j));
    
    % check out your work
    if view_yag
        s1 = 10; 
        figure(s1); 
        subplot(3,1,1); 
        image(IMG_1);
        hold on;
        line([0 DATA.YAG.PIX],[lo_line lo_line],'color','r');
        line([0 DATA.YAG.PIX],[hi_line hi_line],'color','r');
        hold off;
        subplot(3,1,2); 
        plot(DATA.AXIS.ENG,cutLINE(:,j),...
            DATA.AXIS.ENG(i_min(j)),cutLINE(i_min(j),j),'r*',...
            DATA.AXIS.ENG(i_max(j)),cutLINE(i_max(j),j),'g*',...
            DATA.AXIS.ENG(indcent(j)),cutLINE(indcent(j),j),'m*',...
            DATA.AXIS.ENG(lo(j)),cutLINE(lo(j),j),'c*',...
            DATA.AXIS.ENG(hi(j)),cutLINE(hi(j),j),'k*');
        %figure(1);
        subplot(3,1,3);
        [vals,bins]=hist(double(IMG_1(:)),200);
        semilogy(bins,vals,'*');
        axis([0 300 1e0 1e5]);
        %subplot(2,2,1);
        %imagesc(BG);
        %colorbar;
        %subplot(2,2,3);
        %plot(mean(BG));
        %subplot(2,2,2);
        %plot(mean(BG,2));
        %figure(2);
        %x = mean(BG);
        %y = fft(x);
        %semilogy(abs(y(4:164)));
        display(j);
        pause;
    end
end

%store some smaller versions and force even pixels
if too_wide
    if nargin == 10
        DATA.YAG.pix = spec_pix;
    else
        if mod(DATA.YAG.MAXPIX,2)
            DATA.YAG.pix = DATA.YAG.MAXPIX+101;
        else
            DATA.YAG.pix = DATA.YAG.MAXPIX+100;
        end
    end
    DATA.YAG.spectrum = zeros(DATA.YAG.pix,nShots);
    DATA.YAG.sum = zeros(1,nShots);
    DATA.AXIS.xx  = DATA.YAG.RES*(1:DATA.YAG.pix) - DATA.YAG.RES*DATA.YAG.pix/2;
    DATA.AXIS.eng = DATA.AXIS.xx/(DATA.BEAM.ETA*1e3);
    for j = 1:nShots
        
        DATA.YAG.spectrum(:,j) = double(cutLINE((indcent(j)-DATA.YAG.pix/2):(indcent(j)+DATA.YAG.pix/2-1),j));
        DATA.YAG.sum(j) = sum(DATA.YAG.spectrum(:,j));
        
    end
end