function RES = compare_data(DATA,INTERP,nShots,do_plot)

%axis length
PIX = DATA.YAG.PIX;

%axis
E_AX = DATA.AXIS.ENG;

%various residual measures
RES.SIMP.SQ   = zeros(64,64,nShots);
RES.SIMP.AB   = zeros(64,64,nShots);
RES.SIMP.FWSQ = zeros(64,64,nShots);
RES.SIMP.FWAB = zeros(64,64,nShots);

RES.CON.SQ   = zeros(64,64,nShots);
RES.CON.AB   = zeros(64,64,nShots);
RES.CON.FWSQ = zeros(64,64,nShots);
RES.CON.FWAB = zeros(64,64,nShots);

RES.DER.SQ   = zeros(64,64,nShots);
RES.DER.AB   = zeros(64,64,nShots);
RES.DER.FWSQ = zeros(64,64,nShots);
RES.DER.FWAB = zeros(64,64,nShots);

%residual axes
e_res = zeros(1,PIX);
ef_res = zeros(1,PIX);

%convolution residual axes
co_res = zeros(1,PIX);
cf_res = zeros(1,PIX);

%derivative residual axes
d_res = zeros(1,PIX);
df_res = zeros(1,PIX);

%loop over yag spectra
for k=1:nShots
    
    disp(['Progress = ' num2str(k*100/nShots,'%0.2f') '%']);
        
    %loop over simulated spectra
    for i=1:64
        for j=1:64
            
            %create temporary projection axes
            s_temp = zeros(PIX,1);
            d_temp = ones(PIX,1);
            off = INTERP.C.LO(i,j) - DATA.YAG.LO(k);
            if off > 0
                s_temp(1:(PIX-off)) = INTERP.C.CC(off:(PIX-1),i,j);
                d_temp(1:(PIX-off)) = INTERP.D.DD(off:(PIX-1),i,j);
            else
                s_temp((-off + 1):PIX) = INTERP.C.CC(1:(PIX+off),i,j);
                d_temp((-off + 1):PIX) = INTERP.D.DD(1:(PIX+off),i,j);
            end
            
            e_temp = zeros(PIX,1);
            offe = INTERP.E.LO(i,j) - DATA.YAG.LO(k);
            if offe > 0
                e_temp(1:(PIX-offe)) = INTERP.E.EE(offe:(PIX-1),i,j);
            else
                e_temp((-offe + 1):PIX) = INTERP.C.CC(1:(PIX+offe),i,j);
            end
            
            
            if do_plot
                %plot(ENG_AX,e_temp,ENG_AX,con_temp,ENG_AX,double(cutLINE(:,k))/LINESUM(k));
                %plot(ENG_AX,conterp(:,i,j),ENG_AX,center(:,k)/LINESUM(k));
                plot(E_AX,s_temp,E_AX,DATA.YAG.SPECTRUM(:,k)/DATA.YAG.SUM(k));
                xlabel('\delta','fontsize',16);
                axis([-0.05 0.05 0 3.5e-3]);
                pause;
            end
            
            % Calculate residue
            e_res = INTERP.E.EE(:,i,j) - DATA.YAG.SPECTRUM(:,k)/DATA.YAG.SUM(k);
            ef_res = e_temp - DATA.YAG.SPECTRUM(:,k)/DATA.YAG.SUM(k);
            co_res = INTERP.C.CC(:,i,j) - DATA.YAG.SPECTRUM(:,k)/DATA.YAG.SUM(k);
            cf_res = s_temp - DATA.YAG.SPECTRUM(:,k)/DATA.YAG.SUM(k);
            d_res = (INTERP.C.CC(:,i,j) - DATA.YAG.SPECTRUM(:,k)/DATA.YAG.SUM(k))./INTERP.D.DD(:,i,j);
            df_res = (s_temp - DATA.YAG.SPECTRUM(:,k)/DATA.YAG.SUM(k))./d_temp;
            
            RES.SIMP.SQ(i,j,k) = sum(e_res.*e_res);
            RES.SIMP.AB(i,j,k) = sum(abs(e_res));
            RES.SIMP.FWSQ(i,j,k) = sum(ef_res.*ef_res);
            RES.SIMP.FWAB(i,j,k) = sum(abs(ef_res));
            
            RES.CON.SQ(i,j,k) = sum(co_res.*co_res);
            RES.CON.AB(i,j,k) = sum(abs(co_res));
            RES.CON.FWSQ(i,j,k) = sum(cf_res.*cf_res);
            RES.CON.FWAB(i,j,k) = sum(abs(cf_res));
            
            RES.DER.SQ(i,j,k) = sum(d_res.*d_res);
            RES.DER.AB(i,j,k) = sum(abs(d_res));
            RES.DER.FWSQ(i,j,k) = sum(df_res.*df_res);
            RES.DER.FWAB(i,j,k) = sum(abs(df_res));
            
        end
    end
end