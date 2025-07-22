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

%% Define filter


%% Map source


%% Plot

