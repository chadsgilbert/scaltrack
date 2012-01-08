classdef Track
%TRACK a class for storing particle tracking results.
%  TRACK stores the particle-trajectories, and the local environmental
%  properties experienced by each particle in the simulaiton. This class
%  currently does not generate these simulations, and can only load and
%  assimilate previously made results.
%
%  A TRACK contains the following data:
%    - The position (x, y, z) as a function of time t
%    - The water-column depth (d), and local temperature (T) as fns of time
%    - The time (yd) in yeardate format.
%    - A list of parameter settings that were used to generate the Track
%    - Some metadata about the units, etc.
%
%  Track(TRSTRUCT, BED) takes a track struct and a Bed object, and combines them
%  to make a Track object. TDSTRUCT can be either a struct, or a string,
%  providing a path to the struct to be used. Similarly, BED can either be a Bed
%  object, or a string pointing to the Bed object.
%
%  Track(YD, X, Y, Z, D, T, RW, BEHAV, BED, SEASON) creates the object directly
%  by assigning each of the arguments to their corresponding properties.
%
%  Track(TROBJ, BED) makes a Track using a previou track and the bed, BED. The
%  new track will contain only particles from the TROBJ that started within the
%  bed, BED. This is useful for examining the fates of subsets of beds.
%
%  Track(DATAPATH, RW, BEHAV, BED, SEASON) runs the particle-tracking sim
%  using thespecified parameters RW, BEHAV, BED, SEASON (all strings). DATAPATH
%  specifies the system path to the required data -- the circulation fields and
%  hydrographic fields, etc.
%
%  Example:
%    >> load track_137_pavi; load nep;
%    >> track_spring_passive = Track(track, nep);
%    makes a track object.
%
%See also: Larvae, scatter, pcolor, get_connection_fraction

% Data about the particles.
properties (SetAccess = private)
    yd;         % [1xn double] The yeardate of the time-step.
    x;          % [mxn double] The x position of the particle.
    y;          % [mxn double] The y position of the particle.
    z;          % [mxn double] The z position of the particle.
    d;          % [mxn double] The depth of the water-column at (x,y).
    p;          % [mxn double] The pycnocline depth at (x,y).
    T;          % [mxn double] The water temperature at (x,y,z).
    % The value NaN is associated with particles that are out of bounds.
end

% Data about the simulation parameters.
properties (SetAccess = private)
    rw;         % Values: {'Visser', 'None'}
    behaviour;  % Values: {'Passive', 'Pycnocline-Seeking'}
    bed;        % Values: {'GSC', 'NEP', 'SFL', 'GSC-S', 'GSC-E', 'CC'}
    season;     % Values: {'Spring', 'Fall'}
end

% Data about the Track class.
properties (Constant = true)
    yd_units = 'yeardate';
    x_units = 'm';
    y_units = 'm';
    z_units = 'm';
    d_units = 'm';
    T_units = '^{\circ}C';
    allowed_rw = {'Visser', 'None'};
    allowed_behaviour = {'Passive','Pycnocline-Seeking'};
    allowed_bed = {'GSC', 'NEP', 'SFL', 'cc', 'gsc-e', 'gsc-s'};
    allowed_season = {'Spring', 'Fall'};
end

methods 
    function this = Track(varargin)
    if (nargin==2) && isstruct(varargin{1}) && strcmp(varargin{2},'build')
        % TRACK(TRSTRUCT, 'build')
        td = varargin{1};
        this.yd = td.yd;
        this.x = td.x;
        this.y = td.y;
        this.z = td.z;
        this.d = td.d;
        this.p = td.p;
        this.T = td.T;
        this.rw = td.rw;
        this.behaviour = td.behaviour;
        this.bed = td.bed;
        this.season = td.season;
        
    elseif (nargin == 2) && isstruct(varargin{1}) && isa(varargin{2},'Bed')
        % TRACK(TRSTRUCT, BEDOBJ)
        tr = maketrack(varargin{1},varargin{2});
        tr = check_vals(tr);
        this = Track(tr,'build');
        
    elseif (nargin == 2) && isstruct(varargin{1}) && ischar(varargin{2})
        % TRACK(TRSTRUCT, BEDSTRUCT)
        bedobj = load(varargin{2});
        n = fieldnames(bedobj);
        tr = maketrack(varargin{1}, bedobj.(n{1}));
        tr = check_vals(tr);
        this = Track(tr,'build');
        
    elseif (nargin == 2) && ischar(varargin{1}) && isa(varargin{2},'Bed')
        % TRACK(TRPATH, BEDOBJ)
        tr = load(varargin{1});
        tr = maketrack(tr.track);
        tr = check_vals(tr);
        this = Track(tr,'build');
        
    elseif (nargin == 2) && ischar(varargin{1}) && ischar(varargin{2})
        % TRACK(TRPATH, BEDSTRUCT)
        tr = load(varargin{1});
        bedobj = load(varargin{2});
        n = fieldnames(bedobj);
        tr = maketrack(tr.track, bedobj.(n{1}));
        tr = check_vals(tr);
        this = Track(tr,'build');
        
    elseif (nargin == 10) && isnumeric(varargin{1})
        % TRACK(YD, X, Y, Z, D, T, RW, BEHAV, BED, SEASON)
        tr.yd = varargin{1};
        tr.x = varargin{2};
        tr.y = varargin{3};
        tr.z = varargin{4};
        tr.d = varargin{5};
        tr.T = varargin{6};
        tr.rw = varargin{7};
        tr.behaviour = varargin{8};
        tr.bed = varargin{9};
        tr.season = varargin{10};
        tr = check_vals(tr);
        this = Track(tr,'build');
    
    elseif (nargin == 2) && isa(varargin{1}, 'Track') && isa(varargin{2}, 'Bed')
        % TRACK(TRACKOBJ, BEDOBJ)
        this = varargin{1};
        ind = in_bed(varargin{2}, this.x(:,1), this.y(:,1));
        this.x = this.x(ind,:);
        this.y = this.y(ind,:);
        this.z = this.z(ind,:);
        this.d = this.d(ind,:);
        this.T = this.T(ind,:);
        this.bed = varargin{2}.name;
        
    elseif (nargin==5) && ischar(varargin{1})
        % TRACK(DATAPATH, RW, BEHAV, BED, SEASON)
        
        % Store the simulation parameters as metadata.
        this.rw = varargin{2};
        this.behaviour = varargin{3};
        this.bed = varargin{4}.name;
        this.season = varargin{5};
        
        % Run the appropriate simulation code.
        ics = varargin{4};
        switch [this.behaviour ' ' this.season]
            case 'Passive Fall'
                tr = track_pavi(varargin{1}, ics.x0, ics.y0, 260, 60);
            case 'Passive Spring'
                tr = track_pavi(varargin{1}, ics.x0, ics.y0, 137, 60);
            case 'Pycnocline-seeking Fall'
                tr = track_pyvi(varargin{1}, ics.x0, ics.y0, 260, 1);
            case 'Pycnocline-seeking Spring'
                tr = track_pyvi(varargin{1}, ics.x0, ics.y0, 137, 60);
            otherwise
                error('Invalid swimming behaviour or season requested.');
        end
        
        % Save the simulation result.
        this.yd = tr.yd;
        this.x = tr.x; 
        this.y = tr.y; 
        this.z = tr.z;
        this.d = tr.d; 
        this.T = tr.T;

    else
        error('Invalid input arguments.')
    end
    
    end
    
end

end