clear all;

d=importdata('LinacEnergy.txt');
KLYS_LIST = cell(length(d.data),4);
for i=1:length(d.textdata)
    KLYS_LIST{i,1} = strcat(d.textdata(i,1),':',d.textdata(i,2),':',num2str(d.data(i,1)));
    KLYS_LIST{i,2} = sscanf(char(d.textdata(i,2)),'LI%d');
    KLYS_LIST{i,3} = d.data(i,15);
    KLYS_LIST{i,4} = d.data(i,16);
end

if 0

name = [d.textdata(:,1) ':' d.textdata(:,2) ':' num2str(d.data(:,1))];


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

end