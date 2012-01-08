function env = set_environment(datadir,yd)
%SET_ENVIRONMENT sets up the environment variable for the start of simulation.
%
%  ENV = SET_ENVIRONMENT(DATADIR,YD) returns a struct ENV, contianing Lagrangian 
%    displacement (dx,dy,dz), temperature (T), mixing (k) and density (rho) 
%    data. These are taken from the flow, property, and pycno files from the 
%    month in which the year day YD is in.
%
%  Example:
%    >> env = set_environment('~/fvcom', 137);
%    creastes a struct, env, from data at ~/fvcom using data from May and June,
%    since those are the months whose middles are nearest yearday 137.
%
%See also: Track, Track/private/get_environment

% Figure out which month to load.
mid_month = datenum([zeros(12,1) (1:12)' eomday(zeros(12,1), (1:12)')/2]);
ind = find(yd > mid_month, 1, 'last');

% Load the data for the early month: flow, T, km, rho
[flow,T,km,rho] = data_load(datadir,ind);

% Assign fields to the environment structure.
env.yd = yd;
env.monold = lower(datestr(yd,'mmm'));
env.uold = flow.dx;
env.vold = flow.dy;
env.wold = flow.dz;
env.told = T;
env.kold = km;
env.rold = rho;

% Now load the data for the later month.
[flow,T,km,rho] = data_load(datadir,ind+1);

% Assign next month's fields to the environment structure.
env.monnew = lower(datestr(yd,'mmm'));
env.unew = flow.dx;
env.vnew = flow.dy;
env.wnew = flow.dz;
env.tnew = T;
env.knew = km;
env.rnew = rho;

% Create place-holders for the evolving environmental variables.
env.u = env.uold;
env.v = env.vold;
env.w = env.wold;
env.t = env.told;
env.k = env.kold;
env.r = env.rold;

end

function [flow,T,km,rho] = data_load(datadir,ind)

% Name the folder
mon = num2str(ind,'%02d');

% Set the load strings.
flowstring = [datadir filesep mon filesep 'flow.mat' ]; % Currents.
tempstring = [datadir filesep mon filesep 'T.mat'    ]; % Temperature.
mixstring  = [datadir filesep mon filesep 'km.mat'   ]; % Mixing.
rhostring  = [datadir filesep mon filesep 'rho.mat'  ]; % Density.

% Load the fields for this month.
load(flowstring);
load(tempstring);
load(mixstring );
load(rhostring);

end