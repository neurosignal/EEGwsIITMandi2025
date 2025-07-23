%% Usage:  Time-frequency analysis
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

%% Load clean data and other info.
data_dir = '..//..//..//Workshop_IITMandi/'; % <<<< change this as per your directory name
filename = [data_dir, 'sample_audvis_raw_eeg_clean.mat'];

load(filename) % it loads par, raw_clean, trldef, and lay2D in the workspace

%% Computing power spectra
stimulus = 'VEF-R';
data  = epochs_all(stimulus);

cfg         = [];
cfg.output  = 'pow';
cfg.channel = 'EEG';
cfg.method  = 'mtmfft';
cfg.taper   = 'hanning';
cfg.foi     = 1:45;
spectra = ft_freqanalysis(cfg, data);

figure;
plot(spectra.freq, (spectra.powspctrm), 'linewidth', 2)
title(stimulus), xlabel('Frequency (Hz)'), ylabel('Power (\mu V^2)')
xlim([spectra.freq(1), spectra.freq(end)])

%% Visualization
cfg = [];
cfg.layout = lay2D;
ft_multiplotER(cfg, spectra)
cfg.xlim   = [8, 10];
cfg.marker = 'labels';
ft_topoplotER(cfg, spectra)

alpha_idx = spectra.freq > 7.8 & spectra.freq < 10.5;
figure
ft_plot_topo3d(raw_clean.elec.chanpos, mean(spectra.powspctrm(:,alpha_idx),2)); rotate3d

%% Time-frequency analysis with a Hanning taper and fixed window length
cfg            = [];
cfg.output     = 'pow';
cfg.channel    = 'all';
cfg.method     = 'mtmconvol';
cfg.taper      = 'hanning';
cfg.toi        = data.time{1};
cfg.foi        = 1 : 1 : 45;
cfg.t_ftimwin  = ones(size(cfg.foi)) * 0.5;
tfr  = ft_freqanalysis(cfg, data);

%% Visualization
cfg              = [];
cfg.baseline     = [-0.5 -0.1];
cfg.baselinetype = 'absolute';
cfg.xlim         = [0.05 0.4];  % in seconds
cfg.ylim         = [13 30];     % in Hz
cfg.zlim         = 'maxabs';
cfg.marker       = 'on';
cfg.colorbar     = 'yes';
cfg.layout       = lay2D;

figure;
ft_topoplotTFR(cfg, tfr);
title(stimulus);

%% Time-frequency representation of power at an electrode.
cfg          = [];
cfg.colorbar = 'yes';
cfg.zlim     = 'maxabs';
cfg.ylim     = [7 Inf]; 
cfg.layout   = lay2D;
cfg.channel  = 'EEG054';

figure;
ft_singleplotTFR(cfg, tfr);
title(stimulus);
