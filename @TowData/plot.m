function varargout = plot(this, varargin)
%PLOT overloads plot for the TowData class.
%  PLOT plots the positions and estimated density of scallops in a 2D map. That
%  is, it's a bubble plot.
%
%  By default, PLOT will try to plot the bubbles on x/y coordinates, using the
%  standardized desnity estimate U. If these values do not exist in the object,
%  then lat/lon and a sum along the columns of sizef will be used. This
%  behaviour can be overridden using extra arguments.
%
%  PLOT(TOWOBJ) where TOWOBJ is a TowData object, makes a bubble plot of the tow
%  data.
%
%  Example:
%    >> plot(TowData(file))
%    plots the tow samples and uses the size and color of the plotted points
%    to reflect the number of scallops at each location.
%
%See also: scatter, bubble

% Assign default values for the plotting options.
if ~isempty(this.u)
    %u = log(this.u+1);
    u = this.u;
else
    this.u = sum(this.sizef)./get_towlen(this);
    u = log(this.u+1);
end
scatterargs = {};
% Override default options, if requested.
for i = 2:2:nargin
    switch varargin{i}
        case 'proj'
            proj = varargin{i+1};
            u = eval([proj '(' this.u ')']);
        case 'trans'
            u = feval(varargin{i+1}, this.u+1);
        otherwise
            scatterargs = [scatterargs varargin{i:i+1}]; %#ok<AGROW>
    end
end

% Get the sample locations
ind = (u ~= 0);         % Find locations with no scallops
x0 = this.x(~ind);      % List the empty areas' x-coordinates.
y0 = this.y(~ind);      % List the empty areas' y-coordinates.
x1 = this.x(ind);       % List the scallopy areas' x-coordinates.
y1 = this.y(ind);       % List the scallopy areas' y-coordinates.
u1 = u(ind);            % The log-transformed scallop densities.

% Make the bubble plot.
isheld = ishold; hold on;

h = gca;
scatter(x0, y0, 'kx'); 
if ~isempty(scatterargs)
    scatter(x1, y1, 10*log(u1+1), u1, 'o', 'filled', scatterargs);
else
    scatter(x1, y1, 10*log(u1+1), u1, 'o', 'filled');
end
caxis([min(u1), max(u1)]);

if ~isheld, hold off; end

% Assign the output arguments before returning control.
switch nargout
    case 0
        % Pass no output args.
    case 1
        varargout{1} = h;
    otherwise
        error('Too many output arguments requested.')
end

end