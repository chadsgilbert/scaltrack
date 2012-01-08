function dz = rw_visser(x, y, d, s, k, n, dom)
%RW_VISSER computes the Visser random walk displacement in meters per second.
%
%  RW_VISSER(X, Y, D, S, K, N, DOMAIN)
%
%NOTE: Make sure k here is from 'env.k', NOT 'k'.

% Get the 'dk' matrix for computing the Visser correction term.
s1 = s;                         % Remember the original sigma-levels.
sx = size(x);                   % Remember the # of particles being handled.
kvec = zeros(sx(1), 32);        % Pre-allocate room for 'kvec'.
pvecs = ( dom.pvec * ones(sx)' )';  % Needed for interp3 to run.
for i = 1:32
    kvec(:,i) = interp3(dom.xvec, dom.yvec, dom.pvec, k, x, y, pvecs(:,i));
end
dk = diff(kvec, 1, 2)./.0323;   % The rate of change of k per unit sigma.

% Pre-compute some coefficients for efficiency.
DT = 12.42*3600;                % Tidal time [s]
coef = sqrt(2*3*DT/n);          % = sqrt(2 (sd) (tidal time) / (# of cycles))
dt = DT/n;                      % = (tidal time) / (# of subcycles)
ls = (1:length(s))';            % A list of identifiers for all the particles.
dp = [0; dom.pvec(2:30) + 0.5*diff(dom.pvec(2:31)); -1];

% Fix jumpers and diggers by reflection on boundaries.
indx = s < -1;              % Find diggers.
s(indx) = -2 - s(indx);     % Move diggers back into the domain.
indx = s > 0;               % Find jumpers.
s(indx) = -s(indx);         % Move jumpers back into the domain.
indx = (s > 0) | (s < -1) | isnan(s);   % If things bounced way
s(indx) = -rand(sum(indx),1);           % out, fix them again.

% Apply the Visser RW for n time steps of size, DT/n.
for i = 1:n
    % Get the random part.
    ks = myinterp1(dom.pvec', kvec, s');    % k, interped to current pos.
    ks(ks<0) = 0;   % Occasionally, small values come out negative.
    rw = coef*sqrt(ks').*(rand(sx) -.5)./d;     % Generate rw [sigma/s]
    
    % Get the Visser part.
    jj = interp1(dp, 1:31, s, 'nearest');
    ind = sub2ind(size(dk), ls, jj);            % List the 'dk' indices.
    ds = dt.*dk(ind);                           % Get Visser term [sigma/s]
    
    % Move to new location.
    s = s + ds + rw;
    
    % Fix jumpers and diggers by reflection on boundaries.
    indx = s < -1;              % Find diggers.
    s(indx) = -2 - s(indx);     % Move diggers back into the domain.
    indx = s > 0;               % Find jumpers.
    s(indx) = -s(indx);         % Move jumpers back into the domain.
    indx = (s > 0) | (s < -1) | isnan(s);   % If things bounced way
    s(indx) = -rand(sum(indx),1);           % out, fix them again.
end

dz = (s-s1).*d;