%R56_list = [0 1 2 2.2 2.4 2.6 2.8 3 3.2 3.4 3.6 3.8...
%    4 4.5 5 5.5 6 6.5 7 7.5 8 8.5 9 9.5 10];

R56_list = [0 1 2 3 ...
    4 5 6 7 8 9 10];

%R56_list = [2.2 2.4 2.6 2.8 ...
%    3.2 3.4 3.6 3.8 4.5 5.5 6.5 7.5 8.5 9.5];


file_head = 'RMAT_';
file_ext  = '.txt';

N = length(R56_list);

MAT_STRUCT.R56 = zeros(1,N);
MAT_STRUCT.T566 = zeros(1,N);
MAT_STRUCT.NOTCH_R16 = zeros(1,N);
MAT_STRUCT.NOTCH_T166 = zeros(1,N);
MAT_STRUCT.NOTCH_BPM_R16 = zeros(1,N);
MAT_STRUCT.NOTCH_BPM_T166 = zeros(1,N);
MAT_STRUCT.YAG_R16 = zeros(1,N);
MAT_STRUCT.YAG_T166 = zeros(1,N);
MAT_STRUCT.YAG_BPM_R16 = zeros(1,N);
MAT_STRUCT.YAG_BPM_T166 = zeros(1,N);

NOTCH = 8;
NOTCH_BPM = 10;
YAG = 154;
YAG_BPM = 159;


for i = 1:N
    
    num = num2str(10*R56_list(i),'%02d');
    file_name = [file_head num file_ext];
    
    dat = importdata(file_name);
    
    MAT_STRUCT.R56(i) = dat.data(end,4);
    MAT_STRUCT.T566(i) = dat.data(end,5);
    MAT_STRUCT.NOTCH_R16(i) = dat.data(NOTCH,2);
    MAT_STRUCT.NOTCH_T166(i) = dat.data(NOTCH,3);
    MAT_STRUCT.NOTCH_BPM_R16(i) = dat.data(NOTCH_BPM,2);
    MAT_STRUCT.NOTCH_BPM_T166(i) = dat.data(NOTCH_BPM,3);
    MAT_STRUCT.YAG_R16(i) = dat.data(YAG,2);
    MAT_STRUCT.YAG_T166(i) = dat.data(YAG,3);
    MAT_STRUCT.YAG_BPM_R16(i) = dat.data(YAG_BPM,2);
    MAT_STRUCT.YAG_BPM_T166(i) = dat.data(YAG_BPM,3);
    
end

save('mat_vals.mat','MAT_STRUCT');