function RES = compare_5D(DATA,INTERP,nShots)

%get param lengths
l_el = INTERP.I.VEC(1);
n_el = INTERP.I.VEC(2);
r_el = INTERP.I.VEC(3);
p_el = INTERP.I.VEC(4);
c_el = INTERP.I.VEC(5);

%various residual measures
RES.SIMP.SQ  = zeros(l_el, n_el, r_el, p_el, c_el, nShots);
RES.SIMP.AB  = zeros(l_el, n_el, r_el, p_el, c_el, nShots);
RES.CON.SQ   = zeros(l_el, n_el, r_el, p_el, c_el, nShots);
RES.CON.AB   = zeros(l_el, n_el, r_el, p_el, c_el, nShots);

RES.SIMP.SQVAL = zeros(1,nShots);
RES.SIMP.ABVAL = zeros(1,nShots);
RES.CON.SQVAL  = zeros(1,nShots);
RES.CON.ABVAL  = zeros(1,nShots);

%loop over yag spectra
for Y=1:nShots
    
    disp(['Progress = ' num2str(Y*100/nShots,'%0.2f') '%']);
    
    % This is a PIX by IND matrix with the YAG spectrum repeated IND times
    SPECS = ones(INTERP.I.IND,1) * DATA.YAG.SPECTRUM(:,Y)'/DATA.YAG.SUM(Y);
    
    % simple subtract off simulated data (should also be PIX x IND)
    res_simp = SPECS - INTERP.E.EE;
    res_conv = SPECS - INTERP.C.CC;
    
    % square and sum to get res vec that is IND long
    simp_sq = sum(res_simp.^2,2);
    simp_ab = sum(abs(res_simp),2);
    conv_sq = sum(res_conv.^2,2);
    conv_ab = sum(abs(res_conv),2);
    
    % find min res
    [min_simp_sq, ind_simp_sq] = min(simp_sq);
    [min_simp_ab, ind_simp_ab] = min(simp_ab);
    [min_conv_sq, ind_conv_sq] = min(conv_sq);
    [min_conv_ab, ind_conv_ab] = min(conv_ab);
    
    % extract indices
    mssq = floor(ind_simp_sq/(n_el*r_el*p_el*c_el));
    lssq = floor((ind_simp_sq - mssq*(n_el*r_el*p_el*c_el))/(n_el*r_el*p_el));
    kssq = floor((ind_simp_sq - mssq*(n_el*r_el*p_el*c_el) - lssq*(n_el*r_el*p_el))/(n_el*r_el));
    jssq = floor((ind_simp_sq - mssq*(n_el*r_el*p_el*c_el) - lssq*(n_el*r_el*p_el) - kssq*(n_el*r_el))/n_el);
    issq = ind_simp_sq - mssq*(n_el*r_el*p_el*c_el) - lssq*(n_el*r_el*p_el) - kssq*(n_el*r_el) - jssq*n_el;
    
    msab = floor(ind_simp_ab/(n_el*r_el*p_el*c_el));
    lsab = floor((ind_simp_ab - msab*(n_el*r_el*p_el*c_el))/(n_el*r_el*p_el));
    ksab = floor((ind_simp_ab - msab*(n_el*r_el*p_el*c_el) - lsab*(n_el*r_el*p_el))/(n_el*r_el));
    jsab = floor((ind_simp_ab - msab*(n_el*r_el*p_el*c_el) - lsab*(n_el*r_el*p_el) - ksab*(n_el*r_el))/n_el);
    isab = ind_simp_ab - msab*(n_el*r_el*p_el*c_el) - lsab*(n_el*r_el*p_el) - ksab*(n_el*r_el) - jsab*n_el;
    
    mcsq = floor(ind_conv_sq/(n_el*r_el*p_el*c_el));
    lcsq = floor((ind_conv_sq - mcsq*(n_el*r_el*p_el*c_el))/(n_el*r_el*p_el));
    kcsq = floor((ind_conv_sq - mcsq*(n_el*r_el*p_el*c_el) - lcsq*(n_el*r_el*p_el))/(n_el*r_el));
    jcsq = floor((ind_conv_sq - mcsq*(n_el*r_el*p_el*c_el) - lcsq*(n_el*r_el*p_el) - kcsq*(n_el*r_el))/n_el);
    icsq = ind_conv_sq - mcsq*(n_el*r_el*p_el*c_el) - lcsq*(n_el*r_el*p_el) - kcsq*(n_el*r_el) - jcsq*n_el;
    
    mcab = floor(ind_conv_ab/(n_el*r_el*p_el*c_el))+1;
    lcab = floor((ind_conv_ab - mcab*(n_el*r_el*p_el*c_el))/(n_el*r_el*p_el))+1;
    kcab = floor((ind_conv_ab - mcab*(n_el*r_el*p_el*c_el) - lcab*(n_el*r_el*p_el))/(n_el*r_el));
    jcab = floor((ind_conv_ab - mcab*(n_el*r_el*p_el*c_el) - lcab*(n_el*r_el*p_el) - kcab*(n_el*r_el))/n_el);
    icab = ind_conv_ab - mcab*(n_el*r_el*p_el*c_el) - lcab*(n_el*r_el*p_el) - kcab*(n_el*r_el) - jcab*n_el;
    
    RES.SIMP.SQVAL(Y) = min_simp_sq;
    RES.SIMP.SQIND{Y} = [issq jssq kssq lssq mssq];
    RES.SIMP.ABVAL(Y) = min_simp_ab;
    RES.SIMP.ABIND{Y} = [isab jsab ksab lsab msab];
    RES.CON.SQVAL(Y) = min_conv_sq;
    RES.CON.SQIND{Y} = [icsq jcsq kcsq lcsq mcsq];
    RES.CON.ABVAL(Y) = min_conv_ab;
    RES.CON.ABIND{Y} = [icab jcab kcab lcab mcab];
    
    for m = 1:c_el % nrtl ampl
        for l = 1:p_el % nrtl phase
            for k = 1:r_el % ramp phase
                for j = 1:n_el % num part
                    for i = 1:l_el % init length
                    
                        %index of interp matrix
                        ind = i + 6*(j-1) + 36*(k-1) + 216*(l-1) + 1296*(m-1);
                        
                        RES.SIMP.SQ(i,j,k,l,m,Y) = simp_sq(ind);
                        RES.SIMP.AB(i,j,k,l,m,Y) = simp_ab(ind);
                        RES.CON.SQ(i,j,k,l,m,Y) = conv_sq(ind);
                        RES.CON.AB(i,j,k,l,m,Y) = conv_ab(ind);
                        
                    end
                end
            end
        end
    end

end