function varargout = pcolor(this,varargin)
%PCOLOR overloads PCOLOR for the Settlement class.
%  PCOLOR makes a pcolor plot of the settlement distribution stored in the
%  Settlement object.
%
%  PCOLOR(SETOBJ) makes the plot.
%
%  PCOLOR(SETOBJ,OPTS) changes the default options.
%
%  Example:
%  >> pcolor(setobj)
%  makes the plot.
%
%See also: Settlement, Track, Larvae, plot

opts.scale = 1;
for i = 1:2:(nargin-1)
    opts.(varargin{i}) = varargin{i+1};
end

isheld = ishold; hold on;

h = pcolor(this.xvec, this.yvec, this.u/opts.scale);
set(h, 'linestyle', 'none');
sc = scatter(this.x, this.y, 10, [0 0 0.3],'.');

if ~isheld, hold off; end

switch nargout
    case 0
    case 1
        varargout{1} = h;
    case 2
        varargout{1} = h;
        varargout{2} = sc;
    otherwise
        error('Wrong number of output arguments.')
end

end