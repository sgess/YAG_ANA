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

    for m = 1:8 % ramp
        bl_line1 = [];

        for l = 1:8 % compressor phase
            
            bl_line1 = [bl_line1 RES.CON.SQ(:,:,l,m,Y)];
        end
        
        bl_cat1 = [bl_cat1; bl_line1];

    end
    
    vind = RES.CON.SQIND{Y};
    ind = vind(1)+(8-1)*vind(2)+(64-1)*vind(3)+(512-1)*vind(4) + 1;
    i = vind(1)+1;
    k = vind(2)+1;
    l = vind(3)+1;
    m = vind(4)+1;
     
    figure(f1);
    imagesc(log(bl_cat1));
    colorbar;
    hold on;
    plot(k+8*(l-1),i+8*(m-1),'marker','p','color','w','markersize',25,'markerfacecolor','w');
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
