function result = track_pavi(datadir,x0,y0,t0,tmax)
%TRACK_PAVI tracks passive particles using the Visser formula for random-walk.
%  TRACK_PAVI simulates the advection and dispersion of particles representing 
%  individual scallop larvae, which implement a passive swimming behaviour (ie.
%  no swimming). This transport occurs for each particle beginning on a
%  particular day of the year and goes for a set number of days.
%
%  TRACK_PAVI(DATADIR, X0, Y0, T0, TMAX) Tracks particles from their initial 
%  positions (X0, Y0) in a bed. They start in either the 'spring' or 'fall' 
%  season, depending on the value of T0. They are tracked for TMAX days. DATADIR
%  gives the path to the environmental data used to run the simulation.
%
%  This function uses a relatively large data set to perform its computations,
%  and so loads the data as needed and then clears them from memory as soon as 
%  they are no longer needed. Instead of taking these data as arguments, this
%  function takes the filepath of the data set as an argument, so that the files
%  can be read only as needed. The contents of the data directory must be as
%  follows:
%    datadir/
%      |----> 01/
%      |       |---> flow.mat
%      |       |---> T.mat
%      |       |---> kh.mat
%      |       |---> rho.mat
%      |
%      |----> 02/
%      |       |---> flow.mat
%      |       |---> T.mat
%      |       |---> kh.mat
%      |       |---> rho.mat
%      |
%      |----> 03/
%      |      ...
%      |----> 12/
%      |       |---> flow.mat
%      |       |---> T.mat
%      |       |---> kh.mat
%      |       |---> rho.mat
%      |
%      |----> domain.mat
%
%  such that there are 12 folders, each corresponding to one month of the year
%  (01 = January, 02 = February, etc.) and in each of those directories, are
%  three files, flow.mat, T.mat and kh.mat, which represent the currents,
%  temperature and vertical mixing coefficients, respectively. Flow.mat is a
%  struct with fields dx, dy and dz, the Lagrangian residual displacements
%  associated withthe M2 tidal frequency (See chapter 2 in Gilbert, 2011). T.mat
%  contains the temperatures and kh the mixing coefficients. Each of these five
%  variables is a 3D NxMxP array, where the first dimension corresponds to
%  evenly spaced samples of the field in the "x" direction, the second dimension
%  to samples in the "y" direction and the third to samples in the "z" 
%  direction. The file domain.mat must be a Domain object that describes the
%  domain in which the monthly flow and property fields are descibed.
%
%  Example:
%    >> track = track_pavi('~/fvcom53/', nep.x0, nep.y0, 137, 60);
%  runs a particle-tracking simulation in spring (starting on yearday 137) for 
%  60 days with Visser random walk, for particles spawned in the NEP, using data
%  stored at '~/fvcom53.
%
%See also: Track, Domain, track_pyvi, get_environment, set_environment,
%rw_visser, get_pycnocline_depth, myinterp1

% Figure out how long to run the simulation.
nsteps = ceil(tmax*24/12.42);   % The number of time-steps to integrate.
nparticles = 64;                % # of particles seeded at each point in bed.
N = nparticles*length(x0);      % The total number of particles being seeded.
t = t0:(12.42/24):(t0+tmax+.1); % The time vector for the simulation (yeardays).

% Make the waitbar so user knows what's going on.
h = waitbar(1/(nsteps+2), 'Initializing variables.');

% Load the model domain.
load([datadir filesep 'domain.mat']);
xvec = domain.xvec;
yvec = domain.yvec;
dpth = domain.dpth;
svec = domain.svec;
pvec = domain.pvec;

% Create the environment struct "env".
env = set_environment(datadir,t0);

% Get the pycnocline depth at each particle initial position.
d0 = interp2(xvec, yvec, dpth, x0, y0);     % Initial water col. depths.
p0 = get_pycnocline_depth(x0, y0, d0, env.r, domain);   % Pycno depth.
i = isnan(p0);  % Index of particles in well-mixed regions.
z0 = p0;        % Create the particle initial depth vector.
z0(i) = mean(p0(~i)); % Choose intial depths for particles in well-mixed water.

% Pre-allocate local variables. Rows for particles, columns for time-steps.
x = NaN(N, nsteps);        % x-position
y = NaN(N, nsteps);        % y-position
z = NaN(N, nsteps);        % z-position
T = NaN(N, nsteps);        % temperature.
d = NaN(N, nsteps);        % the bottom-depth.
p = NaN(N, nsteps);              % Pycnocline depth (meters) (+ is up)
pelagic = NaN(N, nsteps);  % (logical 1 means 'in domain').

