function varargout = get_subset(cts, varargin)
%GET_SUBSET extract a subset of a CTIMESERIES object's data.
%  GET_SUBSET subsamples a CTIMESERIES object and returns a new one containing
%  only the subsetof the old one.
%
%  NEWCTS = GET_SUBSET(OLDCTS, RULE1, ARG1, RULE2, ARG2, ...) where OLDCTS is 
%  the CTIMESERIES to be subsampled creates a new CTIMESERIES NEWCTS. The
%  arguments RULEx and ARGx are rules and corresponding arguments telling the
%  function how to subsample the data in OLDCTS.
%
%  Rules defined:
%    'years'  - look only at a subset of years.
%        arg: YEARS, a vector listing the years to be retained.
%    'months' - look only at data from within a certain month.
%        arg: MONTHS a vector o cell array listing the months to look at. These
%             can be numeric or text, ie {'jan' 'feb'} as long as they identify
%             the month unquely.
%
%  Example: 
%    cts2 = get_subset(cts1, 'years', 1984)
%    returns a monthly timeseries for only the year 1984.
%
%See also: ctimeseries/struct.m, ctimeseries/ctimeseries.m

for i = 1:2:(nargin-1)
    F = str2func(varargin{i});
    cts = feval(F, cts, varargin{i+1});
end

% assign the output arguments.
switch nargout
    case {0, 1}
        varargout{1} = cts;
    otherwise
        error('Too many output arguments.')
end

end

%*******************************************************************************
% Subsampling rules below. Each is described in the header comment.
%*******************************************************************************

% The subsample subfunction.
function cts = subsample(cts, ind)
cts.x = cts.x(ind);
cts.y = cts.y(ind);
cts.e = cts.e(ind);
end

% The years subfucntion.
function cts = years(cts, yrs) %#ok<DEFNU>
[y,~,~,~] = datevec(cts.x);
ind = ismember(y, yrs);
cts = subsample(cts, ind);
end
