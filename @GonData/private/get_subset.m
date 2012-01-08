function subsample = get_subset(gondata, varargin)
%GET_SUBSET extracts a subset of the gsi data samples in a GonData object.
%
%  NEWGONDATA = GET_GSI_SUBSET(GONDATA, RULE1, ARGS1, RULE2, ARGS2, ...)
%  where RULEx and ARGSx can be repeated indefinitely, returns the data struct
%  SUBSAMPLE with any entries removed, which fail to satisfy any criteria
%  defined by RULEx and ARGSx.
%
%Rules defined:
%  'depths'   - removes any samples outside of the given range.
%       args:   [D_MIN D_MAX]
%  'heights'  - removes samples having shell height outside the given range.
%       args:   [H_MIN H_MAX]
%  'sizes'     - keeps only the samples in the given size-class.
%       args:   SIZE, a string specifying the size-class. Either 'small'
%               'medium' or 'large'. These sizes are 5-90, 95-115 and 120-200 mm
%               respectively.
%  'regionll' - removes any samples outside of the specified region.
%		args:   [2 x n] polygon defining the region. Or, an empty matrix can be 
% 			    passed in, in which case, an interactive map will be drawn for 
%               the user to manually define the region.
%  'regionxy' - the same as regionll, except using x/y coordinates.
%  'nans'     - removes any sample points that contain any nans.
%       args:   [] just pass any junk in so that the argument count doesn't get
%               screwed up.
%  'datenums' - removes sample points that were taken outside the given range.
%       args:   [T_MIN  T_MAX], given in datenum format.
%  'years'    - removes any years not referred to in the argument vector
%       args:   [Y1 Y2 Y3 ...] a list of years to keep, listed in a vector.
%  'months'   - removes sample points that weren't taken in the right months.
%       args:   [MON1 MON2 ... MONN] where each month is referenced by its
%               number (eg Jan = 1, May = 5). or {MON1 ... MONN} where each
%               month is referenced by a unique case-insensitive string (eg. 
%               Jan = 'January', or Jan = 'jan').
%  'sexes'    - Keeps only animals having the sex specified.
%       args:   SEX, where sex can be the number 1 for males, or 2 for females.
%               Alternatively, 'f' is for femal or 'm' for male.
%
%See Also, get_gsi_timeseries, get_spawn_time, get_spawn_magnitude

% Author: Chad Gilbert
% Date: May 17, 2010

% Check for acceptable data input.
if ~isstruct(gondata) || (mod(nargin,2) ~= 1)
    error('Invalid input argument for get_subset.m')
end

% Iteratively toss out unwanted data points.
for i = 1:2:(nargin-1)
    F = str2func(varargin{i});
    gondata = feval(F, gondata, varargin{i+1});
end

% Assign the return value.
subsample = gondata;
end

%*******************************************************************************
% Subsampling rules below. Each is described in the header comment.
%*******************************************************************************

function subsample = depths(gondata,minmax) %#ok<*DEFNU>
ind = (gondata.dpth > minmax(1) & gondata.dpth < minmax(2));
subsample = eliminate(gondata,ind);
end

function subsample = heights(gondata,minmax)
ind = (gondata.height >= minmax(1) & gondata.height < minmax(2));
subsample = eliminate(gondata,ind);
end

function subsample = sizes(gondata,sizes)
switch sizes
    case {'s' 'sma' 'small'}
        minmax = [50 94];
    case {'m' 'med' 'medium'}
        minmax = [95 119];
    case {'l' 'lrg' 'large'}
        minmax = [120 169];
    case {'a', 'all'}
        minmax = [50 169];
    otherwise
        error('Invalid size-class specified.')
end
subsample = heights(gondata,minmax);
end

function subsample = regionll(gondata,polygon)
if isempty(polygon)
    polygon = ginput_gb('lldom'); % Draw a map for UI
end
ind = inpolygon(gondata.lon, gondata.lat, polygon(1,:), polygon(2,:));
subsample = eliminate(gondata,ind);
end

function subsample = regionxy(gondata,polygon)
if isempty(polygon)
	polygon = ginput_gb('xydom'); % Draw a map for UI
end
ind = inpolygon(gondata.lon, gondata.lat, polygon(1,:), polygon(2,:));
subsample = eliminate(gondata,ind);
end

function subsample = nans(gondata,~)
ind = ~isnan(gondata.lat+gondata.height+gondata.wgw);
subsample = eliminate(gondata,ind);
end

function subsample = datenums(gondata,times)
ind = (gondata.yd >= times(1) & gondata.yd <= times(2));
subsample = eliminate(gondata,ind);
end

function subsample = years(gondata,years)
ind = ismember(gondata.year,years);
subsample = eliminate(gondata,ind);
end

function subsample = months(gondata,months)
if iscell(months)
    m = get_month_struct('mmm');
    mon = NaN(size(months));
    for i = 1:length(months)
        mon(i) = find(strncmpi(m, months, 3));
    end
    ind = ismember(gondata.month,mon);
elseif ischar(months)
    m = get_month_struct('mmm');
    mon = find(strncmpi(m, months, 3));
    ind = ismember(gondata.month,mon);
elseif isnumeric(months) && (min(months) > 0) && (max(months) < 13) ...
        && sum(mod(months,1)==0)
    ind = ismember(gondata.month,months);
else
    error('Invalid month agument supplied.')
end
subsample = eliminate(gondata,ind);
end

function subsample = sexes(gondata,sex)
switch sex
    case {1 'm' 'M' 'male' 'Male' 'males' 'Males'}
        ind = ismember(gondata.sex, {'m'});
    case {2 'f' 'F' 'female' 'Female' 'females' 'Females'}
        ind = ismember(gondata.sex, {'f'});
    otherwise
        error('Invalid sex argument supplied.')
end
subsample = eliminate(gondata,ind);
end

function subsample = eliminate(gondata,ind)
subsample.year   = gondata.year(ind);
subsample.month  = gondata.month(ind);
subsample.day    = gondata.day(ind);
subsample.lat    = gondata.lat(ind);
subsample.lon    = gondata.lon(ind);
subsample.dpth   = gondata.dpth(ind);
subsample.height = gondata.height(ind);
subsample.wgw    = gondata.wgw(ind);
subsample.wmw    = gondata.wmw(ind);
subsample.wspw   = gondata.wspw(ind);
subsample.sex    = gondata.sex(ind);
end
