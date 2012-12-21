%clear all;
%PARAM.NRTL.AMPL = 0.04058;
%decker = -21.46

global PARAM;

SJG_param;
r_struct;




R56 = 9; % in mm
R56_ind = R56 + 1;
PARAM.LI20.R56 = R_STRUCT(R56_ind,1);
PARAM.LI20.T566 = R_STRUCT(R56_ind,2);
PARAM.LI20.ELO   = -0.015;
%PARAM.LI20.EHI   = 0.027;

ramp = 10;
decker = -23;

PARAM.LI20.NLO = -0.010;
PARAM.LI20.NHI = 0.000;

PARAM.INIT.ASYM = -0.2;

PARAM.NRTL.AMPL = 0.0406;
PARAM.NRTL.PHAS  = 91.;
PARAM.LONE.PHAS = decker;
PARAM.LONE.GAIN = (PARAM.ENRG.E1 - PARAM.ENRG.E0)/cosd(PARAM.LONE.PHAS);
PARAM.LTWO.PHAS = ramp;

LiTrack('FACETpar');