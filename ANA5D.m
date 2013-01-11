bl_cat1 = [];
bl_cat2 = [];
bl_cat3 = [];
bl_cat4 = [];
bl_cat5 = [];
bl_cat6 = [];
for k = 1:6 % ramp
    bl_line1 = [];
    bl_line2 = [];
    bl_line3 = [];
    bl_line4 = [];
    bl_line5 = [];
    bl_line6 = [];
    for l = 1:6 % compressor phase
        
        bl_line1 = [bl_line1 I_sig(:,:,k,l,1,2)];
        bl_line2 = [bl_line2 I_sig(:,:,k,l,2,2)];
        bl_line3 = [bl_line3 I_sig(:,:,k,l,3,2)];
        bl_line4 = [bl_line4 I_sig(:,:,k,l,4,2)];
        bl_line5 = [bl_line5 I_sig(:,:,k,l,5,2)];
        bl_line6 = [bl_line6 I_sig(:,:,k,l,6,2)];
        
    end
    
    bl_cat1 = [bl_cat1; bl_line1];
    bl_cat2 = [bl_cat2; bl_line2];
    bl_cat3 = [bl_cat3; bl_line3];
    bl_cat4 = [bl_cat4; bl_line4];
    bl_cat5 = [bl_cat5; bl_line5];
    bl_cat6 = [bl_cat6; bl_line6];
    
end

bl_cat = [bl_cat1 bl_cat2 bl_cat3; bl_cat4 bl_cat5 bl_cat6];


f1 = 1;
f2 = 2;
f3 = 3;
%for m = 1:6 % nrtl ampl
    for l = 6:6 % nrtl phase
        for k = 1:1 % ramp phase
            for j = 1:6 % num part
                for i = 1:6 % init length
                    
                    figure(f1);
                    imagesc(bl_cat1');
                    colorbar;
                    hold on;
                    plot(i+6*(k-1),j+6*(l-1),'marker','p','color','w','markersize',20,'markerfacecolor','w');
                    hold off;
                    I_sig(i,j,k,l,1,2)
                    
                    figure(f2);
                    plot(zz(:,i,j,k,l,m,2),bl(:,i,j,k,l,m,2));
                    
                    figure(f3);
                    plot(ee(:,i,j,k,l,m,2),es(:,i,j,k,l,m,2));
                    
                    pause;
                    
                end
            end
        end
    end
%end
