%% Usage: Source reconstruction using beamforming
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
cfg.lcmv.fixedori    = 'yes'; 
cfg.lcmv.reducerank  = 3;
cfg.lcmv.normalize   = 'yes';
cfg.senstype         = 'EEG';
cfg.lcmv.lambda      = '5%';
source_avg           = ft_sourceanalysis(cfg, evoked); % create spatial filters

cfg                  = [];
cfg.method           = 'lcmv';
cfg.senstype         = 'EEG';
cfg.grid             = leadfield;
cfg.grid.filter      = source_avg.avg.filter;
cfg.headmodel        = headmodel;
source_pre  = ft_sourceanalysis(cfg, evoked_pre); % apply spatial filter on noise
source_post = ft_sourceanalysis(cfg, evoked_post); % apply spatial filter on data

%% Calculate Neural Activity Index (NAI)
spatial_map = source_post;
spatial_map.avg.pow = (source_post.avg.pow-source_pre.avg.pow)./source_pre.avg.pow;

%% Interpolate source map with MRI
cfg            = [];
cfg.downsample = 2;
cfg.parameter  = 'pow';
mapOnMRI  = ft_sourceinterpolate(cfg, spatial_map , mri);

%% Plot source map on MRI
maxval = max(mapOnMRI.pow, [], 'all');

cfg = [];
cfg.method        = 'ortho';
cfg.funparameter  = 'pow';
cfg.maskparameter = cfg.funparameter;
cfg.funcolorlim   = [0.0 maxval];
cfg.opacitylim    = [0.0 maxval];
cfg.opacitymap    = 'rampup';
cfg.atlas         = [ft_dir, 'template/atlas/brainnetome/BNA_MPM_thr25_1.25mm.nii'];
ft_sourceplot(cfg, mapOnMRI)

%% TODO: Get source time-series ??
