function zoom(this, varargin)
%ZOOM zooms the MATLAB figure in on a SpawnField for nice viewing.
%
%  ZOOM(SFOBJ) where KRIGEOBJ is a a Krige object.
%
%  ZOOM(SFOBJ, F) where F is a figure handle, zooms the figure referenced
%  by F onto the coordinates in KRIGEOBJ.
%
%  Example:
%  >> zoom(SpawnField())
%  will zoom a figure onto the SpawnField.
%
%See also SpawnField, Bed/zoom, Krige/zoom

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

ar = 0.6;
% Zoom the figure window onto the requested bed.
axis([minx-1e4 maxx+1e4 miny-1e4 maxy+1e4])
w = 600; h = w*ar;
set(f, 'position', [50 50 (w+100) h]);

end