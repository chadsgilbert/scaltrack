function scatter(this, varargin)
%SCATTER overloads the scatter function for the GonData class.
%  SCATTER makes a scatter plot of a GonData property versus time. The temporal
%  resolution is daily, though the labels will be monthly or yearly, depending
%  on the length of the time-series.
%
%  SCATTER(THIS, FLD) where THIS is a GonData object, and FLD is the property to
%  be plotted, makes a scatter plot of FLD versus time.
%
%  Example:
%    scatter(GonData('file'), 'gsi')
%    makes a scatter plot of the gsi data stored in the file, 'file' versus 
%    time.
%
%See also: GonData/plot.m

switch nargin
    case 1
        fld = 'wgw';
    case 2
        fld = varargin{1};
        if ~ismember(fld, properties(this)), error('Invalid property'); end
    otherwise
        error('Wrong number of input arguments.')
end

if isempty(this.yd)
    this.yd = datenum(this.year, this.month, this.day);
end

if strcmp(fld, 'gsi') && isempty(this.gsi)
    this.gsi = 100*(this.wgw)./(this.wmw+this.wspw);
end

isheld = ishold; hold on;

% Plot the actual data.
scatter(this.yd, this.(fld), 'filled');
formatwindow(this, isheld, fld);
ylabel([get_ylab(fld) ' ' get_yunit(fld)]);

if ~isheld, hold off; end

end