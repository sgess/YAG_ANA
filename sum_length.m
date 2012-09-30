clear all;

d=importdata('LinacEnergy.txt');
sect_leff = zeros(18,1);
sect_ampl = zeros(18,1);
for i=1:18
    
    sect_leff(i) = sum(strcmp(d.textdata(:,2),['LI' num2str(i+1,'%02d')]).*d.data(:,15));
    sect_ampl(i) = sum(strcmp(d.textdata(:,2),['LI' num2str(i+1,'%02d')]).*d.data(:,16));
    
end

sect_leff
sum(sect_leff(1:9))
sum(sect_leff(10:18))

sect_ampl
sum(sect_ampl(1:9))
sum(sect_ampl(10:18))