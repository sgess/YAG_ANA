figure(1);
for i =1:89 
    
    if(isempty(good_data(i).YAGS_LI20_2432.img)); continue; end;
    if(isempty(good_data(i).PROF_LI20_3483.img)); continue; end;
    if(isempty(good_data(i).PROF_LI20_3485.img)); continue; end;
    
    subplot(2,3,1);
    yag = rot90(good_data(i).YAGS_LI20_2432.img',2);
    imagesc(yag);
    
    subplot(2,3,2);
    cer = good_data(i).PROF_LI20_3483.img(700:1000,150:350);
    imagesc(cer);
    
    subplot(2,3,3);
    near = good_data(i).PROF_LI20_3485.img(500:800,200:500);
    imagesc(near);
    
    subplot(2,3,4);
    yag_line = mean(yag(150:175,:));
    plot(yag_line);
    axis([0 634 0 100]);
    
    subplot(2,3,5);
    cer_line = mean(cer,2);
    plot(cer_line);
    axis([100 200 100 1000]);

    subplot(2,3,6);
    near_line = mean(near,2);
    plot(near_line);
    axis([0 300 0 200]);
    
    pause; 

end
