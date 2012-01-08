function varargout = zoom(this, varargin)
%ZOOM zooms the MATLAB figure in on one bed in the GB plot for easy viewing.
%
%  ZOOM(BEDOBJ) where bed is a string of a polygon ro a list of points within 
%  the bed. Pretty much, whatever you got, give it to me.
%
%  Example:
%    >> zoom(bedobj)
%    changes the current figure dimensions and focuses the figure on the
%    appropriate coodinates.
%
%See also: Bed, plot, scatter

% Assign input arguments.
switch nargin
    case 1
        f = gcf;
    case 2
        f = varargin{1};
    otherwise
        error('Wrong number of input arguments.');
end

% Calculate the boundaries and aspect-ratio for the figure.
minx = min(this.x0);
maxx = max(this.x0);
miny = min(this.y0);
maxy = max(this.y0);
ar = (maxy-miny+1e4)/(maxx-minx+1e4);

% Zoom the figure window onto the requested bed.
axis([minx-1e4 maxx+1e4 miny-1e4 maxy+1e4]);
w = 600; h = w*ar;
set(f, 'position', [50 50 (w+100) h]);
%axis image

% Assign the output argmuents.
switch nargout
    case 0
    case 1
        varargout{1} = f;
    otherwise
        error('Wrong number of output arguments.')
end

end