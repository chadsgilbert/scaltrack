function varargout = bar(this, varargin)
%BAR plot the seasonal drop in a GonData varable.
%  BAR computes and plots the seasonal drop in GSI, WGW, WSPW, WMW, etc. in a
%  bar graph. This can be done for spring, fall or both on the same graph.
%
%  BAR(THIS) makes the plot for eggs in both seasons.
%
%  BAR(THIS, SEAS) where SEAS is 'fall', 'spri' or {'spri','fall'}. The first 
%  letter of each word is enough. {'spri', 'fall'} is the default.
%
%  BAR(THIS, SEAS, VAR) where VAR is any property in the GonData class that has
%  a [nx1] shape and is numeric, or 'eggs', which is the default.
%
%  SPAWNS = BAR(...) returns the spawning magnitudes for the plot.
%
%  [SPAWNS, YEARS] = BAR(...) also returns the YEARS vector that the spawns are 
%  plotted against.
%
%  Example:
%    >> bar(gdobj, 'fall', 'eggs')
%
%See also: plot, scatter

% Parse the input arguments.
switch nargin
    case 1
        seas = {'spring', 'fall'};
        var = 'eggs';
    case 2
        if ischar(varargin{1})
            seas = varargin(1);
        elseif iscell(varargin{1})
            seas = varargin{1};
        else
            error('Invalid format for SEAS.')
        end
        
        var = 'eggs';
        
    case 3
        if ischar(varargin{1})
            seas = varargin(1);
        elseif iscell(varargin{1})
            seas = varargin{1};
        else
            error('Invalid format for SEAS.')
        end
        
        if isfield(this,varargin{2}) || strcmp(varargin{2},'eggs')
            var = varargin{2};
        else
            error('Invalid format for VAR')
        end
        
    otherwise
        error('Wrong number of input arguments.')
end

% Get the spawning output for each year in each season.
spawns = cell(1,length(seas));
for i = 1:length(seas)
    [spawns{i},years] = get_spawns(this,seas{i},var);
end
spawns = cell2mat(spawns);

% Make the plot.
isheld = ishold; hold on;

%formatwindow(this, isheld, var);
bar(years, spawns);
for i = find(isnan(spawns))
    bar(years(i),1e8,'k')
end

if ~isheld, hold off; end

% Assign the output arguments, if any.
switch nargout
    case 0
    case 1
        varargout{1} = spawns;
    case 2
        varargout{1} = spawns;
        varargout{2} = years;
    otherwise
        error('Too many output argumens requested.')
end

end