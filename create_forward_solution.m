%% Usage:      Forward model preparation.
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

%% Load clean data and other info.
data_dir = '..//..//..//Workshop_IITMandi/'; % <<<< change this as per your directory name
filename = [data_dir, 'sample_audvis_raw_eeg_clean.mat'];

load(filename) % it loads par, raw_clean, epochs, evoked, trldef, and lay2D in the workspace

%%

raw.elec.coordsys     = 'neuromag';
raw.hdr.elec.coordsys = 'neuromag';

%% Plot sens position
figure; 
ft_plot_sens(raw.elec, 'label', 'off', 'elecsize', 1, 'elecshape', 'circle', 'facecolor', 'red'); 
rotate3d