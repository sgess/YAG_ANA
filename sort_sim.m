clear all;
load('concat_full_pyro.mat');
% load('E200_1103_retry.mat');
load('E200_1103_retry2.mat');

residodo = zeros(8,8,8,8,397);
ProfXLi = zeros(646,8,8,8,8,397);
%for i=1:1
 for i=1:length(cat_dat.YAG_FWHM)
   
    xx_y = cat_dat.yag_ax';
    Lineout = cat_dat.YAG_SPEC(:,i);
    %Lineout = cat_dat.YAG_MEAN;
    
    Line_minBG = Lineout-Lineout(1);
    line_x  = xx_y;
    x_avg = mean(line_x);
    [MaxLine,max_ind] = max(Line_minBG);
    SumLine = sum(Line_minBG);
    center = sum(line_x.*Line_minBG)/sum(Line_minBG);
    
    for a=1:8
        for b=1:8
            for c=1:8
                for d=1:8
                    
                    %SimDisp = interpSimEEE(ee(:,a,b,c,d,3),es(:,a,b,c,d,3),line_x,128,center-x_avg);
                    SimDisp = interpSimXXX(xx(:,a,b,c,d),sy(:,a,b,c,d),line_x,128,center-x_avg);
                    SumX = sum(SimDisp);
                    normX = SumLine/SumX;
                    ProfXLi(:,a,b,c,d,i) = normX*SimDisp;
                    
                    residodo(a,b,c,d,i) = sum(Line_minBG.*(ProfXLi(:,a,b,c,d,i)- Line_minBG).^2);
                    %plot(line_x,Line_minBG,'b',line_x,ProfXLi,'g','linewidth',2);
                    %pause(0.001);
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

figure(1);
plot(line_x,Line_minBG,line_x,ProfXLi(:,a,b,c,d,i));
figure(2);
plot(zz(:,a,b,c,d,3),bl(:,a,b,c,d,3));

pause(0.1);

end