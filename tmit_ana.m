clear all;

data_dir = '/Users/sgess/Desktop/FACET/2012/DATA/E200_1103/';

slim_name  = 'E200_1103_Slim.mat';

load([data_dir slim_name]);

toro_ind;
bpm_ind;

%number of shots
nShots = length(good_data);
toros = length(TORO_IND);
bpms = length(BPM_IND);

toro_tmit = zeros(nShots,toros);
toro_stat = zeros(nShots,toros);
bpm_tmit = zeros(nShots,bpms);
bpm_stat = zeros(nShots,bpms);

for i = 1:nShots
    
    for j = 1:toros
        
        toro_tmit(i,j) = good_data(i).aida.toro(TORO_IND(j)).tmit;
        toro_stat(i,j) = good_data(i).aida.toro(TORO_IND(j)).stat;
        
    end
    
    for k = 1:bpms
        
        bpm_tmit(i,k) = good_data(i).aida.bpms(BPM_IND(k)).tmit;
        bpm_stat(i,k) = good_data(i).aida.bpms(BPM_IND(k)).stat;
        
    end
    
end

toro_stat(toro_stat > 1000) = 0;
toro_stat(toro_stat > 0 & toro_stat < 1000) = 1;
bpm_stat(bpm_stat > 1000) = 0;
bpm_stat(bpm_stat > 0 & bpm_stat < 1000) = 1;

subplot(2,2,1);
plot(toro_tmit(:,3),toro_tmit(:,4),'*');
subplot(2,2,2);
plot(bpm_tmit(:,24),bpm_tmit(:,26),'*');
subplot(2,2,3);
plot(bpm_tmit(:,26),toro_tmit(:,4),'*');
