classdef Krige
%KRIGE is a class for storing estimates of scallop density distribution.
%  KRIGE stores the data and metadata associated with a kriging result, taken
%  to estimate the spatial density of scallop abundance within a given 
%  size-class (determined by shell height) and era (a range of years).
%
%  The class constructor calls the TowData method 'get_krige', which requires a
%  working installation of R to run. See '>> help TowData/get_krige' for more
%  details.
%
%  KRIGE() makes an empty Krige object.
%
%  KRIGE(KRIGE) copies an existing krige.
%
%  KRIGE(KRIGESTRUCT) takes a struct containing the fields {x, y, u, bed, size,
%  era} and makes a Krige object.
%
%  KRIGE(TDOBJ, BEDOBJ) where TDOBJ is a TowData object and BEDOBJ is a Bed
%  object, creates a Krige. Only points from the TDOBJ that are within the
%  region outlined by BEDOBJ will be used to make the prediction. The others
%  will be culled.
%
%  KRIGE(X,Y,U,BED,SIZE,ERA) where X, Y and U are vectors of the same length,
%  denote the position and scallop density respectively. BED, SIZE and ERA are
%  strings denoting the names of the bed, size-class and era contained in the
%  krige.
%
%  Example:
%    >> nep = Bed('nep025_4x44','NEP');
%    >> td = TowData(file, 'regionxy', nep.border, 'years', 1984:2004);
%    >> krige = Krige(td, nep);
%
%See also: TowData, Bed, plot

properties (SetAccess = private)
    x;          % The list of x-positions in which an estimate is given.
    y;          % The list of y-positions in which an estimate is given.
    u;          % The predicted scallop density in scallops per km^2.
    bed;        % [string] The name of the bed, if relevant.
    size_class; % [string] The size-class of scallop.
    era;        % [string] The era.
end

properties (Constant = true)
    x_units = 'm';
    y_units = 'm';
    u_units = 'scallops per km^2';
    variogram = {'exponential', 'isotropic'};
end

methods
    function this = Krige(varargin)
        if nargin == 0
            % KRIGE()
            
        elseif ismember(nargin, 1:2) && isa(varargin{1}, 'Krige')
            % KRIGE(KRIGEOBJ)
            this.x = varargin{1}.x;
            this.y = varargin{1}.y;
            this.bed = varargin{1}.bed;
            this.era = 'Uniform';
            this.size_class = varargin{1}.size_class;
            
            if nargin == 1
                this.u = varargin{1}.u;
            elseif nargin == 2 && strcmp(varargin{2},'flat')
                this.u = ones(size(varargin{1}.u))*mean(varargin{1}.u);
            else
                error('Invalid arguments.')
            end
            
        elseif (nargin == 1) && isstruct(varargin{1})
            % KRIGE(KRIGESTRUCT)
            this.x = varargin{1}.x;
            this.y = varargin{1}.y;
            this.u = varargin{1}.u;
            this.bed = varargin{1}.bed;
            this.size_class = varargin{1}.size_class;
            this.era = varargin{1}.era;
            
        elseif ismember(nargin,2:4) && isa(varargin{1}, 'TowData')
            % KRIGE(TDOBJ, BEDOBJ)
            tdobj = varargin{1};
            bedobj = varargin{2};
            tdobj = TowData(tdobj, 'regionxy', bedobj.border);
            [this.u,this.x,this.y] = get_krige(tdobj, bedobj);
            this.bed = bedobj.name;
            this.size_class = tdobj.size_class;
            this.era = tdobj.era;
            
        elseif ismember(nargin, 6) && isnumeric(varargin{1})
            % KRIGE(X,Y,U,BED,SIZE,ERA)
            this.x = reshape(varargin{1},length(varargin{1}),1);
            this.y = reshape(varargin{2},length(varargin{2}),1);
            this.u = reshape(varargin{3},length(varargin{3}),1);
            this.bed = varargin{4};
            this.size_class = varargin{5};
            this.era = varargin{6};
            
        else
            error('Invalid input arguments.')
        end
    end
end

end
    