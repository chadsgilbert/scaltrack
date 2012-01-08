classdef Settlement
%SETTLEMENT a class for things and stuff.
%
%  SETTLEMENT() makes and empty Settlement.
%
%  SETTLEMENT(TRACK, DOMAIN, PLD) makes a Settlement distribution object for the 
%  track, TRACK within the domain DOMAIN. PLD is a string, giving either 'ind'
%  for individually-varying PLD or 'const' for constant PLD.
%
%  SETTLEMENT(TRACK, DOMAIN, IPLD) does the same, except uses the values given
%  in IPLD as settlement indices, instead of calculating them in the
%  constructor.
%
%  SETTLEMENT(LARVAE, DOMAIN, PLD, MORT) is the same as for TRACK, except for a 
%  LARVAE object. The fourth argument MORT tells the mortality model to be used.
%  This is either 'const', 'T', or 'None'.
%
%  Example:
%  >> s = Settlement(track);
%  >> pcolor(s)
%  makes a pcolor of the settlement distribution.
%
%See also: Track, Larvae, Domain, pcolor, scatter

properties (SetAccess = private)
    % Crucial properties.
    xvec;   % The x axis.
    yvec;   % The y axis.
    u;      % The particle/larvae density in x per square kilometer.
    x;      % The x position of "stray" particles at a density less than 1.
    y;      % The y position of "stray" particles at a density less than 1.
end

properties (SetAccess = private)
    rw;         % Either "Visser" or "None" or "Unknown".
    behaviour;  % Either "Passive" or "Pycnocline-Seeking" or "Unknown".
    bed;        % Either "GSC", "NEP", "SFL", or "All".
    season;     % Either "Spring" or "Fall".
    mortality;  % Either "const" or "T" or "None".
    pld;        % Either "ind" or "const", and any number of parameters (cell).
    era;        % Either {'None', 'Pre-closures', 'Post-closures', 'Uniform'}
end

properties (SetAccess = private, Hidden = true)
    allowed_rw = {'None', 'Visser'};
    allowed_behaviour = {'Passive', 'Pycnocline-Seeking'};
    allowed_bed = {'GSC', 'NEP', 'SF', 'All'}
    allowed_season = {'Spring', 'Fall'};
    allowed_mortality = {'m0','m1'};
    allowed_pld = {'Constant', 'Individual'};
    allowed_era = {'Pre-closures', 'Post-closures', 'Uniform'};
end

methods
    function this = Settlement(varargin)
        
        if nargin == 0
            % Empty constructor.
            
        elseif isa(varargin{1}, 'Track')
            % Track constructor.
            dom = varargin{2};
            this.xvec = dom.xvec;
            this.yvec = dom.yvec;
            [ipld,this.pld] = read_pld(varargin{1},varargin{3});
            [this.u,this.x,this.y] = ...
                get_particle_distribution(varargin{1},varargin{2},ipld);
            this.rw = varargin{1}.rw;
            this.behaviour = varargin{1}.behaviour;
            this.bed = varargin{1}.bed;
            this.season = varargin{1}.season;
            this.mortality = 'None';
            this.era = 'None';
            
        elseif isa(varargin{1}, 'Larvae')
            %Larvae constructor.
            
            % Parse and name the input arguments.
            larv = varargin{1};
            dom  = varargin{2};
            [ipld,this.pld] = read_pld(larv,varargin{3});
            
            % Assign the properties.
            this.xvec = dom.xvec;
            this.yvec = dom.yvec;
            [this.u,this.x,this.y] = get_larval_distribution(larv,dom,ipld);
            this.rw        = larv.rw;
            this.behaviour = larv.behaviour;
            this.bed       = larv.bed;
            this.season    = larv.season;
            this.mortality = larv.mortality;
            this.era       = larv.era;
        else
            error('Invalid input arguments.')
        end
        
    end
    
end

end