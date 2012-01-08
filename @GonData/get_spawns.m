function varargout = get_spawns(this, varargin)
%GET_SPAWNS estimates the amount of spawning in each year.
%  GET_SPAWNS computes the drop in WGW within a season (either spring or fall)
%  for each year present in the data provided. 
%
%  If there are not enough data to determine the magnitude of the spawn in a 
%  given year, that spawn will not be estimated, and a NaN will be placed in 
%  the corresponding element of the output vector.
%
%  The units of the output argument SPAWN are in eggs per female.
%
%  GET_SPAWNS(GD, SEAS) where GD is a GonData object and SEAS is a string
%  denoting the season ('spring' or 'fall'), estmates the amount of spawning
%  that occurs in each year.
%
%  GET_SPAWNS(..., VAR) uses the given variable, instead of 'eggs'.
%
%  [SPAWNS, YEARS] = GET_SPAWNS(...) also returns a vector conatining the years
%  that the spawn was estimated for.
%
%  Example:
%    [spawns, years] = get_spawns(GonData('gdfile', 'years', 1984:2004), 'fall')
%    bar(years,spawns)
%    plots a bar time series of the spawning magnitude in each year.
%
%See also: GonData.m, ctimeseries.m

% Assign the input arguments.
switch nargin
    case 2
        seas = varargin{1};
        var = 'eggs';
    case 3
        seas = varargin{1};
        var = varargin{2};
    otherwise
        error('Wrong number of input arguments.')
end

% Check if we're doing the spring or fall.
switch lower(seas(1))
    case 's'
        ind_seas = 3:7;
    case 'f'
        ind_seas = 7:12;
    otherwise
        error('Invalid season selected.')
end

% Get the monthly averaged time-series and list the years with enough data.
if strcmp(var,'eggs')
    u = get_ctimeseries(this, 'wgw');
else
    u = get_ctimeseries(this, var);
end

% Estimate the spawn magnitude.
[years,~] = datevec(u.x);
years = sort(unique(years));

% List the years with enough data.

isvalid = logical(check_data(this, years, ind_seas));

spawns = NaN(size(years));
for i = 1:length(years)
    v = ctimeseries(u, 'years', years(i));
    spawns(i) = sum_drops(v.y(ind_seas));
end
spawns(~isvalid) = NaN;

if strcmp(var, 'eggs')
    spawns = spawns/this.egg_mass;
end

% Assign the output arguments.
switch nargout
    case {0, 1}
        varargout{1} = spawns;
    case 2
        varargout{1} = spawns;
        varargout{2} = years;
    otherwise
        error('Too many output arguments requested.')
end

end

function drop = sum_drops(y)
%SUM_DROPS computes the total drop in WGW occurring within a season.
drop = 0;
i = 1;
while i < (length(y)-1)
    if isnan(y(i))
        i = i+1;
        continue;
    end
    
    j = 1;
    while j < (length(y)-i-1)
        if isnan(y(i+j))
            j = j+1;
        else
            break;
        end
    end
    
    if (i+j) > length(y)
        break;
    end
        
    dif = y(i+j) - y(i);
    if dif < 0
        drop = drop - dif;
    end
    
    i = i+1;
end

end

function isvalid = check_data(this, years, mons)
%CHECK_DATA checks to see if there are enough data to infer a spawn.

isvalid = zeros(size(years));
for i = 1:length(years)
    l = sum( this.year == years(i) & ismember(this.month, mons));
    if l > 50
        isvalid(i) = true;
    else
        isvalid(i) = false;
    end
end

end
