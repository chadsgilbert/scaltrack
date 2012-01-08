function varargout = plot(this, varargin)
%PLOT a GonData time series using monthly mean values.
%
%  PLOT overloads the basic MATLAB plot function. It plots a monthly mean time
%  series of the requested variable.
%
%  PLOT(THIS, FLD) where THIS is the GONDATA object to be plotted, and FLD is a
%  string denoting the property to be plotted. Any roperty that is reuested will
%  be plotted, but it really only makes sense to request one of four variables:
%    'wgw' - the wet gonat weight
%    'wmw' - the wet meat weight
%    'wspw' - the wet somatic tissue weight
%    'gsi' - the gonadsomatic index [gsi = wgw/(wmw + wspw)]
%
%  Example:
%    >> file = 'path/to/datafile';
%    >> a = GonData(file);
%    >> plot(a, 'gsi');
%    will plot a monthly mean timeseries of the gsi, with errorbars used to
%    designate the 95% confidence interval on the mean.
%
%See also: GonData/scatter

if nargin == 1
    fld = 'wgw';
elseif nargin == 2
    fld = varargin{1};
else
    error('Wrong number of input args.')
end

isheld = ishold; hold on;

% Make the actual plot.
u = get_ctimeseries(this,fld);
plot(u);
formatwindow(this, isheld, fld);


if ~isheld, hold off; end

switch nargout
    case 0
    case 1
        varargout{1} = u;
    otherwise
        error('Too many output argumens requested.')
end

end