classdef Bed
%BED a class for describing scallop beds.
%  BED describes a bed as a region in 2d space using a polygon. The name of the
%  bed and the spawning positions within the bed are also given.
%  
%  BED() makes an empty Bed object.
%
%  BED(BEDOBJ) copies the given Bed object.
%
%  BED(BEDSTRUCT, NAME) makes a Bed object using a bed struct, and its associated
%  name.
%
%  BED(BEDSTRUCT, NAME, GAP) does the same, but adds a gap (or gaps). GAP can be
%  a cell array conatining any number (0-inf) of [2xN_i] polygons, or it can be
%  a [2xN] polygon.
%
%  BED(FILENAME, NAME) makes a Bed object using a bed struct by loading it from
%  the file pointed to by FILENAME.
%
%  BED('ginput', NAME, FILE1, FILE2, ...) allows the user to draw a new bed and
%  then saves it. The files FILE1 FILE2, etc will be plotted using the plot
%  command beforehand, so that the user can have some context for their clicks.
%  (Example: >> b = Bed('ginput', 'GSC-E', '~/domain.mat', '~/gsc')
%
%  BED(NAME, X0, Y0, BORDER, GAP) makes a Bed object with the corresponding 
%  fields filled in.
%
%  Example:
%    >> load nep025_4x4
%    >> nepobj = Bed(nep)
%    makes a bed object for the NEP.
%
%See also: plot, scatter, zoom

% The properties used by the constructor.
properties (SetAccess = private)
    name;   % [string] The name of the bed.
    x0;     % [nx1 double] the x positions of points located inside the bed.
    y0;     % [nx1 double] the y positions of points located inside the bed.
    border; % [2xm double] A polygon outlining the border of the bed.
    gap={}; % Cell array: [2xp double]s. Polygon outlining gaps within the bed.
end

% Properties that will be cached if they ever get computed.
properties
    border_ll;  % The broder in lon/lat coordinates.
    gap_ll={};  % The gaps in lon/lat coordinates.
end

% Optional properties.
properties (SetAccess = private, Hidden = true)
    labelpos;   % The position to place a label.
end

% Metadata.
properties (Constant = true)
    x_units = 'm';          % x-coords are given in meters.
    y_units = 'm';          % Y-coords are given in meters.
    contour_threshold = 25; % # of scallops per tow used to make the contour.
end

methods
    function this = Bed(varargin)
        if nargin == 0
            % BED()
            
        elseif (nargin == 1) && isa(varargin{1}, 'Bed')
            % BED(BEDOBJ)
            this = varargin{1};
            
        elseif strcmp(varargin{1}, 'ginput')
            % BED('ginput', NAME, VARARGIN)
            
            % Plot any extra arguments for reference.
            hold on; for i = 3:nargin, plot(varargin{i}); end
            
            % Get the border
            ind = NaN(1,nargin-3);
            for i = 3:nargin
                if isa(varargin{i}, 'Bed');
                    ind = i; break;
                end
            end
            bdr = ginput()';
            this.border = get_new_border(varargin{ind}.border,bdr);
            this.gap = {};
            this.name = varargin{2};
            
            % Find the IC points in the bed.
            xvec = 9e5:4000:13e5;
            yvec = -3.2e5:4000:0.5e5;
            [X,Y] = meshgrid(xvec,yvec);
            ind = inpolygon(X, Y, this.border(1,:), this.border(2,:));
            this.x0 = X(ind);
            this.y0 = Y(ind);
            
        elseif (nargin == 2) && isstruct(varargin{1}) && ischar(varargin{2})
            % BED(
            this.x0 = varargin{1}.x0(1:end/64);
            this.y0 = varargin{1}.y0(1:end/64);
            this.border = varargin{1}.border_xy;
            this.name = varargin{2};
            if isfield(varargin{1},'gap')
                this.gap = varargin{1}.gap;
            end
            try
                this.border_ll = proj_xy2ll(this.border)';
                for i = 1:length(this.gap)
                    this.gap_ll{i} = proj_xy2ll(this.gap{i})';
                end
            catch w
                disp(w.message)
                warning('chadoop:Bed','Can''t make border in lon/lat coords.');
            end
            
        elseif (nargin == 3) && isstruct(varargin{1}) && ischar(varargin{2})
            
            this.x0 = varargin{1}.x0(1:end/64);
            this.y0 = varargin{1}.y0(1:end/64);
            this.border = varargin{1}.border_xy;
            this.name = varargin{2};
            if iscell(varargin{3}) && size(varargin{3}{:},1) == 2 
                this.gap = varargin{3};
            elseif isnumeric(varargin{3}) && size(varargin{3}{:},1) == 2 
                this.gap = varargin(3);
            else
                error('Invalid format for GAP.')
            end
        
        elseif ismember(nargin, 2:3) && ischar(varargin{1}) ...
                && ischar(varargin{2})
            % Load the bed struct and call the Bed/struct constructor.
            bed = load(varargin{1});
            fld = fieldnames(bed);
            this = Bed(bed.(fld{1}),varargin{2:end});
            
        elseif ismember(nargin, 4:5) && ischar(varargin{1})
            % BED(NAME, X0, Y0, BORDER, GAP)
            this.name = varargin{1};
            this.x0 = varargin{2};
            this.y0 = varargin{3};
            this.border = varargin{4};
            if nargin == 5
                this.gap = varargin{5};
            end
            
        else
            error('Invalid input arguments.')
        end
        
        switch lower(this.name)
            case 'gsc'
                this.labelpos = [9.8931   -2.0302]*1e5;
            case 'nep'
                this.labelpos = [1.1894   -0.100]*1e6;
            case {'sfl', 'sf'}
                this.labelpos = [1.1644   -0.1913]*1e6;
            case {'uh','uns','uha'}
                this.labelpos = [1 0]*1e6;
            otherwise
                this.labelpos = mean(this.border,2);
        end
            
    end
end

end