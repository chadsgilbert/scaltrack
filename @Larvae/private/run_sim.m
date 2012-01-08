function n = run_sim(track, n0, mort)
%RUN_SIM computes the number of larvae at each particle position for each time.
%  RUN_SIM computes the number of larvae to be represented by each particle in
%  the tracking simulation using the mortality given initial ensemble population
%  and the rule for calculating the mortality rate.
%
%  RUM_SIM(TRACK, N0, MORT) where TRACK is a Track, N0 is the initial number of
%  larvae at each initial position in the track, and MORT is a string saying
%  what kind of mortality ot simulate, estimates the number of larvae at each
%  particle position for each time-step in the given track simulation.
%
%  The implemented options for MORT are:
%  'm0' -- a constant mortality rate of 20% per day. 
%          $n_k(t_i) = n_k(t_0) exp(-m t_i)$
%  'm1' -- a temperature-dependent mortality rate (Q_10 = 2, T_0 = 13.7 C) with
%          base mortality rate of 20% per day.
%          $n_k(t_i) = n_k(t_{i-1}) exp(-m(T) t_{i-1})$
%
%  Example:
%  >> n = run_sim(tr, n0, this.mortality)
%
%See also: Larvae

% Author: Chad Gilbert
% Modified: December 9, 2010

% Initialize variables.
n = NaN(size(track.x));     % Pre-allocate the nLarvae matrix.
n(:,1) = n0;                % Set the initial condition provided.

m0 = 0.2232;                % Mortality of 20% per day.
dt = 12.42/24;              % Time per time step in days.

% Choose the mortality model to be applied.
switch mort
    case 'none'
        tvec = 0:dt:(track.yd(end)-track.yd(1));
        n = n0*tvec;
    case 'm0'
        % Run the model with constant mortality rate.
        tvec = 0:dt:(track.yd(end)-track.yd(1));
        n = n0*exp(-m0*tvec);
    case 'm1'
        % Run the temperature-dependent model (Q10=2, T0=13.7, M0=0.2).
        Q10 = 2;    % The sensitivity to temperature.
        T0 = 13.7;  % The default temperature.
        for i = 2:length(track.yd)
            n(:,i) = n(:,i-1).*exp(-m0*dt*(Q10.^((track.T(:,i-1)-T0)/10)));
        end
    otherwise
        error('Invalid value for MORT provided.')
end

ind = isnan(track.x);
n(ind) = 0;

end