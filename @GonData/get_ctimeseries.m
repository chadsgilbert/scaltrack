function varargout = get_ctimeseries(this, fld)
%GET_GSI_TIMESERIES makes a ctimeseries for a GonData object.
%
%  U = GET_CTIMESERIES(GD, VAR) returns a ctimeseries object containing the
%  monthly mean and 95% confidence intervals. THIS is a GonData object and VAR
%  is a string denoting the field of GD to return the time-series of.
%
%  [X,Y,E] = GET_CTIMESERIES(GD, VAR) returns the time X, the mean Y and the 95%
%  confidence interval E as vectors, instead of putting htem into a ctimeseries
%  object.
%
%  Example:
%    gd = GonData('gdfile', 'years', 1984:1994);
%    plot(get_ctimeseries(gd, 'gsi'));
%    recreates Jen's monthly mean GSI plot.
%
%See also: GonData/plot.m, get_spawns.m

% Pre-allocate the vectors.
years = unique(this.year);
x = NaN(1,12*length(years));
for i = 1:length(years)
    x((i*12-11):(i*12)) = datenum(years(i), 1:12, eomday(years(i),1:12)/2);
end
y = NaN(size(x));
e = NaN(size(x));

% Check if the field exists in the passed object.
if isempty(this.(fld))
    if strcmp(fld, 'gsi')
        this.gsi = 100*(this.wgw)./(this.wmw + this.wspw);
    else
        error('Field does not exist.')
    end
end

% Get the mean and 95% CI for each month in each year.
k = 1;
for i = 1:length(years)
    for j = 1:12
        dat = this.(fld);
        ind = (this.year==years(i)) & (this.month==j);
        mdat = dat(ind);
        if ~isempty(mdat)
            y(k) = mean(mdat);
            e(k) = sqrt(var(mdat)/length(mdat))*1.96;
        end
        k = k+1;
    end
end

switch nargout
    case 1
        varargout{1} = ctimeseries(x, y, e, [], get_ylab(fld), [], ...
            'months', get_yunit(fld), get_yrange(this,fld));
    case 3
        varargout{1} = x;
        varargout{2} = y;
        varargout{3} = e;
    otherwise
        error('Wrong number of output arguments.')
end

end