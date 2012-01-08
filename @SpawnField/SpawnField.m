classdef SpawnField
%SPAWNFIELD a 2D field of scallop larval production.
%  SPAWNFIELD lists the number of larvae that are spawned at each location in a
%  Bed. The number of larvae l(x,y) is given by
%
%    l(x,y) = f_s c_s(x,y) + f_m c_m(x,y) + f_l c_l(x,y)
%
%  where f_s is the fecundity of small scallops, f_m medium and f_l large and
%  c_s(x,y) is the number of small scallops at position (x,y) and c_m medium and
%  c_l large. See Gilbert (2011) for an explanation.
%
%  SF = SPAWNFIELD(SKRIGE, fs, MKRIGE, fm, LKRIGE, fl) where SKRIGE is the
%  distribution of small scallops, and fs is their size-specific fecundity.
%  Similar for medium and large scallops.
%
%  SF = SPAWNFIELD(..., SEAS) the seventh argument denotes the season of the
%  spawning field. Since fecundity is season specific for scallops, this option
%  is recommended. SEAS can be 'Fall', or 'Spring'.
%
%  SF = SPAWNFIELD(..., SEAS, 'flat') passing in an 8th argument, the string 
%  'flat' makes a homogeneous SpawnField, which conforms to the description of
%  Larval production fields in Gilbert (2011).
%
%  Example:
%    >> sf = SpawnField(krige_s, f_fal.s, krige_m, f_fal.m, krige_l, f_fal.l);
%  makes a spawnfield from three kriges, using the size-specific fecundities 
%  given.
%
%See also: Krige, GonData, plot, zoom

properties (SetAccess = private)
    x;          % The list of x-positions in which an estimate is given.
    y;          % The list of y-positions in which an estimate is given.
    u;          % The predicted scallop density in scallops per km^2.
    bed;        % [string] The name of the bed, if relevant.
    era;        % [string] The era.
    season;     % [string] The season.
    distribution; % {'homogeneous', 'heterogeneous'}
end

properties (Constant = true)
    x_units = 'm';
    y_units = 'm';
    u_units = 'larvae per km^2';
end

methods
    function this = SpawnField(varargin)
        if nargin == 6 && isa(varargin{1},'Krige') && isnumeric(varargin{2})
            % SpawnField(ks, fs, km, fm, kl, fl)
            ks = varargin{1};
            fs = varargin{2};
            km = varargin{3};
            fm = varargin{4};
            kl = varargin{5};
            fl = varargin{6};
            this.x = ks.x;
            this.y = ks.y;
            this.u = fs*ks.u + fm*km.u + fl*kl.u;
            this.bed = ks.bed;
            this.era = ks.era;
            this.season = questdlg('Which season is it?','Choose a season', ...
                'Spring','Fall','None');
            if isempty(this.season)
                error('Must specify a season.');
            end
            this.distribution = 'heterogeneous';
        
        elseif nargin == 7 && isa(varargin{1},'Krige') && isnumeric(varargin{2})
            % SpawnField(ks, fs, km, fm, kl, fl, SEAS)
            ks = varargin{1};
            fs = varargin{2};
            km = varargin{3};
            fm = varargin{4};
            kl = varargin{5};
            fl = varargin{6};
            this.x = ks.x;
            this.y = ks.y;
            this.u = fs*ks.u + fm*km.u + fl*kl.u;
            this.bed = ks.bed;
            this.era = ks.era;
            switch lower(varargin{7}(1))
                case 's'
                    this.season = 'Spring';
                case 'f'
                    this.season = 'Fall';
                otherwise
                    error('Invalid season specified.');
            end
            this.distribution = 'heterogeneous';

        elseif nargin == 8 && isa(varargin{1},'Krige') && isnumeric(varargin{2})
            % SpawnField(ks, fs, km, fm, kl, fl, SEAS, 'flat')
            ks = varargin{1};
            fs = varargin{2};
            km = varargin{3};
            fm = varargin{4};
            kl = varargin{5};
            fl = varargin{6};
            this.x = ks.x;
            this.y = ks.y;
            this.u = fs*ks.u + fm*km.u + fl*kl.u;
            this.bed = ks.bed;
            this.era = ks.era;
            switch lower(varargin{7}(1))
                case 's'
                    this.season = 'Spring';
                case 'f'
                    this.season = 'Fall';
                otherwise
                    error('Invalid season specified.');
            end
            if strcmp(varargin{8},'flat')
                this.u = repmat(mean(this.u),length(this.u),1);
                this.distribution = 'homogeneous';
            else
                error('Invalid option specified.')
            end
            
        else
            error('Invalid input.')
        end
    end
end

end