function varargout = scatter_gif(this, varargin)
%SCATTER_GIF makes a gif animation of the Track.
%  SCATTER_GIF uses MATLAB built-ins to make a move of the particle-tracking
%  simulation using dots to represent particles.
%
%  SCATTER_GIF(TRACKOBJ) makes the gif
%
%  SCATTER_GIF(TRACKOBJ, 'save', FILEPATH) places the resulting gif in the path
%  designated by the string, FILEPATH.
%
%  SCATTER_GIF(TRACKOBJ, 'plot', {OBJ1, OBJ2, ... OBJN}) uses the plot command
%  to plot a background for the movie.
%
%  IM = SCATTER_GIF(...) returns the images. This is an array of images created
%  using the MATLAB builtin function 'imwrite'.
%
%  Example:
%    >> scatter_gif(track_fal_py_gsc, '~');
%  makes and saves a gif of the track in the home directory.
%
%    >> scatter_gif(track, 'plot', {domain, gsc}, 'save', '~');
%  makes the movie on top of a plot of the domain and the gsc.
%
%See also: Track, scatter, imwrite

% Default optional arguments.
opts.save = '.';
opts.plot = {};
opts.ipld = {};
opts.date = true;
opts.loc = [1.25e6, -3.1e5];

% Assign any optional arguments passed in.
for i = 1:2:(nargin-1)
    opts.(varargin{i}) = varargin{i+1};
end

% Make the background plot.
hold on;
for i = 1:length(opts.plot)
    plot(opts.plot{i});
end

% Get the simlength.
switch this.season
    case 'Fall'
        simlen = 68;
    case 'Spring'
        simlen = 95;
    otherwise
        error('Invalid Track object in use.');
end

one = ones(size(this.x(:,1)));
pause(.5);
% Save the initial frame, just to get the image and colormap prepared.
if opts.date
    ht=text(opts.loc(1), opts.loc(2), datestr(this.yd(i),'mmm dd'), ...
        'fontsize', 16);
else
    ht=text(opts.loc(1), opts.loc(2), num2str(this.yd(i),'%03d'), ...
        'fontsize', 16);
end
h=scatter(this, 'ipld', one, 'format', {'b','filled','MarkerEdgeColor', 'k'});
pause(.2);
f = getframe;
[im,cm] = rgb2ind(f.cdata,256,'nodither');
im(1,1,1,simlen) = NaN;
delete(h); delete(ht);

for i = 2:simlen
    h=scatter(this, 'ipld', i*one, 'format', ...
        {'b','filled','MarkerEdgeColor', 'k'});
    if opts.date
        ht=text(opts.loc(1), opts.loc(2), datestr(this.yd(i),'mmm dd'), ...
            'fontsize', 16);
    else
        ht=text(opts.loc(1), opts.loc(2), num2str(this.yd(i),'%03d'), ...
            'fontsize', 16);
    end
    f = getframe;
    im(:,:,1,i) = rgb2ind(f.cdata, cm, 'nodither');
    delete(h); delete(ht);
end

% Save the gif.
fname = [opts.save filesep inputname(1) '.gif'];
imwrite(im, cm, fname, 'DelayTime', 0.4, 'LoopCount', 1);
close;

% Assign the outputs.
switch nargout
    case 0
    case 1
        varargout{1} = im;
    case 2
        varargout{1} = im;
        varargout{2} = cm;
    otherwise
        error('Too many output arguments requested.');
end

end