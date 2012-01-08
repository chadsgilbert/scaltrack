function varargout = proj_ll2xy(varargin)
%PROJ_LL2XY Convert coordinate data from lon/at to x/y.
%  PROJ_LL2XY converts a set of lon/lat coordinates to a set of x/y coordinates
%  using the proj command: proj +init=nad83:1802 +units=m
%  
%  Some documentation on <a href="http://trac.osgeo.org/proj/">proj</a>.
%
%  To install proj in windows XP, take the following steps:
%   1. Right-click My Computer, and then click Properties.
%   2. Click the Advanced tab.
%   3. Click Environment variables.
%   4. Under "System Variables", click "New" and type:
%        Variable name:  "PROJ_LIB" 
%        Variable value: "C:\proj\nad"
%   5. Under "System Variables", highlight "Path" and click edit and add
%        ";C:\proj\bin" to the end of the list.
%
%  To install on *NIX, take these steps instead:
%   1. Download the source code: http://download.osgeo.org/proj/proj-4.7.0.zip
%   2. Uncompress the source code into some directry.
%   3. Open a terminal and cd to the new directory containing the source.
%   4. Follow the instructions in the README or in INSTALL.
%
%  XY = PROJ_LL2XY(LL) takes a Nx2 matrix LL, where each row of the matrix is an
%  ordered pair (lon, lat), and converts it to a Nx2 matrix where each row is an
%  ordered pair, (x, y).
%
%  [X,Y] = PROJ_LL2XY(LON,LAT) does the same, except with LON, LAT, X and Y
%  explicitly passed in as arguments.
%
%Example:
%  >> lon = [-71; -72; -70];
%  >> lat = [40 40 40];
%  >> ll = [lon lat];
%  >> xy = proj_ll2xy(ll);
%
%See also: proj_xy2ll.m

% Author: Chad Gilbert
% Date: February 10, 2010

% Handle the input arguments.
switch nargin
    case 1
        ll = varargin{1};
        if size(ll,1) == 2, ll = ll'; end
    case 2
        lon = varargin{1};
        lat = varargin{2};
        if (numel(lon) == numel(lat))
            ll = [reshape(lon,length(lon),1) reshape(lat,length(lat),1)];
        else
            error('LON and LAT must be the same size.')
        end
    otherwise
        error('Wrong number of input arguments.')
end

% Run the platform specific command and file I/O to get the proj result.
if ispc
    save ll.txt ll -ASCII -DOUBLE
    dos('proj +init=nad83:1802 +units=m -f "%.8f" ll.txt > xy.txt');
    xy = load('xy.txt');
    dos('del ll.txt')
	dos('del xy.txt')
elseif ismac
    save ~/ll.txt ll -ASCII -DOUBLE
    hp = mfilename('fullpath'); i = strfind(hp,mfilename); hp = hp(1:(i-1));
    [s,r]=system([hp 'newterm.sh ~/ ' hp 'proj_ll2xy.sh']);
    if s~=0, disp(r); end
    xy = wait_for_file('~/xy.txt');
    system('rm ~/ll.txt'); system('rm ~/xy.txt');
elseif isunix
    % This branch not yet tested.
    save ~/ll.txt ll -ASCII -DOUBLE
    system('proj +init=nad83:1802 +units=m -f "%.8f" ll.txt > xy.txt');
    xy = load('~/xy.txt');
    system('rm ~/ll.txt'); system('rm ~/xy.txt');
else
    error('Sorry, your system is not supported.')
end

% Assign the output args.
switch nargout
    case {0, 1}
        varargout{1} = xy;
    case 2
        varargout{1} = xy(:,1);
        varargout{2} = xy(:,2);
    otherwise
        error('Too many output arguments requested.')
end