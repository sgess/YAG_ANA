f1 = 1;
f2 = 2;
% f3 = 3;
% 
% figure(f1);
% bl_cat = [bl_cat1 bl_cat2 bl_cat3; bl_cat4 bl_cat5 bl_cat6];
% imagesc(log(bl_cat'));
% colorbar;


for Y =1:87;
    
    bl_cat1 = [];
    bl_cat2 = [];
    bl_cat3 = [];
    bl_cat4 = [];
    bl_cat5 = [];
    bl_cat6 = [];
    bl_cat7 = [];
    bl_cat8 = [];
    for k = 1:8 % ramp
        bl_line1 = [];
        bl_line2 = [];
        bl_line3 = [];
        bl_line4 = [];
        bl_line5 = [];
        bl_line6 = [];
        bl_line7 = [];
        bl_line8 = [];
        for l = 1:8 % compressor phase
            
            bl_line1 = [bl_line1 RES.CON.SQ(:,:,k,l,1,Y)];
            bl_line2 = [bl_line2 RES.CON.SQ(:,:,k,l,2,Y)];
            bl_line3 = [bl_line3 RES.CON.SQ(:,:,k,l,3,Y)];
            bl_line4 = [bl_line4 RES.CON.SQ(:,:,k,l,4,Y)];
            bl_line5 = [bl_line5 RES.CON.SQ(:,:,k,l,5,Y)];
            bl_line6 = [bl_line6 RES.CON.SQ(:,:,k,l,6,Y)];
            bl_line7 = [bl_line7 RES.CON.SQ(:,:,k,l,7,Y)];
            bl_line8 = [bl_line8 RES.CON.SQ(:,:,k,l,8,Y)];
        end
        
        bl_cat1 = [bl_cat1; bl_line1];
        bl_cat2 = [bl_cat2; bl_line2];
        bl_cat3 = [bl_cat3; bl_line3];
        bl_cat4 = [bl_cat4; bl_line4];
        bl_cat5 = [bl_cat5; bl_line5];
        bl_cat6 = [bl_cat6; bl_line6];
        bl_cat7 = [bl_cat7; bl_line7];
        bl_cat8 = [bl_cat8; bl_line8];
    end
    
    vind = RES.CON.SQIND{Y};
    ind = vind(1)+8*vind(2)+64*vind(3)+512*vind(4)+4096*vind(5) + 1;
    i = vind(1)+1;
    j = vind(2)+1;
    k = vind(3)+1;
    l = vind(4)+1;
    m = vind(5)+1;
    
    if m < 5
        m1 = m-1;
        m2 = 0;
    else
        m1 = m-5;
        m2 = 1;
    end
     
    figure(f1);
    bl_cat = [bl_cat1 bl_cat2 bl_cat3 bl_cat4; bl_cat5 bl_cat6 bl_cat7 bl_cat8];
    imagesc(log(bl_cat'));
    colorbar;
    hold on;
    plot(i+8*(k-1)+64*m2,j+8*(l-1)+64*m1,'marker','p','color','w','markersize',25,'markerfacecolor','w');
    hold off;
    

    figure(f2);
    plot(DATA.AXIS.eng,DATA.YAG.spectrum(:,Y)/DATA.YAG.sum(Y),DATA.AXIS.eng,INTERP.C.CC(ind,:));
    disp(Y);
    pause;
end


% for m = 6:6 % nrtl ampl
%     for l = 1:6 % nrtl phase
%         for k = 1:1 % ramp phase
%             for j = 1:6 % num part
%                 for i = 1:6 % init length
%                     
%                     figure(f1);
%                     imagesc(bl_cat6');
%                     colorbar;
%                     hold on;
%                     plot(i+6*(k-1),j+6*(l-1),'marker','p','color','w','markersize',20,'markerfacecolor','w');
%                     hold off;
%                     
%                     ind = i + 6*(j-1) + 36*(k-1) + 216*(l-1) + 6480;
%                     figure(f2);
%                     plot(DATA.AXIS.ENG,DATA.YAG.SPECTRUM(:,1)/DATA.YAG.SUM(1),DATA.AXIS.ENG,INTERP.C.CC(ind,:));
%                     
%  
%                     
%                     pause;
%                     
%                 end
%             end
%         end
%     end
% end
