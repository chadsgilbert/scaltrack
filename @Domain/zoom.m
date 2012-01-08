function varargout = zoom(this, varargin)
%ZOOM zooms in on the domain. Overloads ZOOM for the Domain class. 
%  ZOOM zooms a figure axis to fit to the boundary of a domain object.
%
%  ZOOM(DOMOBJ)
%
%  Example:
%    >> zoom(domobj)
%    changes the current figure dimensions and focuses the figure on the
%    appropriate coodinates.
%
%See also: Domain, plot

% Assign input arguments.
switch nargin
    case 1
        f = gcf;
    case 2
        f = varargin{1};
    otherwise
        error('Wrong number of input arguments.');
end

% Zoom the figure window onto the domain.
axis([min(this.xvec) max(this.xvec) min(this.yvec) max(this.yvec)]);
set(f, 'position', this.plot_dimensions + [0 0 100 0]);

% Assign the output argmuents.
switch nargout
    case 0
    case 1
        varargout{1} = f;
    otherwise
        error('Wrong number of output arguments.')
end

end