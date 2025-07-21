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
data_dir = '..//..//..//Workshop_IITMandi/'; % <<<< change this as per your directory name
filename = [data_dir, 'sample_audvis_raw_eeg_clean.mat'];
mri_fname= [data_dir, 'sample_T1.nii'];

load(filename) % it loads par, raw_clean, epochs, evoked, trldef, and lay2D in the workspace

%% Forward model parametres
par.gridres = 10; %mm

%% Plot sens position
figure; 
ft_plot_sens(raw_clean.elec, 'label', 'off', 'elecsize', 1, 'elecshape', 'circle', 'facecolor', 'red'); 
rotate3d

%% Assign the native coordsys for the EEG data
raw_clean.coordsys          = 'neuromag';
raw_clean.hdr.elec.coordsys = 'neuromag';

%% Read and plot MRI
mri = ft_read_mri(mri_fname);
mri.coordsys = 'scanras';
mri = ft_convert_units(mri, 'm');

ft_sourceplot([], mri)

%% EEG-MRI coregistration
hsp = ft_read_headshape(par.orig_filename, 'unit', 'm');

cfg             =[];
cfg.method      ='interactive';
cfg.coordsys    = 'neuromag';
cfg.parameter   = 'anatomy';
cfg.viewresult  =  'yes' ;
[mri] = ft_volumerealign(cfg, mri);

%% Cross check the alignment
ft_determine_coordsys(mri, 'interactive', 'no')
ft_plot_headshape(hsp)

%% Segment coregisted MRI, if needed
if isequal(par.mri_seg, 'yes')
    if ~isequal(par.mri_align, 'yes') % assuming that the given 'mrifname' is already coregistered
        mri = ft_read_mri(mrifname);
    end
    cfg          = [];  
    cfg.output   = 'brain';
    cfg.spmversion = 'spm12';
    segmri = ft_volumesegment(cfg, mri);
    segmri.transform = mri.transform;
    segmri.anatomy   = mri.anatomy;  
end

%% Reading the coregisterd and segmented mri file
if exist(segmrifname, 'file')==2 && ~isequal(par.mri_seg, 'yes')
    load(segmrifname); 
end

%% Plot segmented MRI volume
if par.more_plots
    cfg              = [];
    cfg.funparameter = 'brain';
    cfg.location     = [0,0,0];
    ft_sourceplot(cfg, segmri);
end
   
%% Compute the subject's headmodel/volume conductor model
if ~exist('headmodel', 'var')
    cfg                = [];
    cfg.method         = 'singleshell';
    % cfg.tissue         = 'brain';
    headmodel          = ft_prepare_headmodel(cfg, segmri);
end
if par.more_plots, figure, ft_plot_vol(headmodel, 'facecolor', 'brain'), rotate3d;  end

%% Create the subject specific grid (source space) > Compute forward model
if ~exist('leadfield', 'var') || length(data.label)~=length(leadfield.label)
    cfg                 = [];
    cfg.grad            = ft_convert_units(data.grad, headmodel.unit);
    cfg.headmodel       = headmodel;
    if isequal(headmodel.unit, 'mm')
        cfg.grid.resolution = par.gridres;
    elseif isequal(headmodel.unit, 'm')
        cfg.grid.resolution = par.gridres/1000;
    end
    cfg.grid.unit       = headmodel.unit;
    src_v               = ft_prepare_sourcemodel(cfg);
    
    cfg                 = [];
    cfg.grad            = ft_convert_units(data.grad, headmodel.unit);  
    cfg.headmodel       = headmodel;
    cfg.grid            = src_v;    
    cfg.channel         = data.label;
    cfg.normalize       = 'yes';    
    cfg.backproject     = 'yes';
    cfg.senstype        = 'MEG';
    leadfield           = ft_prepare_leadfield(cfg, data);
else
    disp('Using precomputed computed leadfield...')
end

%% Check whether everything is aligned and in same coordinate and unit
if par.more_plots
    ft_plot_alignment_check(fname, par, segmri, data, leadfield, headmodel)
end
clear src_v mri