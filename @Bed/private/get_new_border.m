function varargout = get_new_border(b1,b2)
%GET_NEW_BORDER makes a new polygon that is the intersection of two polygons.
%  GET_NEW_BORDER is a support function for making new beds. It is sometimes
%  useful to divide an existing bed into subregions. A user can do this by
%  drawing a polygon that bisects an existing bed. This function helps with
%  that.
%
%  The function uses "PolygonClip", which can be obtained here:
%    http://www.mathworks.com/matlabcentral/fileexchange/8818-polygon-clipper
%  If you are running a *NIX, then compile from MATLAB with the command
%    >> mex gpc.c gpc_mexfile.c -argcheck -output PolygonClip .
%  Make sure that the files are on the MATLAB search path before running the
%  command.
%
%  Example:
%  >> load(bedobj); % Load a bed.
%  >> plot(bedobj); hold on; % Plot the bed.
%  >> b = ginput(); % Draw a polygon that isolates a subsection of the bed.
%  >> newborder = get_new_border(bedobj.border, b);
%  >> newnbed = Bed(newborder(1,:), newborder(2,:), 'newbed');
%  makes a new bed that is a subsection of the old one.
%
%See also: PolygonClip, Bed, Bed/plot

% Format the polygons so that they will run in PolygonClip
p1.x = b1(1,:);
p1.y = b1(2,:);
p2.x = b2(1,:);
p2.y = b2(2,:);

% Check if PolygonClip is on the MATLAB path.
if ~exist('PolygonClip','file')
    % If PolygonClip doesn't exist on the path, ask the user to point to it.
    polypath = uigetdir(homepath, 'Where is PolygonClip?');
    addpath(polypath);
end

% Clip the polygon using the AND option.
p = PolygonClip(p1, p2, 1);

switch nargout
    case {0,1}
        varargout{1} = [p.x'; p.y'];
    case 2
        varargout{1} = p.x;
        varargout{2} = p.y;
    otherwise
        error('Too many output arguments reuqested.');
end

end