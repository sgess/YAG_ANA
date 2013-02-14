figure(1);
for i =2:19 
    
    subplot(2,2,1);
    yag = rot90(data.Sample_02(i).YAGS_LI20_2432.img',2);
    imagesc(yag);
    
    subplot(2,2,2);
    cer = data.Sample_02(i).PROF_LI20_3483.img(800:1100,600:750)';
    imagesc(cer);
    
    subplot(2,2,3);
    yag_line = mean(yag(100:125,:));
    plot(yag_line);
    axis([0 608 0 100]);
    
    subplot(2,2,4);
    cer_line = mean(cer);
    plot(cer_line);
    axis([0 300 0 800]);

    disp(data.Sample_02(i).aida.klys.phase);
    pause; 

end
