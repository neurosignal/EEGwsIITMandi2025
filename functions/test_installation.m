fprintf('################################################################\n');
fprintf('computer: %s\n', computer);
ver;

[ftver, ftpath] = ft_version;
fprintf('FieldTrip path is at: %s\n', ftpath);
fprintf('FieldTrip version is: %s\n', ftver);
fprintf('ttest is:        %s\n', which('ttest'))
fprintf('imdilate is:     %s\n', which('imdilate'));
fprintf('dpss is:         %s\n', which('dpss'));
fprintf('fminunc is:      %s\n', which('fminunc'));
fprintf('ft_read_data is: %s\n', which('ft_read_data'));
fprintf('runica is:       %s\n', which('runica'));  % should not be found yet, or the fieldtrip version
fprintf('spm is:          %s\n', which('spm'));     % should not be found yet, or the fieldtrip version
fprintf('################################################################\n');