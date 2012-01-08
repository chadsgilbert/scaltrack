function varargout = scatter(this,varargin)
%SCATTER scatter X0 and Y0 fields of a bed. Overloads SCATTER for the Bed class.
%  SCATTER makes a scatter plot of all the points within the bed.
%
%  SCATTER(BEDOBJ) makes the default scatter plot.
%
%  SCATTER(BEDOBJ, OPTS) takes the standard modifier arguments and applies them
%  to the scatter plot.
%
%  Example:
%  >> scatter(bed, 'ro', 'filled')
%  makes the plot using filled red circles.
%
%See also: Bed, plot, zoom

h = scatter(this.x0, this.y0, varargin{:});

switch nargout
    case 0

    case 1
        varargout{1} = h;
    otherwise
        error('Wrong number of output arguments requested.')
end

end