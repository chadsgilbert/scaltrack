classdef GonData
%GONDATA: A class for storing and processing scallop gonad data.
%  GONDATA is a class for storing data samples. It contains useful methods for:
%    - reading gonad data in from properly processed text files
%    - subsampling the data
%    - plotting time-series of sampled variables
%    - computing and plotting average values over given intervals
%
%  Constructors. The raw data needed to make a GonData object are a set of
%  column vectors the same length, containing the:
%     year, month, day, lat, lon, height, wgw, wmw, wspw, sex
%  of sampling records. 
%
%  GONDATA(FILE) where FILE is the full path to a tab delimited text data file 
%  having columns corresponding to the above list of data fields. See
%  "parse_raw_gsi.py" for details. It converts the DFO gonad data into this
%  format. It could easily be modified if there were other data for it to parse.
%
%  GONDATA(GDOBJ) where GDOBJ is another GONDATA object, creates a copy. When
%  paired with the extra filtering arguments (dscussed below), the data 
%  contained by the new object will be a subset of that in the old.
%
%  GONDATA(GDSTRUCT) where GDSTRUCT is a struct containing all of the required
%  fields.
%
%  GONDATA(YEAR, MONTH, DAY, LAT, LON, HEIGHT, DPTH, WGW, WMW, WSPW, SEX)
%  creates the object. Each argument should be a [Nx1] array of the same size.
%
%  GONDATA(..., RULE1, VAL1, RULE2, VAL2, ...) uses pre-defined subsampling
%  rules to eliminate any data points that don't fit a given pattern. The 
%  argument VALx corresponds to RULEx as extra instructions. Implemented rules
%  and their possible arguments are listed below:
%
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
%  when several of these optional rules are specified, the resulting object will
%  contain only data points that satisfy all of these rules.
%
%  Methods in the GONDATA class:
%    GonData
%    plot
%    fecundity
%
%  Example:
%    >> file = 'path/to/datafile';
%    >> a = GonData(file);
%
%See also: ctimeseries, Domain

% Actual data vectors that get reported in the provided data sets.
properties (SetAccess = private)
    year;    % [nx1 double] The year in A.D.
    month;   % [nx1 double] The julian month.
    day;     % [nx1 double] The day of the month.
    lat;     % [nx1 double] The latitude in degrees.
    lon;     % [nx1 double] The longitude in degrees.
    height;  % [nx1 double] The shell height in mm.
    dpth;    % [nx1 double] The water depth at the sample location.
    wgw;     % [nx1 double] The measured wet gonad weight, in grams.
    wmw;     % [nx1 double] The measured wet meat weight, in grams.
    wspw;    % [nx1 double] The wet "somatic tissue" weight, in grams.
    sex;     % [nx1 cell arary of chars] The sex of the sampled individual.
end

% Extra data vectors, which must be computed afterward.
properties (SetAccess = private)
    yd      % The yeardate of each sample, days after 0 A.D.
    x       % The x pos (FVCOM) corresponding to the longitude.
    y       % The y pos (FVCOM) corresponding to the latitude.
    age     % The age, estimate based on shell height.
    gsi     % The gonosomatic index, wgw/(wmw+wspw).
end

% Monthly mean time-series. Not made until requested -- then they get stored.
properties (SetAccess = private)
    u_wgw   % The monthly wgw timeseries, computed from these data.
    u_wmw   % The monthly gsi timeseries, computed from these data.
    u_wspw  % The monthly gsi timeseries, computed from these data.
    u_gsi   % The monthly gsi timeseries, computed from these data.
end

properties (Constant = true)
    egg_mass = 1.6e-7;              % Egg mass in grams. (Langton et al., 1987)
    height_units = 'mm';
    lat_units = 'decimal degrees';
    lon_units = 'decimal degrees';
    dpth_units = 'm';
    wgw_units = 'g';
    wmw_units = 'g';
    wspw_units = 'g';
end

% Class constructor.
methods
    function this = GonData(varargin)
        
        if (nargin == 0)
            % Empty constructor.
            
        elseif (mod(nargin,2) == 1) && ischar(varargin{1})
            % File load constructor.
            % Find the file and make a struct out of it.
            gd = import_gsidata(varargin{1});
            this = GonData(gd, varargin{2:end});
            
        elseif (mod(nargin,2) == 1) && isa(varargin{1}, 'GonData')
            % Copy constructor.
            % Convert the input arg to a struct in case it needs to be
            % subsampled, and the make a GonData object out of it again.
            gd = struct(varargin{1});
            this = GonData(gd, varargin{2:end});
            
        elseif (nargin == 11) && isnumeric(varargin{1})
            % Direct property assignment.
            this.year   = varargin{1};
            this.month  = varargin{2};
            this.day    = varargin{3};
            this.lat    = varargin{4};
            this.lon    = varargin{5};
            this.dpth   = varargin{6};
            this.height = varargin{7};
            this.wgw    = varargin{8};
            this.wmw    = varargin{9};
            this.wspw   = varargin{10};
            this.sex    = varargin{11};
            
        elseif (mod(nargin,2) == 1) && isstruct(varargin{1})
            % Convert a struct to a GonData object.
            gd = get_subset(varargin{1}, 'nans', [], varargin{2:end});
            this.year   = gd.year;
            this.month  = gd.month;
            this.day    = gd.day;
            this.lat    = gd.lat;
            this.lon    = gd.lon;
            this.dpth   = gd.dpth;
            this.height = gd.height;
            this.wgw    = gd.wgw;
            this.wmw    = gd.wmw;
            this.wspw   = gd.wspw;
            if isnumeric(gd.sex(1))
                indsex = gd.sex == 1;
                this.sex = cell(length(gd.sex),1);
                this.sex( indsex) = {'f'};
                this.sex(~indsex) = {'m'};
            else
                this.sex = gd.sex;
            end
            
        else
            error('Invalid input arguments.')
        end
        
    end
end

end