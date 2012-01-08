classdef Larvae
%LARVAE is a class for doing synth.
%  LARVAE is my thing.
%
%  LARVAE(LARVOBJ)
%
%  LARVAE(TRACKOBJ, SPAWNFIELD, MORTMODEL) MORTMODEL can be {'m0','m1'}
%
%  Example:
%    >> l = Larvae(track, spawnfield, 'm0');
%
%See also: Track, SpawnField

properties (SetAccess = public)
    yd;         % The yeardate of the time-step.
    x;          % The x position in meters.
    y;          % The y position in meters.
    z;          % The z position in meters below mean sea level
    d;          % The depth of the water column at (x,y).
    T;          % The local temperature at (x,y,z,yd)
    n;          % The number of larvae at (x,y,z,yd)
    rw;         % The random-walk scheme used. {'Visser', 'None'}
    behaviour;  % The swimming behaviour used. {'Passive', 'Pycnocline-seeking'}
    bed;        % The bed that the particles all started in. {'GSC','NEP','SF'}
    season;     % The season. {'Spring','Fall'}
    mortality;  % The type of mortality used. {'m0','m1'}
    era;        % The fishery era. {'Pre-closures', 'Post-closures', 'Uniform'}
    distribution;
end

properties (Constant = true)
    yd_units = 'yeardate';
    x_units = 'm';
    y_units = 'm';
    z_units = 'm';
    d_units = 'm';
    T_units = '^{\circ}C';
    n_units = 'scallops per particle';
    date_generated = date;
    allowed_rw = {'Visser', 'None'};
    allowed_behaviour = {'Passive','Pycnocline-Seeking'};
    allowed_bed = {'GSC', 'NEP', 'SFL', 'All'};
    allowed_season = {'Spring', 'Fall'};
    allowed_mortality = {'m0','m1','none'};
    allowed_era = {'Pre-closures (1984:1994)', ...
        'Post-closures (1996:2004)', ...
        'Uniform'};
end

methods
    function this = Larvae(varargin)
        
    if nargin == 1 && isa(varargin{1}, 'Larvae')
        % Copy constructor.
        this = varargin{1};
        
    elseif (nargin == 3) && isa(varargin{2},'SpawnField')
        % LARVAE(TRACKOBJ, SPAWNFIELD, M)
        % Make the Larvae from a Track and a Spawn using the given mortality.
        track = varargin{1};
        spawn = varargin{2};
        this.yd = track.yd;
        this.x = track.x;
        this.y = track.y;
        this.z = track.z;
        this.d = track.d;
        this.T = track.T;
        if ismember(track.rw,this.allowed_rw)
            this.rw = track.rw;
        else
            error('Invalid rw specfied.');
        end
        if ismember(track.behaviour,this.allowed_behaviour)
            this.behaviour = track.behaviour;
        else
            error('Invalid behaviour specfied.');
        end
        if ismember(spawn.bed,this.allowed_bed)
            this.bed = spawn.bed;
        else
            error('Invalid bed specfied.');
        end
        if ismember(track.season,this.allowed_season)
            this.season = track.season;
        else
            error('Invalid rw specfied.');
        end
        if ismember(varargin{3},this.allowed_mortality)
            this.mortality = varargin{3};
        else
            error('Invalid mortality model specfied.');
        end
        if ismember(spawn.era,this.allowed_era)
            this.era = spawn.era;
        else
            error('Invalid era specified.');
        end
        if size(this.x,1) == length(spawn.u)*64
            n0 = 16*repmat(spawn.u,64,1)/64;
        else
            error(['The given SpawnField and Track are incompatible.' ...
                ' They must be for the same bed.'])
        end
        this.distribution = spawn.distribution;
        this.n = run_sim(track, n0, this.mortality);
        
    else
        error('Invalid input arguments.')
    end
    end
end

end