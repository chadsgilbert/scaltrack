function zoom(this, varargin)
%ZOOM zooms the MATLAB figure in on a Krige for nice viewing.
%
%  ZOOM(KRIGEOBJ) where KRIGEOBJ is a a Krige object.
%
%  ZOOM(KRIGEOBJ, F) where F is a figure handle, zooms the figure referenced
%  by F onto the coordinates in KRIGEOBJ.
%
%  Example:
%  >> zoom(Krige(GSC,data))
%  will zoom a figure onto the GSC.
%
%See also Krige, SpawnField/zoom

if nargin == 2
    f = varargin{1};
elseif nargin == 1
    f = gcf;
else
    error('Wrong number of input arguments.')
end

minx = min(this.x);
maxx = max(this.x);
miny = min(this.y);
maxy = max(this.y);
ar = (maxy-miny+1e4)./(maxx-minx+1e4);

% Zoom the figure window onto the requested bed.
axis([minx-1e4 maxx+1e4 miny-1e4 maxy+1e4])
w = 600; h = w*ar;
set(f, 'position', [50 50 (w+100) h]);

end