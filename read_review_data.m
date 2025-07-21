%% Usage:      Read and review data
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

%% Set data directory and other parameters
data_dir = '..//..//..//Workshop_IITMandi/'; % <<<< change this as per your directory name
filename = [data_dir, 'sample_audvis_raw_eeg.fif'];

par            = [];
par.bpfreq     = [1 45];
par.cov_cut    = [2, 98]; 

%% Browse/review raw data
cfg          = [];
cfg.viewmode = 'vertical'; % 'butterfly'
cfg.blocksize= 5;
cfg.dataset  = filename;
cfg.preproc.demean   = 'yes';
artf = ft_databrowser(cfg);

%% set stimulus parameters and bad channels
par.stimchan  = 'STI 014';
par.badch     = {'EEG 053'};

%% Label event categories
par.keyset   = {'AEF-L', 'AEF-R', 'VEF-L', 'VEF-R', 'smiley face', 'button press'};
par.valueset = [1, 2, 3, 4, 5, 32];
par.evdict   = containers.Map(par.keyset, par.valueset);

%% Define trials
cfg                     = [];       
cfg.dataset             = filename;   
cfg.channel             = 'EEG*';
cfg.trialdef.eventtype  = par.stimchan;  
cfg.trialdef.eventvalue = par.valueset;      
cfg.trialdef.prestim    = 0.5;      
cfg.trialdef.poststim   = 0.5;     
trldef = ft_definetrial(cfg);      

%% Visualize events triggers 
ft_plot_events(trldef, par.keyset, par.valueset)

%% Read the continuous data 
cfg            = [];
cfg.continuous = 'yes';
cfg.channel    = 'all';
cfg.dataset    = filename;
raw       = ft_preprocessing(cfg);
disp(raw)

% Remove if any NaN
raw.trial{:}(isnan(raw.trial{:})) = 0; 

%% Review
cfg = [];
cfg.viewmode         = 'butterfly';
cfg.blocksize        = 5;
cfg.channel          = {'EEG*', 'EOG*', 'STI 014'};
cfg.ylim             = [-1e-4, 1e-4];
cfg.preproc.demean   = 'yes';
fg.preproc.hpfreq    = 45;
artf = ft_databrowser(cfg, raw);

%% Prepare and plot EEG layout/montage
cfg = [];
cfg.elec    = raw.elec;
cfg.channel = {'EEG*'};
lay2D = ft_prepare_layout(cfg, raw);

cfg = [];
cfg.layout = lay2D;
ft_layoutplot(cfg)

%% Save data and other info. in a mat file
save(replace(filename, '.fif', '.mat'),...
    'par', 'artf', 'raw', 'trldef', 'lay2D',...
    '-nocompression', '-v7.3')

fprintf('\nData saved; now move to data_preprocessing.m\n')