% Pre-allocate some temporary variables as well.
u = NaN(N,1);        %  east/west  flow. (+ E)  m/dt.
v = NaN(N,1);        % north/south flow. (+ N)  m/dt.
w = NaN(N,1);        %    up/down  flow. (+ up) m/dt.
s = NaN(N,1);        % Sigma coordinate corresponding to z-position.
k = NaN(N,1);        % Mixing coefficient.

rw = NaN(N,1);       % Vertical random-walk excursion (+ meters).

% Store positional ICs in the appropriate matrices.
x(:,1) = repmat(x0,nparticles,1);
y(:,1) = repmat(y0,nparticles,1);
p(:,1) = repmat(z0,nparticles,1);
z(:,1) = repmat(z0,nparticles,1);
d(:,1) = repmat(d0,nparticles,1);
s(:,1) = repmat(z0./d0,nparticles,1);
pelagic(:,1) = 1;
in = find(pelagic(:,1)==1);

% Clear the input variables.
clear x0 y0 z0 p0 d0 t0 tmax;

% Run through the loop.
for i = 1:nsteps
    waitbar(i/(nsteps+2), h, ...
        ['Running the sim... (loop ' num2str(i) ' of ' num2str(nsteps) ')']);
    
    % Get the environment for time i.
    env = get_environment(datadir,env);
    
    % Interpolate physical values to the new particle-positions.
    u(in)   = interp3(xvec, yvec, svec, env.u, x(in,i), y(in,i), s(in));
    v(in)   = interp3(xvec, yvec, svec, env.v, x(in,i), y(in,i), s(in));
    w(in)   = interp3(xvec, yvec, svec, env.w, x(in,i), y(in,i), s(in));
    T(in,i) = interp3(xvec, yvec, pvec, env.t, x(in,i), y(in,i), s(in));
    
    % Move the particles to their next location.
    x(in,i+1) = x(in,i) + u(in);
    y(in,i+1) = y(in,i) + v(in);
    
    % Update list of particles still in the domain, so the rest can be ignored.
    pelagic(:,i+1) = ~isnan(x(:,i+1));
    in = find(pelagic(:,i+1));
    
    % Get the particle depth and pycnocline depth at position i+1.
    d(in,i+1) = interp2(xvec, yvec, dpth, x(in,i+1), y(in,i+1), '*linear', 0);
    p(in,i+1) = get_pycnocline_depth(x(in,i+1),y(in,i+1),d(in,i+1),env.r,domain);
    
    % Update the list again, in case d is NaN (means particles or on land).
    pelagic(:,i+1) = (~isnan(x(:,i+1)) & d(:,i+1)>0);
    in = find(pelagic(:,i+1));
    
    % Get the flow part.
    z(in,i+1) = z(in,i) + w(in);
    s(in) = z(in,i+1)./d(in,i+1);
    
    % Apply reflective boundaries to jumpers and diggers.
    ind = find( s > 0 );            % Find jumpers.
    s(ind) = -s(ind);               % Bounce them back underwater.
    ind = find( s < -1);            % Find diggers.
    s(ind) = -2 - s(ind);           % Bounce them back into the water.
    ind = (s > 0) | (s < -1) | isnan(s);
    s(ind) = -rand(sum(ind),1);     % Fix really bad ones.
    z(:,i+1) = s.*d(:,i+1);         % Update z to match sigma.

    % Get the random-walk excursion for each particle.
    strat = ~isnan(p) & pelagic(:,i+1);
    rw(strat) = rw_visser(x(strat,i+1), y(strat,i+1), d(strat,i+1), ...
        s(strat), env.k, 100, domain);
    z(strat,i+1) = z(strat,i+1) + rw(strat);
    
    % Do the well-mixed correction.
    tur = isnan(p) & pelagic(:,i+1);
    s(tur) = -rand([sum(tur) 1]);
    z(tur,i+1) = s(tur).*d(tur,i+1);

end

T(in,i+1) = interp3(xvec, yvec, pvec, env.t, x(in,i), y(in,i), s(in,i));
waitbar(1, h, 'Finished! Storing the tracking result.');

% Store the result in a "track" struct for analysis.
result = struct('yd',t, 'x',x, 'y',y, 'z',z, 'd',d, 'p',p, 'T',T);

close(h);

end