function RES = compare_data(DATA)

%interpolated energy spectrum
    e_interp = zeros(PIX,64,64);
    
    %convolved energy spectrum
    conterp = zeros(PIX,64,64);
    
    %fwhm vals
    e_fwhm = zeros(64,64);
    e_lo   = zeros(64,64);
    e_hi   = zeros(64,64);
    c_fwhm = zeros(64,64);
    c_lo   = zeros(64,64);
    c_hi   = zeros(64,64);
    
    % derivative of convolved spectrum
    DCON = ones(PIX,64,64);
    
    %residual
    e_res = zeros(1,length(ENG_AX));
    ef_res = zeros(1,length(ENG_AX));
    
    %convolution residual
    co_res = zeros(1,length(ENG_AX));
    cf_res = zeros(1,length(ENG_AX));
    
    %derivative residual
    d_res = zeros(1,length(ENG_AX));
    df_res = zeros(1,length(ENG_AX));
    
    %various residual measures
    RES = zeros(64,64,nShots);
    ABS = zeros(64,64,nShots);
    RFN = zeros(64,64,nShots);
    RFS = zeros(64,64,nShots);
    
    CON = zeros(64,64,nShots);
    CBS = zeros(64,64,nShots);
    CFN = zeros(64,64,nShots);
    CFS = zeros(64,64,nShots);
    
    DES = zeros(64,64,nShots);
    DBS = zeros(64,64,nShots);
    DFN = zeros(64,64,nShots);
    DFS = zeros(64,64,nShots);
    
    %gaussian blurring
    e_blur = beam_size/eta_yag;
    g = exp(-(ENG_AX.^2)/(2*e_blur^2));    
    g = g/sum(g);
    
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
            e_interp(round(PIX/2-simcent):round(PIX/2-simcent+N-1),i,j) = ES/simsum;
            
            % convolve energy spread with gaussian
            yy = conv(ES,g);
            
            % find centroid of convolution, convolution is a vector
            % that is N + PIX - 1 long
            consum = sum(yy);
            concent = round(sum((1:length(yy)).*yy)/consum);
            
            % project convolved distribution onto energy axis, with
            % centroid of distribution at delta = 0
            conterp(:,i,j) = yy((concent-round(PIX/2)):(concent+round(PIX/2)-1))/consum;
            
            %derivative of convolution
            DCON(1:(PIX-1),i,j) = 1 + abs(diff(conterp(:,i,j))/(ENG_AX(2)-ENG_AX(1)));
            
            %fwhm of energy and convolution
            [e_fwhm(i,j),e_lo(i,j),e_hi(i,j)] = FWHM(ENG_AX,e_interp(:,i,j));
            [c_fwhm(i,j),c_lo(i,j),c_hi(i,j)] = FWHM(ENG_AX,conterp(:,i,j));
        end
    end
    
    
    
    for k=1:nShots
        
        %disp(k);
        
        for i=1:64
            for j=1:64
                
                s_temp = zeros(PIX,1);
                d_temp = ones(PIX,1);
                off = c_lo(i,j) - m_lo(k);
                if off > 0
                    s_temp(1:(PIX-off)) = conterp(off:(PIX-1),i,j);
                    d_temp(1:(PIX-off)) = DCON(off:(PIX-1),i,j);
                else
                    s_temp((-off + 1):PIX) = conterp(1:(PIX+off),i,j);
                    d_temp((-off + 1):PIX) = DCON(1:(PIX+off),i,j);
                end
                
                e_temp = zeros(PIX,1);
                offe = e_lo(i,j) - m_lo(k);
                if offe > 0
                    e_temp(1:(PIX-offe)) = e_interp(offe:(PIX-1),i,j);
                else
                    e_temp((-offe + 1):PIX) = conterp(1:(PIX+offe),i,j);
                end
               
                
                if do_plot
                    %plot(ENG_AX,e_temp,ENG_AX,con_temp,ENG_AX,double(cutLINE(:,k))/LINESUM(k));
                    %plot(ENG_AX,conterp(:,i,j),ENG_AX,center(:,k)/LINESUM(k));
                    plot(ENG_AX,s_temp,ENG_AX,center(:,k)/LINESUM(k));
                    xlabel('\delta','fontsize',16);
                    axis([-0.05 0.05 0 3.5e-3]);
                    pause;
                end
                
                % Calculate residue
                e_res = e_interp(:,i,j) - center(:,k)/LINESUM(k);
                ef_res = e_temp - center(:,k)/LINESUM(k);
                co_res = conterp(:,i,j) - center(:,k)/LINESUM(k);
                cf_res = s_temp - center(:,k)/LINESUM(k);
                d_res = (conterp(:,i,j) - center(:,k)/LINESUM(k))./DCON(:,i,j);
                df_res = (s_temp - center(:,k)/LINESUM(k))./d_temp;
                
                RES(i,j,k) = sum(e_res.*e_res);
                ABS(i,j,k) = sum(abs(e_res));
                RFN(i,j,k) = sum(ef_res.*ef_res);
                RFS(i,j,k) = sum(abs(ef_res));
                
                CON(i,j,k) = sum(co_res.*co_res);
                CBS(i,j,k) = sum(abs(co_res));
                CFN(i,j,k) = sum(cf_res.*cf_res);
                CFS(i,j,k) = sum(abs(cf_res));
                
                DES(i,j,k) = sum(d_res.*d_res);
                DBS(i,j,k) = sum(abs(d_res));
                DFN(i,j,k) = sum(df_res.*df_res);
                DFS(i,j,k) = sum(abs(df_res));
                
            end
        end
    end