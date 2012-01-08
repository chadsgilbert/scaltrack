function varargout = check_vals(varargin)
%CHECL_VALS extends the track values to the rest of the entries in the track.
%  CHECK_VALS ensures that the parameter values given to the Track constructor
%  satisfy the definition given in the Track classdef file.
%
%  An error is thrown if the struct cannot be fixed.
%
%  TRGOOD = CHECK_VALS(TRBAD) where TRBAD is a struct which hasn't yet been
%  confirmed to satisfy the criteria, and TRGOOD is known to satisfy the
%  criteria.
%
%  Example:
%  >> tr = check_vals(tr);
%  returns a nice, tidy tr that can now be used to construct a Track object.
%
%See also: Track

tr = varargin{1};

% Check the simulation parameter values. (I wish MATLAB would handle enums).
if ~ismember(tr.rw       , Track.allowed_rw)       , error('RW');        end
if ~ismember(tr.behaviour, Track.allowed_behaviour), error('BEHAVIOUR'); end
if ~ismember(tr.bed      , Track.allowed_bed)      , error('BED');       end
if ~ismember(tr.season   , Track.allowed_season)   , error('SEASON');    end

% Make sure the matrices are all the same size.
ind = size(tr.T,2);
tr.yd = tr.yd(1:ind);
tr.x = tr.x(:,1:ind);
tr.y = tr.y(:,1:ind);
tr.z = tr.z(:,1:ind);
tr.d = tr.d(:,1:ind);
tr.T = tr.T(:,1:ind);

% Run through the track data to find out when each particle leaves the domain
for i = 1:size(tr.x,1)
    ind = find(isnan(tr.T(i,:)), 1, 'first');
    tr.x(i,ind:end) = NaN; %track.x(i,ind-1);
    tr.y(i,ind:end) = NaN; %track.y(i,ind-1);
    tr.z(i,ind:end) = NaN; %track.z(i,ind-1);
    tr.d(i,ind:end) = NaN; %track.d(i,ind-1);
    tr.T(i,ind:end) = NaN; % track.T(i,ind-1);
end

varargout{1} = tr;

end