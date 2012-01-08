function varargout = proj_xy2ll(varargin)
%PROJ_XY2LL Convert coordinate data from x/y to lon/lat.
%  PROJ_XY2LL converts a set of x/y coordinates to a set of lon/lat coordinates
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
%  LL = PROJ_XY2LL(XY) takes a Nx2 matrix LL, where each row of the matrix is an
%  ordered pair (lon, lat), and converts it to a Nx2 matrix where each row is an
%  ordered pair, (x, y).
%
%  [LON,LAT] = PROJ_LL2XY(X,Y) does the same, except with LON, LAT, X and Y
%  explicitly passed in as arguments.
%
%Example:
%  >> x = [9e5; 1e6; 1.1e6];
%  >> y = [0 0 0];
%  >> xy = [x y];
%  >> ll = proj_xy2ll(xy);
%
%See also: proj_ll2xy.m

% Author: Chad Gilbert
% Date: February 10, 2010

% Handle the input arguments.
switch nargin
    case 1
        xy = varargin{1};
        if size(xy,1) == 2, xy = xy'; end
    case 2
        x = varargin{1};
        y = varargin{2};
        if (length(x) == length(y) == numel(x) == numel(y))
            xy = [reshape(x,length(x),1) reshape(y,length(y),1)];
        else
            error('X and Y must be the same size.')
        end
    otherwise
        error('Wrong number of input arguments.')
end

% Run the platform specific command and file I/O to get the proj result.
if ispc
    save xy.txt xy -ASCII -DOUBLE
    dos('proj +init=nad83:1802 +units=m -f "%.8f" -I xy.txt > ll.txt');
    ll = load('ll.txt');
    dos('del ll.txt'); dos('del xy.txt');
elseif ismac
    save ~/xy.txt xy -ASCII -DOUBLE
    hp = mfilename('fullpath'); i = strfind(hp,mfilename); hp = hp(1:(i-1));
    [s,r]=system([hp 'newterm.sh ~/ ' hp 'proj_xy2ll.sh']);
    if s~=0, disp(r); end
    ll = wait_for_file('~/ll.txt');
    system('rm ~/ll.txt'); system('rm ~/xy.txt');
elseif isunix
    % This branch not yet tested.
    save ~/xy.txt xy -ASCII -DOUBLE
    system('proj +init=nad83:1802 +units=m -f "%.8f" -I xy.txt > ll.txt');
    ll = load('~/ll.txt');
    system('rm ~/ll.txt'); system('rm ~/xy.txt');
else
    error('Sorry, your system is not supported.')
end

% Assign the output args.
switch nargout
    case {0, 1}
        varargout{1} = ll;
    case 2
        varargout{1} = ll(:,1);
        varargout{2} = ll(:,2);
    otherwise
        error('Too many output arguments requested.')
end