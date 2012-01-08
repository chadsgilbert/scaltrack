function varargout = hist(trobj, varargin)
%HIST overloads HIST for the Track class.
%  HIST plots a histogram of the plds for a track object.
%
%  HIST(TROBJ) makes the histogram.
%
%  HIST(TROBJ, OPT, VAL) changes the option OPT to value, VAL. There are
%  currently no options. The options are:
%    'color' - a 1x3 RGB vector. Default light gray ([0.5 0.5 0.5]).
%    'axis'  - a 1x4 position vector. Default [30 60 0 30].
%    'tvec'  - a vector of the PLDs to use as bins. Default 30:60.
%    'title' - a string. Default read from metadata in the Track object.
%    'ylab'  - a string. Default is 'Frequency [%]'.
%    'xlab'  - a string. Default is 'PLD [days]'.
%
%  H = HIST(TROBJ) returns a handle to the axes.
%
%  Example:
%  >> hist(tr_fal_pa);
%  makes a histogram of the plds.
%
%See also: Track

% Set the default option values.
opts.color = [0.5 0.5 0.5];
opts.axis = [30 60 0 30];
opts.tvec = 30:60;
opts.title = ['(' trobj.season ', ' trobj.behaviour ')'];
opts.ylab = 'Frequency [%]';
opts.xlab = 'PLD [days]';
opts.fontname = 'arial';
opts.fontsize = 12;

% Replace any specified option values.
for i = 1:2:(nargin-1)
    opts.(varargin{i}) = varargin{i+1};
end

% Make the plot.
pld = get_pld(trobj);
pld_bar = 100*hist(pld, opts.tvec)./sum(~isnan(pld));
bar(opts.tvec, pld_bar, 1, 'facecolor', opts.color);
axis(opts.axis);
xlabel(opts.xlab, 'fontname', opts.fontname, 'fontsize', opts.fontsize);
ylabel(opts.ylab, 'fontname', opts.fontname, 'fontsize', opts.fontsize);
title(opts.title, 'fontname', opts.fontname, 'fontsize', opts.fontsize);

% Assign the output arguments.
switch nargout
    case 0
        
    case 1
        varargout{1} = gca;
    otherwise
        error('Too many output arguments requested.');
end

end