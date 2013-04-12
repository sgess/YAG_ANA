clear all;
load('concat_full_pyro.mat');
load('E200_1103_retry.mat');

for i=1:length(cat_dat.YAG_FWHM)
    
    xx = cat_dat.yag_ax;
    Lineout = cat_dat.YAG_SPEC(:,i);
    
    Line_minBG = Lineout-Lineout(1);
    line_x  = xx;
    x_avg = mean(line_x);
    [MaxLine,max_ind] = max(Line_minBG);
    SumLine = sum(Line_minBG);
    center = sum(line_x.*Line_minBG)/sum(Line_minBG);
    
    for a=1:8
        for b=1:8
            for c=1:8
                for d=1:8
                    
                    SimDisp = interpSimXXX(es(:,a,b,c,d,3),line_x,128,center-x_avg);
                    SumX = sum(SimDisp);
                    normX = SumLine/SumX;
                    ProfXLi = normX*SimDisp;
                    
                    