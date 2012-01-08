classdef Domain
%DOMAIN describes the domain for a particle-tracking simulation.
%  DOMAIN describes the domain in which the particle-tracking simulations stored
%  in 'Track' and 'Larvae' objects. It describes the bathymetry, sigma layers,
%  land and other features such as closed areas and international borders. 
%
%  DOMAIN() builds an empty domain.
%
%  DOMAIN(DOMOBJ) copies an existing Domain object and returns another.
%
%  DOMAIN(XYDOM) uses a struct, XYDOM with fields: {xvec, yvec, svec, pvec, 
%  dpth, cape, mart} to create the object.
%
%  DOMAIN(FILENAME) uses a struct located in file FILENAME. The file must
%  contain an xydom struct.
%
%  DOMAIN(XVEC, YVEC, SVEC, PVEC, DPTH, LAND) creates a Domain object with those
%  fields.
%
%  DOMAIN(..., CA) if closed areas are to be recorded, then append them, each
%  as a polygon in a cell array.
%
%  Example:
%  >> load xydom
%  >> gb = Domain(xydom)
%  creates a Domain object containing the bathymetry & data for Georges Bank.
%
%See also: plot

properties (SetAccess = private)
    xvec;   % A [1xN] vector of x values.
    yvec;   % A [Mx1] vector of y values.
    svec;   % A [Lx1] vector of sigma values for flow.
    pvec;   % A [Kx1] vector of sigma values for properties.
    dpth;   % A [MxN] matrix of depth values.
    land;   % a cell array of P polygons identifying land.
    ca;     % a cell array of Q polygons identifying closed areas.
    ib;     % a cell array of lines identifying {i}nternational {b}orders (etc.).
end

properties (Constant = true)
    x_units = 'm';
    y_units = 'm';
    dpth_units = 'm';
    contour_depths = [60 100 200];
    plot_dimensions = [50 50 770 500];
end

methods
    function this = Domain(varargin)
        
        if (nargin == 0)
            % DOMAIN()
            
        elseif mod(nargin,2)==1 && isa(varargin{1},'Domain')
            % DOMAIN(DOMOBJ)
            this = varargin{1};
        
        elseif ismember(nargin, 1:2) && isstruct(varargin{1})
            % DOMAIN(XYDOM)
            xydom = varargin{1};
            this.xvec = xydom.xvec;
            this.yvec = xydom.yvec;
            this.svec = xydom.svec;
            this.pvec = xydom.pvec;
            this.dpth = xydom.dpth;
            this.land{1} = xydom.cape;
            this.land{2} = xydom.mart;
            if nargin == 2
                % Make sure the ca's are all properly oriented.
                cas = varargin{2};
                for i = 1:length(cas)
                    if size(cas{i},1) > 2 && size(cas{i},2) == 2
                        cas{i} = cas{i}';
                    end
                end
                this.ca = cas;
            end
            
        elseif ismember(nargin, 1:2) && ischar(varargin{1})
            % DOMAIN(FILENAME, ARGS)
            dom = load(varargin{1});
            fld = fieldnames(dom);
            dom = dom.(fld{1});
            switch nargin
                case 1
                    this = Domain(dom);
                case 2
                    this = Domain(dom,varargin{2});
            end
        
        elseif ismember(nargin, 6:7) && isnumeric(varargin{1})
            % DOMAIN(XVEC, YVEC, SVEC, PVEC, DPTH, LAND)
            this.xvec = varargin{1};
            this.yvec = varargin{2};
            this.svec = varargin{3};
            this.pvec = varargin{4};
            this.dpth = varargin{5};
            this.land = varargin{6};
            if nargin == 7
                this.ca = varargin{7};
            end
        else
            error('Invalid input arguments.')
        end
        
        % Check to see if the contents of dom are consistent.
        [isgood,fld] = isconsistent(this);
        if ~isgood
            for i = 1:length(fld)
                disp(['There is a problem in field: ' fld{i}]);
            end
            error('Tried to build an invalid Domain object.')
        end
        
    end
end

end