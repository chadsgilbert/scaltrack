function result = maketrack(tr, varargin)
%MAKETRACK assembles a track object as a struct for use by the constructor.
%  MAKETRACK returns a struct with all the same fields as the Trackobject to be
%  constructed.
%
%  MAKETRACK(TR) turns the track struct into a struct designed for use by the
%  Track constructor.
%
%  MAKETRACK(TR, BED) does the same, but only for particles seeded in the bed,
%  BED.

% Index the particles to be kept.
if nargin == 2
    bed = varargin{1};
    tic
    ind = in_bed(bed, tr.x(:,1), tr.y(:,1));
    toc
    result.bed = bed.name;
else
    ind = ones(size(tr.x(:,1)));
    result.bed = 'All';
end

% Assign the fields.
result.yd = tr.t;
result.x = tr.x(ind,:);
result.y = tr.y(ind,:);
result.z = tr.z(ind,:);
result.p = tr.p(ind,:);
result.d = tr.d(ind,:);
result.T = tr.T(ind,:);

% Name the random-walk algorithm.
if ~isempty(strfind(tr.method,'vi'))
    result.rw = 'Visser';
elseif ~isempty(strfind(tr.method,'no'))
    result.rw = 'None';
else
    result.rw = 'Unknown';
end

% Name the season.
switch result.yd(1)
    case 137
        result.season = 'Spring';
    case 260
        result.season = 'Fall';
    otherwise
        result.season = 'Unknown';
end

% Name the simulated swimming behaviour.
if ~isempty(strfind(tr.method,'pa'))
    result.behaviour = 'Passive';
elseif ~isempty(strfind(tr.method,'py'))
    result.behaviour = 'Pycnocline-Seeking';
else
    result.behaviour = 'Unknown';
end

end