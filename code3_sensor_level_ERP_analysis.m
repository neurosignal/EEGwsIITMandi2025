%% Usage:  Sensor-level ERP analysis
%% 
%% Add fieldtrip in path
clc
clear all
restoredefaultpath 
code_dir = '.'; % <<<< change this as per your directory name
ft_dir   = '..//..//TPTools//fieldtrip//'; % <<<< change this as per your directory name
addpath(ft_dir)
ft_defaults
cd(code_dir)
addpath('functions/')

%% Load clean data and other info.
data_dir = '..//..//..//Workshop_IITMandi/'; % <<<< change this as per your directory name
filename = [data_dir, 'sample_audvis_raw_eeg_clean.mat'];

load(filename) % it loads par, raw_clean, trldef, and lay2D in the workspace

%% MAke containers to hold segmented and averaged data
epochs_all = containers.Map();
evoked_all = containers.Map();

%% Segment the data / epoching

stimulus= 'VEF-L'; % <<< change this
t1      = 0.070;   % <<< change this
t2      = 0.100;   % <<< change this 

stimID  = par.evdict(stimulus);

cfg     = [];
cfg.trl = trldef.trl(trldef.trl(:,end)==stimID,:); 
epochs = ft_redefinetrial(cfg, raw_clean);
disp(epochs)

%% Review
cfg = [];
cfg.viewmode   = 'butterfly';
ft_databrowser(cfg, epochs);

%% Bad Trial removal
cfg             = [];
cfg.elec        = epochs.elec;
cfg.senstype    = 'eeg';
cfg.method      = 'summary';
cfg.layout      = lay2D;
cfg.keepchannel = 'nan';
cfg.keeptrial   = 'no';
epochs  = ft_rejectvisual(cfg, epochs);

%% Baseline correction
cfg = [];
cfg.demean = 'yes';
cfg.baselinewindow = [-0.5, -0.01];
epochs = ft_preprocessing(cfg, epochs);

%% Average good trials
cfg = [];
cfg.covariance       = 'yes';
cfg.covariancewindow = 'all';
cfg.vartrllength     = 2;
evoked = ft_timelockanalysis(cfg, epochs);

%% Review / Latency plot
cfg = [];
cfg.viewmode = 'butterfly';
cfg.layout   = lay2D;
ft_databrowser(cfg, evoked);

%% Totoplot and topomap
cfg = [];
cfg.layout = lay2D;
ft_multiplotER(cfg, evoked)
cfg.xlim   = [t1, t2];
ft_topoplotER(cfg, evoked)

%% collect epochs and evoked in the containers
epochs_all(stimulus) = epochs;
evoked_all(stimulus) = evoked;
disp(epochs_all)

%% Save data and other info. in a mat file
save(filename,...
    'par', 'raw_clean', 'trldef', 'epochs_all', 'evoked_all', 'lay2D',...
    '-nocompression', '-v7.3')

fprintf('\nClean data saved; now move to source-level analysis.\n')

%% *****************************