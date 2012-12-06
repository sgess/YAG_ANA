clear all;

data_dir = '/Users/sgess/Desktop/data/E200_DATA/E200_1138/';
data_fat = 'E200_1138_Step_1.mat';
data_thin = 'E200_1138_Slim.mat';

savE = 1;

%load file to be slimmed
load([data_dir data_fat]);

%Top level field names
names = fieldnames(data);

%Find number of samples
samp = strncmp(fieldnames(data),'Sample_',7);
samples = names(samp);

%Check that we get the right number of samples
nSamp = length(samples);
Num = num2str(nSamp,'%02d');
if strcmp(samples(end),['Sample_' Num])
    disp(['There are ' Num ' samples.']);
else
    error('Sample indexing does not match number of samples.');
end

%Find 'Raw Sample'
raw = strncmp(fieldnames(data),'Raw_Sample',10);

%dump 'raw sample'
data = rmfield(data,names(raw));

%Sample level field names
names = fieldnames(data.Sample_01);

%Find profile monitors
prof = strncmp(fieldnames(data.Sample_01),'PROF',4);
otrs = strncmp(fieldnames(data.Sample_01),'OTRS',4);

%dump profile monitors and cocatanate samples
for i=1:nSamp;
    
    Num = num2str(i,'%02d');
    
    d1 = rmfield(data.(['Sample_' Num]),names(prof));
    d1 = rmfield(d1,names(otrs));
    if exist('d','var')
        d = [d d1];
    else
        d = d1;
    end
    
end

%get list of good YAG and AIDA data
nShot = length(d);
good_yag  = zeros(1,nShot);
good_aida = zeros(1,nShot);
for i=1:nShot
    
    good_yag(i)  = ~isempty(d(i).YAGS_LI20_2432.prof_pid);
    good_aida(i) = ~isempty(d(i).aida);
    
end

%Make sure pids line up between YAG image and Aida
yag_pid   = zeros(1,nShot);
aida_pid  = zeros(1,nShot);
for i=1:nShot
    
    if good_yag(i) == 1
        yag_pid(i) = d(i).YAGS_LI20_2432.prof_pid;
    end
    
    if good_aida(i) == 1
        aida_pid(i) = d(i).aida.pulse_id;
    end

end

check = (good_yag & good_aida).*(yag_pid-aida_pid);
if sum(sum(check)) ~= 0; error('Stuff don"t line up.'); end;

%Assemble a single good data struct
good_data = d(good_yag & good_aida);
    

if savE; save([data_dir data_thin],'good_data'); end;
