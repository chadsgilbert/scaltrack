function varargout = plot_cfts(this,bed,varargin)
%PLOT_CFTS plots the connection fraction time-series for a Track.
%  PLOT_CFTS uses a track object and the three bed objects, GSC, NEP and SFL, to
%  compute the connection fraction time-series, or plots a given time-series.
%
%  PLOT_CFTS(TROBJ, BEDOBJ) where TROBJ is a Tack object BED is a bed object.
%
%  PLOT_CFTS(cfts); where cfts is a [cxbxn] array, where c is the number of 
%  settlement regions, b is the bnumber of beds and n is the number of 
%  time-steps at which the connection fractions were computed.
%
%  PLOT(..., OPT, VAL) where OPT is an option and VAL is a vlue for the option.
%    'xlab' - a string denoting the xlabel. Default: 'Time (Days)'.
%    'ylab' - a string denoting the ylabel. Default: 'Connection Fraction'.
%    'axis' - a 1x4 array to set the dimension of the axis. Default: [0 60 0 .5]
%    'iscolor' - a logical. true -> make a color plot. false -> make a b/w plot.
%                Default: true.
%    'filename' - a string pointing to the name of the file to be plotted.
%    'filepath' - a string pointing to the results folder to be used.
%
%  Example:
%  >> plot_cfts(trobj, gsc, nep, sfl);
%  computes and makes a plot of the time-series.
%
%See also: Track, get_connection_fraction

% Set the default options.
opts.xlab = 'Time (Days)';
opts.ylab = 'Connection Fraction';
opts.axis = [0 60 0 0.5];
opts.iscolor = true;
opts.filename = ['cf_' lower(this.season(1:3)) '_' ...
    lower(this.behaviour(1:2)) '_' lower(this.bed) '_' lower(bed.name)];
opts.filepath = '';

% Re-set any options that were passed in.
for i = 1:2:(nargin-2)
    opts.(varargin{i}) = varargin{i+1};
end

% Get the connection fraction for the bed.
if exist([opts.filepath opts.filename], 'file')
    load([opts.filepath opts.filename]);
else
    inds = round((24/12.42)*opts.axis(1)+1):floor((24/12.42)*opts.axis(2)+1);
    tvec = inds*12.42/24;
    cf = NaN(size(inds));
    for i = inds
        cf(i) = get_connection_fraction(this, bed, i);
    end
    save([opts.filepath opts.filename], 'cf');
end

% Choose the color or symbol for the plot.
bed_names = {'GSC', 'NEP', 'SFL'};
switch opts.iscolor
    case true
        bed_colors = {'r' 'g' 'b'};
        symb = bed_colors{ismember(bed_names, this.bed)};
        
    case false
        bed_symbs = {'t','s','o'};
        symb = bed_symbs{ismember(bed_names, this.bed)};
        
    otherwise
        error('the iscolor option must be a true or false.');
end

% Make the plot.
plot(tvec, cf, symb);
grid on;
axis(opts.axis);

switch nargout
    case 0
        
    case 1
        varargout{1} = h;
    otherwise
        error('Too many output arguments.');
end       

end

% Resize the subplots to fit nicely together.
% set(h,  'pos', [0 0 1275 750]);
% p1n = [.10 .66 .42 .25];    set(h1, 'pos', p1n);
% p2n = [.55 .66 .42 .25];    set(h2, 'pos', p2n);
% p3n = [.10 .38 .42 .25];    set(h3, 'pos', p3n);
% p4n = [.55 .38 .42 .25];    set(h4, 'pos', p4n);
% p5n = [.10 .10 .42 .25];    set(h5, 'pos', p5n);
% p6n = [.55 .10 .42 .25];    set(h6, 'pos', p6n);
