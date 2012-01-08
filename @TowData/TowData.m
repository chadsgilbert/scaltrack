classdef TowData
%TOWDATA a data model for storing scallop abundance data.
%  TOWDATA is a class for storing data samples. It contains useful methods for:
%    - reading tow data in from properly processed text files
%    - subsampling the data
%    - plotting maps of scallop abundance
%    - plotting time-series of abundance and size-distribution
%    - estimating scallop density distribution unsing kriging.
%
%  Constructors. The data needed to make a TowData object are a set of column
%  vectors, each the same length, containing the:
%    year, lon, lat, dpth, sizef, hvec, and org
%  of each sampling record.
%
%  TOWDATA() makes an empty TowData object.
%
%  TOWDATA(FILE) reads a data file containing the above list of data fields and 
%  uses them to create a TowData object.
%
%  TOWDATA(TDOBJ), where TDOBJ is another TowData object, creates a new copy of
%  TDOBJ.
%
%  TOWDATA(TDSTRUCT), where TDSTRUCT is a 'towdata' struct from Chad's earlier
%  thesis code.
%
%  TOWDATA(YEAR, LON, LAT, DPTH, ORG, SIZEF, HVEC). YEAR, LON, LAT and DPTH must
%  be numeric [Nx1] vectors, ORG must be an [Nx1] cell array with each entry 
%  refering to the organization that took the sample. SIZEF is a [NxH] matrix 
%  with each row corresponding to a sample and each solumn a size-class. Each 
%  entry is the number of scallops caught on that tow in that size-class. HVEC 
%  is a [1xH] vector listing the lower limit of each size-class. Usually, this 
%  is in 5mm increments.
%
%  TOWDATA(YEAR, LON, LAT< DPTH, ORG, SIZEF, HVEC, X, Y, U) same as above, but
%  with [Nx1] numeric vectors X, Y (position) and U (standardized density).
%
%  TOWDATA(..., RULE1, VAL1, RULE2, VAL2, ...) uses pre-defined sub-sampling 
%  rules to eliminate any data points that don't fit a given pattern. The 
%  argument VALx corresponds to RULEx as extra instructions. Implemented rules 
%  and their corresponding arguments are listed below:
%
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
%       args:   BED can be in {'gsc', 'nep', 'sfl'}. It can be a string, or a
%               struct or a Bed object.
%   'eras'    - returns only records within the specified era.
%       args:   ERA can be {'pre','era1','post','era2','all'} 'pre' and 'era1'
%               are the same (1984-1994) and 'post' and 'era2' are the same 
%               (1996-2004), and 'all' contains the years 1984:2004.
%
%  when several of these optional rules are specified, the resulting object will
%  contain only data points that satisfy all of these rules.
%
%  Methods in the TOWDATA class:
%    - plot
%    - scatter
%    - krige
%
%  Example:
%    >> file = 'path/to/datafile';
%    >> td = TowData(file, 'years', 1984:2004)
%    makes a TowData object containing all data in the file 'datafile', within
%    the years 1984 to 2004.
%
%See also: GonData, bar, bubble, get_krige, get_towlen, plot, scatter, struct

properties (SetAccess = private)
    % These properties are required to make a TowData object.
    year;   % [nx1 double] The year in A.D.
    lon;    % [nx1 double] The longitude in decimal degrees.
    lat;    % [nx1 double] The latitude in decimal degrees.
    dpth;   % [nx1 double] The water depth at the sample location.
    sizef;  % [nxm double] The number of scallops in each size-bin in each tow.
    hvec;   % [1xm double] The lower limit of each size bin.
    org;    % [nx1 cell array] The name of the org that took each sample.
end

properties (SetAccess = private)
    % These properties are copied or created if the means are available.
    x;      % The x position of each tow.
    y;      % The y position of each tow.
    u;      % The density of scallops in scallops per km^2.
    size;   % [string] The size-class.
    era;    % [string] The era.
end

