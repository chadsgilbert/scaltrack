function subsample = get_subset(towdata, varargin)
%GET_SUBSET subsamples the data in a TowData object.
%
%  SUBSET = GET_TOW_SUBSET(TOWDATA, RULE1, ARGS1, RULE2, ARGS2, ...)
%  where RULEx and ARGSx can be repeated indefinitely, returns the data struct
%  SUBSAMPLE with any entries removed, which fail to satisfy any criteria
%  defined by RULEx and ARGSx.
%
%Rules defined:
%  'depths'   - removes any samples outside of the given range.
%       args:   [D_MIN D_MAX]
%  'heights'   - removes samples having shell height outside the given range.
%       args:   [H_MIN H_MAX]
%  'sizes'     - keeps only the samples in the given size-class.
%       args:   SIZE, a string specifying the size-class. Either 'small'
%               'medium' or 'large' or 'all'. These sizes are 5-90, 95-115 and
%               120-200 mm respectively and 'all' takes all scallops in 5-200.
%  'regionll' - removes any samples outside of the specified region.
%		args:   [2 x n] polygon defining the region. Or, an empty matrix can be
% 			    passed in, in which case, an interactive map will be drawn for
%               the user to manually define the region.
%  'regionxy' - removes any samples outside ot the specified region.
%               [2 x n] polygon defining the region. Or, an empty matrix can be
%               passed in, in which case, an interactive map will be drawn for
%               user input.
%  'nans'     - removes any sample points that contain any nans.
%       args:   [] just pass any junk in so that the argument count doesn't get
%               screwed up.
%  'years'    - removes any years not referred to in the argument vector
%       args:   [Y1 Y2 Y3 ...] a list of years to keep, listed in a vector.
%   'beds'    - returns only records within the specified bed.
%       args:   BED can be in {'gsc', 'nep', 'sfl'}. BED can be a string, a
%               struct or a Bed object.
%   'eras'    - returns only records within the specified era.
%       args:   ERA can be {'pre','era1','post','era2','all'} 'pre' and 'era1'
%               are the same (1984-1994) and 'post' and 'era2' are the same 
%               (1996-2004), and 'all' contains the years 1984:2004.
%
%You can also pass in a cell array of tow data structs, and they will be
%automatically converted into one big struct before the rest of the operations
%are performed. e.g. get_tow_subset({dfo noaa}, ...) returns one big struct
%containing both the dfo and noaa data.
%
%See Also: get_tow_subset

% Check for acceptable data input.
if ~isstruct(towdata)
    if ischar(towdata)
        load(towdata)
    elseif iscell(towdata)
        scallops = towdata{1};
        for i = 2:length(towdata)
            scallops.year  = [scallops.year;  towdata{i}.year ];
            scallops.lat   = [scallops.lat;   towdata{i}.lat  ];
            scallops.lon   = [scallops.lon;   towdata{i}.lon  ];
            scallops.depth = [scallops.depth; towdata{i}.depth];
            scallops.sizef = [scallops.sizef; towdata{i}.sizef];
            scallops.yield = [scallops.yield; towdata{i}.yield];
            scallops.x     = [scallops.x;     towdata{i}.x    ];
            scallops.y     = [scallops.y;     towdata{i}.y    ];
            scallops.u     = [scallops.u;     towdata{i}.u    ];
            scallops.org   = [scallops.org;   towdata{i}.org  ];
        end
        towdata = scallops;
    else
        error('First input argument `towdata` is illegal')
    end
end
if mod(nargin,2) ~= 1
    error('Wrong number of input arguments.')
end

% Iteratively toss out unwanted data points.
for i = 1:2:(nargin-1)
    F = str2func(varargin{i});
    towdata = feval(F, towdata, varargin{i+1} );
end

% Assign the return value.
subsample = towdata;
end

% This is just so I don't have to type this out every darn time.
function subsample = eliminate(towdata,ind)

subsample.year   = towdata.year(ind);
subsample.lat    = towdata.lat(ind);
subsample.lon    = towdata.lon(ind);
subsample.depth  = towdata.depth(ind);
subsample.sizef  = towdata.sizef(ind,:);
subsample.x      = towdata.x(ind);
subsample.y      = towdata.y(ind);
subsample.hvec   = towdata.hvec;
subsample.u      = towdata.u(ind);
subsample.org    = towdata.org(ind);

end



%*******************************************************************************
% Subsampling rules defined below. Don't forget to describe them in the header
% comment above, once implemented.
%*******************************************************************************

% Remove any depths outside of the range requested.
function subsample = depths(towdata,minmax) %#ok<DEFNU>
ind = (towdata.depth > minmax(1) & towdata.depth < minmax(2));
subsample = eliminate(towdata,ind);
end

function subsample = heights(towdata,minmax)
ind = (towdata.hvec >= minmax(1) & towdata.hvec < minmax(2));
subsample = towdata;
subsample.hvec = towdata.hvec(ind);
subsample.sizef = towdata.sizef(:,ind);
subsample.yield = sum(subsample.sizef,2);
i = strcmp(subsample.org,'dfo');
subsample.u(i) = 1e6*subsample.yield(i)./1950.7;
j = strcmp(subsample.org,'noaa');
subsample.u(j) = 1e6*subsample.yield(j)./4516;
k = ~i & ~j;
subsample.u(k) = NaN;
end

function subsample = sizes(towdata,sizes) %#ok<DEFNU>
switch sizes
    case {'s' 'sma' 'small'}
        minmax = [50 94.99];
    case {'m' 'med' 'medium'}
        minmax = [95 119.99];
    case {'l' 'lrg' 'large'}
        minmax = [120 169.99];
    case {'a' 'all'}
        minmax = [50 169.99];
    otherwise
        error('Invalid size-class specified')
end
subsample = heights(towdata,minmax);
end

function subsample = regionll(towdata,polygon) %#ok<DEFNU>
if isempty(polygon)
    polygon = ginput_gb('lldom');   % Draw a map for UI
end
ind = inpolygon(towdata.lon, towdata.lat, polygon(1,:), polygon(2,:));
subsample = eliminate(towdata,ind);
end

function subsample = regionxy(towdata,polygon)
if isempty(polygon)
    polygon = ginput_gb('xydom');   % Draw a map for UI
end
ind = inpolygon(towdata.x, towdata.y, polygon(1,:), polygon(2,:));
subsample = eliminate(towdata,ind);
end

function subsample = nans(towdata,~) %#ok<DEFNU>
ind = ~isnan(towdata.lat+towdata.u);
subsample = eliminate(towdata,ind);
end

function subsample = years(towdata,year)
ind = ismember(towdata.year,year);
subsample = eliminate(towdata,ind);
end

function subsample = beds(towdata,bed) %#ok<DEFNU>

switch class(bed)
    case 'char'
        try
            bed = load([bed '025_4x4.mat']);
            border = bed{1}.border_xy;
        catch e
            error(e.message)
        end
    case 'struct'
        border = bed.border_xy;
    case 'Bed'
        border = bed.border;
    otherwise
        error('Invalid format for BED.')
end

subsample = regionxy(towdata, border);

end

function subsample = eras(towdata, era) %#ok<DEFNU>

switch lower(era)
    case {'pre','pre-','pre-closures','era1'}
        year = 1984:1994;
    case {'post','post-','post-closures','era2'}
        year = 1996:2004;
    case 'all'
        year = 1984:2004;
    otherwise
        error('Invalid name for era.')
end

subsample = years(towdata,year);

end