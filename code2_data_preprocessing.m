%% Usage:      Data preprocessing/ signal enrichment
%% Created on: July 19, 2025
%% Created by: Amit Jaiswal @ MEGIN Oy, Espoo, Finland <amit.jaiswal@megin.fi>
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
ver

%% Load Data
data_dir = '..//..//..//Workshop_IITMandi/'; % <<<< change this as per your directory name
filename = [data_dir, 'sample_audvis_raw_eeg.mat'];

load(filename) % it loads par, artf, trldef, and raw in the workspace

%% Preprocess continuous raw data
cfg = [];
cfg.detrend    = 'yes';
cfg.demean     = 'yes';
cfg.bpfilter   = 'yes'; 
cfg.bpfiltord  = 2;
cfg.bpfilttype = 'but';
cfg.bpfreq     = par.bpfreq;
cfg.channel    = {'EEG*'};
rawfilt_eeg  = ft_preprocessing(cfg, raw);
cfg.channel    = {'EOG*', 'ECG*', 'EMG*'};
rawfilt_bio  = ft_preprocessing(cfg, raw);

%% Review
cfg_browse = [];
cfg_browse.viewmode  = 'vertical';
cfg_browse.blocksize = 5;
ft_databrowser(cfg_browse, rawfilt_eeg);
ft_databrowser(cfg_browse, rawfilt_bio);

%% Reconstruct bad channels
cfg = [];
cfg.method   = 'triangulation';
cfg.elec     = raw.elec;
cfg.channel  = {'EEG*'};
cfg.layout   = lay2D;
cfg.feedback = 'yes';
neighbours = ft_prepare_neighbours(cfg, rawfilt_eeg);

cfg = [];
cfg.senstype   = 'eeg';
cfg.method     = 'spline'; 
cfg.badchannel = par.badch; 
cfg.neighbours = neighbours;
rawfilt_eeg = ft_channelrepair(cfg, rawfilt_eeg);

%% Review 
ft_databrowser(cfg_browse, rawfilt_eeg);

%% Average re-reference
cfg = [];
cfg.reref      = 'yes';
cfg.refchannel = 'all';
cfg.refmethod  = 'avg';
cfg.channel    = 'EEG*'; 
rawfilt_eeg  = ft_preprocessing(cfg, rawfilt_eeg);

%% Review 
ft_databrowser(cfg_browse, rawfilt_eeg);

%% Apply ICA
n_ic = 40;
                    
% Downsample aata
cfg = []; 
cfg.resamplefs = rawfilt_eeg.hdr.Fs/2;
cfg.feedback   = 'text';
data_ds = ft_resampledata(cfg, rawfilt_eeg);

% Run ICA on downsampled data
cfg              = [];
cfg.method       = 'runica'; 
cfg.channel      = 'EEG*';  
cfg.numcomponent = n_ic;   
comp_ds = ft_componentanalysis(cfg, data_ds);

% Review components
cfg           = []; 
cfg.viewmode  = 'component'; 
cfg.layout    = lay2D;
cfg.blocksize = 10;
ft_databrowser(cfg, comp_ds)

% Decompose the original data 
cfg           = [];
cfg.topolabel = comp_ds.topolabel;
cfg.unmixing  = comp_ds.unmixing;
comp          = ft_componentanalysis(cfg, rawfilt_eeg);

% Identify bad components
automated = [];
manual    = input('Enter the indices of the bad components (e.g., [1 2 3]):');

% Reject bad components and reconstruct clean data
cfg           = [];
cfg.component = union(automated, manual);
raw_clean    = ft_rejectcomponent(cfg, comp, rawfilt_eeg);

%% Review
cfg_browse.ylim = [-1e-5, 1e-5];
cfg_browse.viewmode   = 'vertical';
ft_databrowser(cfg_browse, rawfilt_eeg);
ft_databrowser(cfg_browse, raw_clean);

%% Save data and other info. in a mat file
save(replace(filename, '.mat', '_clean.mat'),...
    'par', 'raw_clean', 'trldef', 'lay2D',...
    '-nocompression', '-v7.3')

fprintf('\nClean data saved; now move to sensor_level_ERP_analysis.m\n')

%% *****************************


