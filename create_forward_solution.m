

raw.elec.coordsys     = 'neuromag';
raw.hdr.elec.coordsys = 'neuromag';

%% Plot sens position
figure; 
ft_plot_sens(raw.elec, 'label', 'off', 'elecsize', 1, 'elecshape', 'circle', 'facecolor', 'red'); 
rotate3d