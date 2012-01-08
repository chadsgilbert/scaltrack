function varargout = bar(this, varargin)
%BAR overloads BAR for the TowData class.
%  BAR plots a time-series of scallop abundance for the data contained by a 
%  TowData object.
%
%  BAR(THIS) plots the mean scallop density in each year, based on tow data.
%
%  BAR(THIS, OPTIONS)
%
%  Example:
%    >> bar(TowData(file, 'years', 1984:2004)))
%    plots a time-series of scallop density per tow for the years 1984 to 2004.
%
%See also: TowData/plot

if isempty(this.u)
    u = sum(this.sizef)./get_towlen(this);
else
    u = this.u;
end

trans = 'none';

% Parse the optional input arguments.
for i = 2:2:nargin
    switch varargin{i-1}
        case 'trans'
            trans = varargin{i};
        otherwise
            error('Invalid optional argument supplied.')
    end
end

% Assign the x-value, years.
years = sort(unique(this.year));
years = reshape(years, 1, numel(years));

i = 1;
U = NaN(size(years));
S = NaN(size(years));

if strcmp(trans,'none')
    for y = years
        ind = this.year == y;
        U(i) = mean(u(ind));
        S(i) = std(u(ind))/sqrt(sum(ind))*1.96;
        i = i+1;
    end
    Smin = U - S;
    Smax = U + S;    
elseif strcmp(trans,'log')
    for y = years
        ind = this.year == y;
        U(i) = mean(log(u(ind)*TowData.towlen_noaa+1));
        S(i) = std(log(u(ind)*TowData.towlen_noaa+1))/sqrt(sum(ind))*1.96;
        i = i+1;
    end
    Smin = exp(U - S);
    Smax = exp(U + S);
    U = exp(U);
else
    error('Invalid value for trans.')
end

isheld = ishold; hold on;
bar(years, U, 1);
errorbar(years, U, Smin, Smax, 'k', 'linestyle', 'none');
axis([min(years)-0.5 max(years+0.5) get(gca, 'YLim')])

if ~isheld, hold off; end

% Assign any output arguments.
switch nargout
    case 0
    case 1
        varargout{1} = u;
    case 2
        varargout{1} = u;
        varargout{2} = years;
    otherwise
        error('Too many output agruments requested.')
end

end