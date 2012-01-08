function varargout = plot(this,varargin)
%PLOT overloads PLOT for the class Krige.
%  PLOT plots the kriged scallop density onto a map of the corresponding domain.
%  The only possible domain is currently Georges Bank. This is unlikely to
%  change soon.
%
%  PLOT(KRIGEOBJ) plots the krige.
%
%  Example:
%    >> plot(Krige(TowData(file),bed)
%    plots the scallop density on a map of GB.
%
%See also: Krige

% Assign the input aruments.
opts.smooth = false;
for i = 1:2:(nargin-1)
    opts.(varargin{i}) = varargin{i+1};
end

isheld = ishold; hold on;

if ~opts.smooth
    scatter(this.x, this.y, 50, this.u, 's', 'filled');
else
    xvec = min(this.x):4000:max(this.x);
    yvec = min(this.y):4000:max(this.y);
    [X,Y] = meshgrid(xvec, yvec);
    U = NaN(size(X));
    for i = 1:length(this.x)
        ind = (X==this.x(i) & Y==this.y(i));
        U(ind) = this.u(i);
    end
    h=pcolor(xvec, yvec, U);
    set(h, 'linestyle', 'none');
end

if ~isheld, hold off; end

% Assign the output variables.
switch nargout
    case 0
    case 1
        varargout{1} = gcf;
    otherwise
        error('Too many output arguments requested.');
end

end