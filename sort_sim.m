clear all;
%load('concat_half_pyro.mat');
%nshots = 399;
load('concat_full_pyro_wide.mat');
nshots = 397;
load('fuck.mat');
residodo = zeros(10,10,10,10,nshots);

for i=1:nshots
 %for i=1:length(cat_dat.YAG_FWHM)
   
     display(i);
    xx_y = cat_dat.yag_ax';
    Lineout = cat_dat.YAG_SPEC(:,i);
    
    Line_minBG = Lineout-Lineout(1);
    line_x  = xx_y;
    x_avg = mean(line_x);
    [MaxLine,max_ind] = max(Line_minBG);
    SumLine = sum(Line_minBG);
    center = sum(line_x.*Line_minBG)/sum(Line_minBG);
    
    for a=1:10
        for b=1:10
            for c=1:10
                for d=1:10
                    
                    SimDisp = interpSimXXX(xx(:,a,b,c,d),sy(:,a,b,c,d),line_x,128,center-x_avg);
                    SumX = sum(SimDisp);
                    normX = SumLine/SumX;
                    ProfXLi = normX*SimDisp;
                    
                    residodo(a,b,c,d,i) = sum(Line_minBG.*(ProfXLi- Line_minBG).^2);
                    
                end
            end
        end
    end


[A,B] = min(residodo(:,:,:,:,i),[],4);
[C,D] = min(A,[],3);
[E,F] = min(C,[],2);
[G,H] = min(E);
a = H;
b = F(H);
c = D(H,F(H));
d = B(H,F(H),D(H,F(H)));

cat_dat.IND{i} = [a b c d];
cat_dat.RES(i) = G;
cat_dat.IPEAK(i) = I_max(a,b,c,d);
cat_dat.NPART(i) = N(a,b,c,d);
cat_dat.FWHM(i) = bl_fwhm(a,b,c,d);

cat_dat.SIM_EL(i) = PART(a);
cat_dat.SIM_PHAS(i) = PHAS(b);
cat_dat.SIM_0210(i) = LITW(c);
cat_dat.SIM_1120(i) = LIEL(d);


end

save('fuckfuckfuckfuckfuck.mat','cat_dat');