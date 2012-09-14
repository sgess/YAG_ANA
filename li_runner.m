[z_microns,e_percent,e_average,e_fwhm,z_fwhm,z_average,e_avg_cut,num_part]=LiTrack('FACET');

section_list{1} = 'After NDR';
section_list{2} = 'After Compressor';
section_list{3} = 'After NRTL';
section_list{4} = 'Before S10';
section_list{5} = 'After S10';
section_list{6} = 'Before S20';
section_list{7} = 'After S20';
section_list{8} = 'Clip Phase Space';

for i=1:8
    
    h = hist(e_percent(1:num_part(i),i),200);
    ee = linspace(min(e_percent(1:num_part(i),i)),max(e_percent(1:num_part(i),i)),200);
    plot(ee,h);
    xlabel('\delta','FontSize',16);
    ylabel('Particles per bin','FontSize',16);
    title(section_list{i});
    %set(get(gca,'child'),'FaceColor','none','EdgeColor','r');
    %pause;
    
end