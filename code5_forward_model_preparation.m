%% Usage: Forward model preparation.
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
data_dir = '..//..//..//Workshop_IITMandi/'; % <<<< change this as per your directory name
filename = [data_dir, 'sample_audvis_raw_eeg_clean.mat'];
mri_fname= [data_dir, 'sample_T1.nii'];
aligned_mri_fname = replace(mri_fname, '.nii', '_aligned.mat');
seg_mri_fname     = replace(mri_fname, '.nii', '_aligned_seg.mat');

load(filename) % it loads par, raw_clean, epochs, evoked, trldef, and lay2D in the workspace

%% Plot electode positions and digitization points
figure; 
ft_plot_sens(raw_clean.elec, 'label', 'off', 'elecsize', 1, 'elecshape', 'circle', 'facecolor', 'red'); 
rotate3d

hsps = ft_read_headshape(par.orig_filename);
ft_plot_headshape(hsps, 'vertexcolor', 'gray', 'vertexsize', 15)

%% Assign the native coordsys for the EEG data
raw_clean.coordsys          = 'neuromag';
raw_clean.hdr.elec.coordsys = 'neuromag';

%% Read and plot MRI
mri = ft_read_mri(mri_fname);
mri.coordsys = 'scanras';
mri = ft_convert_units(mri, 'm');
hsps = ft_convert_units(hsps, 'm');

ft_sourceplot([], mri)

%% EEG-MRI coregistration
cfg             =[];
cfg.method      ='interactive';
cfg.coordsys    = 'neuromag';
cfg.parameter   = 'anatomy';
cfg.viewresult  =  'yes' ;
mri = ft_volumerealign(cfg, mri);

cfg                     = [];
cfg.method              = 'headshape';
cfg.headshape.headshape = hsps;
cfg.headshape.icp       = 'yes';
cfg.coordsys            = 'neuromag';
cfg.parameter           = 'anatomy';
cfg.viewresult          = 'yes';
mri = ft_volumerealign(cfg, mri);

%% Cross check the alignment
ft_determine_coordsys(mri, 'interactive', 'no')
ft_plot_headshape(hsps)

%% Save aligned MRI
save(aligned_mri_fname, 'mri')
clear mri

%% Segment coregisted MRI
load(aligned_mri_fname)

cfg          = [];  
cfg.output   = {'brain', 'skull', 'scalp'};
cfg.spmversion = 'spm12';
segmri = ft_volumesegment(cfg, mri);
segmri.transform = mri.transform;
segmri.anatomy   = mri.anatomy;  

save(seg_mri_fname, 'segmri')
clear segmri
disp('segmentation done.')

%% Load the coregisterd->segmented mri file and plot
load(seg_mri_fname);
cfg              = [];
cfg.funparameter = 'skull';
cfg.location     = [0,0,0];
ft_sourceplot(cfg, segmri);

%% Compute the subject's headmodel/volume conductor model
% Prepare triangular mesh
cfg        = [];
cfg.method = 'projectmesh';
cfg.numvertices = [3000 2000 1000];
cfg.tissue = {'brain', 'skull', 'scalp'};
mesh       = ft_prepare_mesh(cfg,segmri);

% compute the 3-compartment conductor model 
cfg              = [];
cfg.method       = 'dipoli'; 
cfg.tissue       = {'brain', 'skull', 'scalp'};
cfg.conductivity = [0.33 0.0125 0.33]; 
headmodel        = ft_prepare_headmodel(cfg, mesh);

save([data_dir, 'headmodel_dipoli.mat'], 'headmodel')

% plot the meshes
figure, 
ft_plot_mesh(headmodel.bnd(1), 'facecolor', 'r'), alpha .3
ft_plot_mesh(headmodel.bnd(2), 'facecolor', 'g'), alpha .2
ft_plot_mesh(headmodel.bnd(3), 'facecolor', 'b'), alpha .1
rotate3d; camlight; view(-90,0)

%% Create the subject specific grid (source space) > Compute forward model
load([data_dir, 'headmodel_dipoli.mat'])
elec_m = ft_convert_units(raw_clean.elec, 'm');

cfg                 = [];
cfg.elec            = elec_m;
cfg.headmodel       = headmodel;
cfg.grid.resolution = 8/1000;
cfg.grid.unit       = 'm';
cfg.inwardshift     = 2/1000;
src_v               = ft_prepare_sourcemodel(cfg);

cfg                 = [];
cfg.elec            = elec_m;
cfg.headmodel       = headmodel;
cfg.grid            = src_v;    
cfg.channel         = raw_clean.label;
cfg.normalize       = 'yes';    
cfg.backproject     = 'yes';
cfg.senstype        = 'EEG';
cfg.unit            = 'm';
leadfield           = ft_prepare_leadfield(cfg, raw_clean);
disp(leadfield)

%% Check whether everything is aligned and in same coordinate and unit
figure, 
ft_plot_mesh(headmodel.bnd(1), 'facecolor', 'r', 'edgecolor', 'none', 'facealpha', .1)
ft_plot_mesh(headmodel.bnd(2), 'facecolor', 'g', 'edgecolor', 'none', 'facealpha', .1)
ft_plot_mesh(headmodel.bnd(3), 'facecolor', 'b', 'edgecolor', 'none', 'facealpha', .1)
ft_plot_sens(elec_m, 'label', 'off', 'elecsize', .01, 'elecshape', 'circle', 'facecolor', 'red'); 
ft_plot_headshape(hsps, 'vertexcolor', 'm', 'vertexsize', 15)
ft_plot_mesh(src_v.pos(src_v.inside,:), 'facecolor', 'c', 'vertexsize', 20)
rotate3d, camlight, view(90,0)

%% Save leadfields and other data
save(replace(par.orig_filename, '.fif', '_leadfields.mat'), ...
    'par', 'raw_clean', 'trldef', 'epochs_all', 'evoked_all', 'lay2D', ...
    "hsps", "mri", "segmri", "mesh", "headmodel", "src_v", "leadfield", "elec_m", ...
    '-nocompression', '-v7.3')

fprintf('\nForward model is ready; now move to source_level_ERP_analysis.m\n')
