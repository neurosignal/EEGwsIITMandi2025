%% Usage:      Forward model preparation.
%% Created on: July 19, 2025
%% Created by: Amit Jaiswal @ MEGIN Oy, Espoo, Finland <amit.jaiswal@megin.fi>
%% 
%% Add fieldtrip in path
clc
clear all
restoredefaultpath 
code_dir = '.'; % <<<< change this as per your directory name
ft_dir   = '..//..//MyGitHubRepos//fieldtrip//'; % <<<< change this as per your directory name
addpath(ft_dir)
ft_defaults
cd(code_dir)
addpath('functions/')
ver

%% Load clean data and other info.
data_dir    = '..//..//..//Workshop_IITMandi/'; % <<<< change this as per your directory name
filename    = [data_dir, 'sample_audvis_raw_eeg_leadfields.mat'];
mri_fname   = [data_dir, 'sample_T1.nii'];
aligned_mri_fname = replace(mri_fname, '.nii', '_aligned.mat');
seg_mri_fname     = replace(mri_fname, '.nii', '_aligned_seg.mat');

load(filename) 

%% Select stimulus category and covariance windows
stimulus = 'VEF-L';
epochs = epochs_all(stimulus);
evoked = evoked_all(stimulus);

cfg = [];
cfg.layout = lay2D;
cfg.viewmode = 'butterfly';
ft_databrowser(cfg, evoked);

ctrlwin = [-.5, -.05];
actiwin = [.05, .1];
% %% Calculate covariance for filter
% cfg = [];
% cfg.covariance='yes';
% cfg.covariancewindow = par.trialwin;
% cfg.vartrllength = 2;
% evoked = ft_timelockanalysis(cfg,data_stim);

%% Compute noise cov.
cfg = [];
cfg.toilim = ctrlwin;
epochs_pre = ft_redefinetrial(cfg, epochs);

cfg = [];
cfg.covariance='yes';
evoked_pre = ft_timelockanalysis(cfg,epochs_pre);

%% Compute data cov.
cfg = [];
cfg.toilim  = actiwin;
epochs_post = ft_redefinetrial(cfg, epochs_pre);

cfg = [];
cfg.covariance='yes';
evoked_post = ft_timelockanalysis(cfg,epochs);

%% Compute and apply LCMV beamformer
cfg                  = [];
cfg.method           = 'lcmv';
cfg.grid             = leadfield;
cfg.headmodel        = headmodel; 
cfg.lcmv.keepfilter  = 'yes';
cfg.lcmv.fixedori    = 'yes'; % project on axis of most variance using SVD
cfg.lcmv.reducerank  = 3;
cfg.lcmv.normalize   = 'yes';
cfg.senstype         = 'EEG';
cfg.lcmv.lambda      = '5%';
source_avg           = ft_sourceanalysis(cfg, evoked); % create spatial filters

cfg                  = [];
cfg.method           = 'lcmv';
cfg.senstype         = 'MEG';
cfg.grid             = leadfield;
cfg.grid.filter      = source_avg.avg.filter;
cfg.headmodel        = headmodel;
source_pre  = ft_sourceanalysis(cfg, evoked_pre); % apply spatial filter on noise
source_post = ft_sourceanalysis(cfg, evoked_post); % apply spatial filter on data

%% Calculate Neural Activity Index 
spatial_map = source_post;
spatial_map.avg.pow = (source_post.avg.pow-source_pre.avg.pow)./source_pre.avg.pow;

%%
cfg            = [];
cfg.downsample = 2;
cfg.parameter  = 'pow';
mapOnMRI  = ft_sourceinterpolate(cfg, spatial_map , mri);

%%
maxval = max(mapOnMRI.pow, [], 'all');

cfg = [];
cfg.method        = 'slice';
cfg.funparameter  = 'pow';
cfg.maskparameter = cfg.funparameter;
cfg.funcolorlim   = [0.0 maxval];
cfg.opacitylim    = [0.0 maxval];
cfg.opacitymap    = 'rampup';
ft_sourceplot(cfg, sourceDiffInt);

%% Find hotspot/peak location  
M1.avg.pow(isnan(M1.avg.pow))=0;
POW = abs(M1.avg.pow);
[~,hind] = max(POW);
hval = M1.avg.pow(hind);
hspot = M1.pos(hind,:)*ft_scalingfactor(headmodel.unit,'mm');
difff = sqrt(sum((actual_diploc((find(valueset==evdict(stimcat))),:)-hspot).^2));
n_act_grid = length(POW(POW > max(POW(:))*0.50));
PSVol = n_act_grid*(par.gridres^3);

