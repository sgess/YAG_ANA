num = 1467;

data_file = ['/Users/sgess/Desktop/data/E200_DATA/E200_' num2str(num) '/E200_' num2str(num) '_Step_1.mat'];

load(data_file);

names = fieldnames(data);
dump = strncmp(names,'Raw_Sample',10);
sample = rmfield(data,names(dump));

clear('data');