properties (Constant = true)
    % These properties are universal to TowData objects.
    lon_units = 'decimal degrees';
    lat_units = 'decimal degrees';
    dpth_units = 'm';
    hvec_units = 'mm';
    x_units = 'm';
    y_units = 'm';
    u_units = 'scallops per km^2';
    orgs = {'noaa', 'dfo'}; % List of recognized data sources.
    towlen_noaa = 4516/1e6; % Tow area in km^2 for NOAA. Hart, pers. comm.
    towlen_dfo  =  800/1e6; % Tow data in km^2 for DFO. DiBacco, pers. comm.
    tow_eff = 0.4;          % Tow efficiency (Gedamke et al., 2004).
    contour_threshold = 25; % The threshold for defining the bed border.
end

methods
    function this = TowData(varargin)
        if (nargin == 0)
            % Empty constructor.
            
        elseif (mod(nargin,2) == 1) && (ischar(varargin{1}) || iscell(varargin{1}))
            % Find the file and make a struct out of it, then use that struct 
            % to apply the given filtering rules and make a TowData object.
            td = import_towdata(varargin{1});
            this = TowData(td, varargin{2:end});
            
        elseif (mod(nargin,2) == 1) && isa(varargin{1}, 'TowData')
            % Copy constructor.
            % Convert the input arg to a struct in case it needs to be
            % subsampled, and the make a TowData object out of it again.
            td = struct(varargin{1});
            this = TowData(td, varargin{2:end});
            
        elseif ismember(nargin,7:12) && isnumeric(varargin{1})
            % Direct property assignment.
            this.year   = varargin{1};
            this.lon    = varargin{2};
            this.lat    = varargin{3};
            this.dpth   = varargin{4};
            this.org    = varargin{5};
            this.sizef  = varargin{6};
            this.hvec   = varargin{7};
            if nargin == 9
                this.size = varargin{8};
                this.era = varargin{9};
            elseif nargin == 10
                this.x = varargin{8};
                this.y = varargin{9};
                this.u = varargin{10};
                minheight = num2str(min(this.hvec));
                maxheight = num2str(max(this.hvec));
                this.size = [minheight ':' maxheight];
                minyear = num2str(min(this.year));
                maxyear = num2str(max(this.year));
                this.era = [minyear ':' maxyear];
            elseif nargin == 12
                this.x = varargin{8};
                this.y = varargin{9};
                this.u = varargin{10};
                this.size = varargin{11};
                this.era = varargin{12};
            else
                error('Incorrect input arguments.')
            end
            
        elseif (mod(nargin,2) == 1) && isstruct(varargin{1})
            % Convert a struct to a GonData object.
            
            % Assign the records to the object.
            td = get_subset(varargin{1}, 'nans', [], varargin{2:end});
            td = eliminate_dups(td);    % Eliminate any duplicate records.
            
            this.year   = td.year;
            this.lon    = td.lon;
            this.lat    = td.lat;
            this.dpth   = td.depth;
            this.org    = td.org;
            this.sizef  = td.sizef;
            this.hvec   = td.hvec;
            if isfield(td,'x')
                this.x = td.x;
                this.y = td.y;
                this.u = td.u;
            end
            this.size = get_sizeclass(this.hvec);
            this.era  = get_era(this.year);
            
        else
            error('Invalid input arguments.')
        end
       
    end
end

end

function sizeclass = get_sizeclass(hvec)

thing = num2str([min(hvec) max(hvec)]);

switch thing
    case '50  90'
        sizeclass = 'Small (height in [50,95) mm)';
    case '95  115'
        sizeclass = 'Medium (height in [95,120) mm)';
    case '120  165'
        sizeclass = 'Large (height in [120,170) mm)';
    otherwise
        sizeclass = [num2str(min(hvec)) ':' num2str(max(hvec)+5)];
end

end

function era = get_era(years)

thing = num2str([min(years) max(years)]);

switch thing
    case '1984  1994'
        era = 'Pre-closures (1984-1994)';
    case '1996  2004'
        era = 'Post-closures (1996-2004)';
    otherwise
        era = [num2str(min(years)) ':' num2str(max(years))];
end

end
