classdef ctimeseries
%CTIMESERIES a timeseries object with sample variability reported.
%
%  CTIMESERIES records the time and allows plotting and such of a timeseries
%  with uncertain data points.
%
%  CTIMESERIES() makes an empty timeseries object.
%
%  CTIMESERIES(C, OPT1, RULE1, OPT2, RULE2, ...) copy/subsample constructor.
%  Takes an existing CTIMESERIES object C and subsamples it using the list of
%  (rule, option) pairs provided. The subsampling rules and their corresponding
%  arguments are listed below:
%    'years' - Finds only the samples from the listed years.
%        arg - YEARS a vector containing the years to be kept.
%
%  CTIMESERIES(X,Y,E) makes a timeseries, where X is the 'time' vector, Y is the
%  'mean' vector and E is the 'error' vector, which, for now, assumes the error
%  is symmetric.
%
%  CTIMESERIES(X,Y,E,Xax,Yax,NAME,Xunit,Yunit) makes a useful timeseries. Xax
%  and Yax are the names of the variables that X and Y represent. NAME is the
%  name for the timeseries. It can e empty []. Xunit and Yunit are the units
%  (also strings) of the X and Y axes.
%
%  CTIMESERIES(X,Y,E,Xax,Yax,NAME,Xunit,Yunit,RANGE) where RANGE is a 2 element
%  vector declaring the lowest and highest y values to be plotted. That is, it
%  tells the timeseries what the axes should look like. The x axes always look
%  the same: they extend one month beyond the last data point in either temporal
%  direction.

% The list of properties.
properties (SetAccess = private)
    % The actual data.
    x = [];
    y = [];
    e = [];
    
    % The names of the x and y axes, and the name of the series.
    xax = [];
    yax = [];
    name = []; 
    
    % The names of the x and y units.
    xunits = [];
    yunits = []; 
    
    % The upper and lower y limits.
    range = [];
end

% The constructor method.
methods
    function this = ctimeseries(varargin)
        if nargin == 0
            % Empty constructor.
            
        elseif ismember(nargin, 3:9) && isnumeric(varargin{1})
            % Construct by taking in arguments.
            props = properties(ctimeseries);
            for i = 1:nargin
                this.(props{i}) = varargin{i};
            end
            
        elseif (mod(nargin,2) == 1) && isstruct(varargin{1})
            % Construct the object (or a subsample) from an anonymous struct.
            cstruct = get_subset(varargin);
            flds = intersect(fieldnames(cstruct), properties(ctimeseries));
            for i = 1:length(flds)
                this.(flds{i}) = varargin{1}.(flds{i});
            end
            
        elseif (mod(nargin,2) == 1) && strcmp(class(varargin{1}),'ctimeseries')
            % Copy/subsample constructor.
            cstruct = struct(varargin{1});
            cstruct = get_subset(cstruct, varargin{2:end});
            flds = fieldnames(cstruct);
            for i = 1:length(flds)
                this.(flds{i}) = cstruct.(flds{i});
            end
            
        else
            error('Bad call to ctimeseries constructor.')
        end
    end
end

end
    