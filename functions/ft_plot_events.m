function ft_plot_events(cfg, keyset, valueset)
%%
% Usage: FT_PLOT_EVENTS plots timelocked events as assigned in keyset and valueset
%        && also shows the number of trials for each event category
% Inputs: 
%           cfg      = cfg    , defined by ft_definetrial
%           keyset   = 1xn cell array of event names,  where n= no. of event categories
%           valueset = 1xn cell array of event values, where n= no. of event categories
% Example: 
%           cfg      = cfg;
%           keyset   = {'VEF-UR', 'VEF-LR', 'AEF-Le', 'VEF-LL', 'AEF-Re', 'VEF-UL', 'SEF-Lh', 'SEF-Rh'};
%           valueset = [1,2, 3, 4, 5, 8, 16, 32];
%
%           ft_plot_events(cfg, keyset, valueset)
%
% Author: Amit Jaiswal @ MEGIN (Elekta Oy), Helsinki, Finland

% Create figure and axes
fig = figure('Units', 'pixels');
defaultPos = get(fig, 'Position');  % [left bottom width height]
defaultPos(3) = defaultPos(3) * 2;  % double the width
set(fig, 'Position', defaultPos);
ax = axes('Parent', fig, 'YTick', valueset);
box(ax, 'on');
hold(ax, 'on');

% Plot each value in valueset
for i = 1:length(valueset)
    val = valueset(i);
    idx = cfg.trl(:, 4) == val;
    count = sum(cfg.trl(:, 4) == val);
    dispText = sprintf('%s (# %d)', char(keyset(i)), count);
    plot(cfg.trl(idx, 1), cfg.trl(idx, 4), ...
        'Marker', 'o', 'LineStyle', 'none', 'LineWidth', 2, ...
        'DisplayName', dispText);
end

% Add legend only if one stimulus
if length(keyset) < 2
    legend(sprintf('%s : %d', char(keyset), length(cfg.trl(:, 4))));
else
    lgd = legend('show', 'Location', 'bestoutside');
    set(lgd, 'FontSize', 14);
end

% Set axes limits and labels
xlim([cfg.trl(1, 1), cfg.trl(end, 2)]);
ylabel('Event ID', 'FontSize', 12);
xlabel('Latency (ms)', 'FontSize', 12);
title('Events Plot', 'FontSize', 12);

end

