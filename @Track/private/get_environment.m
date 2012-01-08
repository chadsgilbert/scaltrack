function envnew = get_environment(datadir,envold)
%GETENVIRONMENT updates the environment struct by one 12.42 hour time-step.
%
%  ENVNEW = GETENVIRONMENT(ENVOLD) takes the current environment ENVOLD, and
%  interpolates its future value on tidal cycle (12.42 hours) into the future.
%  This uses the processes FVCOM files, which must be located in the path (see 
%  below).
%
%  Warning: this function requires that the processed fvcom data be located in
%  the MATLAB file path. You may be shown a popup window if the data are not in
%  the path. Sorry. If this occurs, locate the directory where the files
%  "/fvcom53mon/*" are located using the the provided "uigetdir" window, and
%  clock "okay". This should fix the problem permanently by creating a special 
%  file "datadir.mat" (so do not delete this file), and by adding this file
%  to your MATLAB path. I know it's gross and I'm sorry, but hopefully you'll
%  only have to go through it once.
%
%See also: track_pavi.m, track_pyvi.m, set_environment.m

% Update the yeardate variable.
envnew.yd = envold.yd + 12.42/24;
mid_month = datenum([zeros(12,1) (1:12)' eomday(zeros(12,1), (1:12)')/2]);

i = find( (mid_month < envold.yd) , 1, 'last'); % Index of last month.
j = find( (mid_month < envnew.yd) , 1, 'last'); % Index of this month.

% Check to see if any new data need to be loaded.
if ( i ~= j )
    
    % Load the data for the new month.
    mon = datestr(envnew.yd+31, 'mm');
    disp(['next month:' mon]);
    data_load(datadir,mon);
    
    % Assign the new data to envnew, passing envold to envnew.
    envnew.uold = envold.unew;
    envnew.unew = flow.dx;
    envnew.vold = envold.vnew;
    envnew.vnew = flow.dy;
    envnew.wold = envold.wnew;
    envnew.wnew = flow.dz;
    envnew.told = envold.tnew;
    envnew.tnew = T;
    envnew.kold = envold.knew;
    envnew.knew = km;
    envnew.rold = envold.rnew;
    envnew.rnew = rho;
    
    i = j;
else
    % If no new fields need to be loaded, pass the old values to the new env.
    envnew = envold;
    envnew.yd = envold.yd + 12.42/24;
end

% Get the new interpolated environmental values.
monold = month(envnew.yd);
monnew = month(envnew.yd)+1;
ydmold = datenum(0,monold,1) + eomday(1,monold)/2;
ydmnew = datenum(0,monnew,1) + eomday(1,monnew)/2;
len = ydmnew - ydmold;          % The length (in days) of the month.
a = (ydmnew - envnew.yd)/len;   % Relative weight of old month.
b = (envnew.yd - ydmold)/len;   % Relative weight of new month.

% Update the values for 'today'.
envnew.u = a.*envnew.uold + b.*envnew.unew;
envnew.v = a.*envnew.vold + b.*envnew.vnew;
envnew.w = a.*envnew.wold + b.*envnew.wnew;
envnew.t = a.*envnew.told + b.*envnew.tnew;
envnew.k = a.*envnew.kold + b.*envnew.knew;
envnew.r = a.*envnew.rold + b.*envnew.rnew;

end

function data_load(datadir,mon)

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