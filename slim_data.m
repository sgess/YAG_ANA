clear all;

savE = 1;

load('/Users/sgess/Desktop/data/E200_DATA/E200_1138/E200_1138_Step_1.mat');

if ~isfield(data,'Sample_05')
    error('Not enough samples. Slimmer will crash.');
elseif isfield(data,'Sample_06')
    error('Too many samples. Slimmer will crash.');
end

%Top level field names
names = fieldnames(data);

%Find 'Raw Sample'
raw = strncmp(fieldnames(data),'Raw_Sample',10);

%dump 'raw sample'
data = rmfield(data,names(raw));

%Sample level field names
names = fieldnames(data.Sample_01);

%Find profile monitors
prof = strncmp(fieldnames(data.Sample_01),'PROF',4);
otrs = strncmp(fieldnames(data.Sample_01),'OTRS',4);

%dump profile monitors
d1 = rmfield(data.Sample_01,names(prof));
d1 = rmfield(d1,names(otrs));
d2 = rmfield(data.Sample_02,names(prof));
d2 = rmfield(d2,names(otrs));
d3 = rmfield(data.Sample_03,names(prof));
d3 = rmfield(d3,names(otrs));
d4 = rmfield(data.Sample_04,names(prof));
d4 = rmfield(d4,names(otrs));
d5 = rmfield(data.Sample_05,names(prof));
d5 = rmfield(d5,names(otrs));

%Make list of events with a YAG image
nShot = length(d1);
good_yag  = zeros(nShot,5);
good_aida = zeros(nShot,5);
for i=1:nShot
    good_yag(i,1) = ~isempty(d1(i).YAGS_LI20_2432.prof_pid);
    good_yag(i,2) = ~isempty(d2(i).YAGS_LI20_2432.prof_pid);
    good_yag(i,3) = ~isempty(d3(i).YAGS_LI20_2432.prof_pid);
    good_yag(i,4) = ~isempty(d4(i).YAGS_LI20_2432.prof_pid);
    good_yag(i,5) = ~isempty(d5(i).YAGS_LI20_2432.prof_pid);
    good_aida(i,1) = ~isempty(d1(i).aida);
    good_aida(i,2) = ~isempty(d2(i).aida);
    good_aida(i,3) = ~isempty(d3(i).aida);
    good_aida(i,4) = ~isempty(d4(i).aida);
    good_aida(i,5) = ~isempty(d5(i).aida);
end

%Make sure pids line up between YAG image and Aida
yag_pid   = zeros(nShot,5);
aida_pid  = zeros(nShot,5);
for i=1:nShot
    if good_yag(i,1) == 1
        yag_pid(i,1) = d1(i).YAGS_LI20_2432.prof_pid;
    end
    if good_yag(i,2) == 1
        yag_pid(i,2) = d2(i).YAGS_LI20_2432.prof_pid;
    end
    if good_yag(i,3) == 1
        yag_pid(i,3) = d3(i).YAGS_LI20_2432.prof_pid;
    end
    if good_yag(i,4) == 1
        yag_pid(i,4) = d4(i).YAGS_LI20_2432.prof_pid;
    end
    if good_yag(i,5) == 1
        yag_pid(i,5) = d5(i).YAGS_LI20_2432.prof_pid;
    end
    
    if good_aida(i,1) == 1
        aida_pid(i,1) = d1(i).aida.pulse_id;
    end
    if good_aida(i,2) == 1
        aida_pid(i,2) = d2(i).aida.pulse_id;
    end
    if good_aida(i,3) == 1
        aida_pid(i,3) = d3(i).aida.pulse_id;
    end
    if good_aida(i,4) == 1
        aida_pid(i,4) = d4(i).aida.pulse_id;
    end
    if good_aida(i,5) == 1
        aida_pid(i,5) = d5(i).aida.pulse_id;
    end
end

check = (good_yag & good_aida).*(yag_pid-aida_pid);
if sum(sum(check)) ~= 0; error('Stuff don"t line up.'); end;

%Assemble a single good data struct
good_data = [d1((good_yag(:,1) & good_aida(:,1))') d2((good_yag(:,2) & good_aida(:,2))')...
    d3((good_yag(:,3) & good_aida(:,3))') d4((good_yag(:,4) & good_aida(:,4))') d5((good_yag(:,5) & good_aida(:,5))')];  
    

if savE; save('/Users/sgess/Desktop/data/E200_DATA/E200_1138/E200_1138_Slim.mat','good_data'); end;