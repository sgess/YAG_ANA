figure(1);
yag_x = [];
yag_y = [];

cf_x = [];
cf_y = [];

cn_x = [];
cn_y = [];
for i =1:89 
    
    if(isempty(good_data(i).YAGS_LI20_2432.img)); continue; end;
    if(isempty(good_data(i).PROF_LI20_3483.img)); continue; end;
    if(isempty(good_data(i).PROF_LI20_3485.img)); continue; end;
    
    
    subplot(2,3,1);
    yag = rot90(good_data(i).YAGS_LI20_2432.img',2);
    imagesc(yag);
    title('YAG');
    
    subplot(2,3,2);
    cer = flipud(good_data(i).PROF_LI20_3483.img(350:1000,100:450));
    imagesc(cer);
    title('CHER FAR');
   
    subplot(2,3,3);
    near = good_data(i).PROF_LI20_3485.img(500:1100,250:500);
    imagesc(near);
    title('CHER NEAR');
    
    subplot(2,3,4);
    yag_line = mean(yag(150:175,:));
    plot(yag_line);
    axis([0 634 0 100]);
    
    subplot(2,3,5);
    cer_line = mean(cer,2);
    plot(cer_line);
    axis([0 650 100 1000]);

    subplot(2,3,6);
    near_line = mean(near,2);
    plot(near_line);
    axis([0 600 10 200]);
    
    pause(0.5); 

end
