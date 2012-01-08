function gondata = import_gsidata(filename)
%IMPORT_GSIDATA imports the gsidata from text to a GonData object.
%  IMPORT_GSIDATA loads whatever data are found in the file provided and tries
%  to convert them into a a GonData object. If successful, it returns a struct
%  with the fields required to make such an object by the GonData costructor.
%
%  IMPORT_GSIDATA(FILENAME) reads the data from the file pointed to by the
%  string FILENAME. FILENAME is the full name of the file.
%
%Example:
%  >> gondata = import_gsidata('./gsidata_raw.dat')
%
%  This file should probably not be called from outside of the GonData 
%  constructor, though it may run successfully...
%
%See also: GonData.m

% Check if the file exists, and if so, load it.
if ~exist(filename, 'file')
    error('Invalid file requested.');
else
    load(filename)
    [~,file] = fileparts(filename);
    dat = eval(file);
end

% Get the sample time.
year  = dat(:,1);
month = dat(:,2);
day   = dat(:,3);

% Convert lat and lon to degrees/decimal degrees from freaky units.
lat = floor(dat(:,4)/100) + mod(  dat(:,4)/100, 1)./0.6;
lon =  ceil(dat(:,5)/100) - mod(1-dat(:,5)/100, 1)./0.6;
dpth = dat(:,6);

% Get physiological measurements.
height = dat(:,7);
wgw    = dat(:,8);
wmw    = dat(:,9);
wspw   = dat(:,10);
sex    = dat(:,11);

% If the sex is reported numerically, change to 'm' and 'f'.
if isnumeric(sex(1))
    indsex = sex == 1;
    sex = cell(length(sex),1);
    sex( indsex) = {'f'};
    sex(~indsex) = {'m'};
end

% Make the struct.
gondata.year = year;
gondata.month = month;
gondata.day = day;
gondata.lat = lat;
gondata.lon = lon;
gondata.dpth = dpth;
gondata.height = height;
gondata.wgw = wgw;
gondata.wmw = wmw;
gondata.wspw = wspw;
gondata.sex = sex;

end