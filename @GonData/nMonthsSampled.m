function n = nMonthsSampled(this, varargin)
%NMONTHSSAMPLED the number of months in each year which were sampled.
%  NMONTHSSAMPLED
%
%  NMONTHSSAMPLED(THIS)
%
%  NMONTHSSAMPLED(THIS, SEAS)
%
%  NMONTHSSAMPLED(THIS, MONTHS)

switch nargin
    case 1
        seas = 1:12;
    case 2
        if ischar(varargin{1})
            if strncmpi(varargin{1},'f',1)
                seas = 7:11;
            elseif strncmpi(varargin{1},'s', 1)
                seas = 2:6;
            else
                error('Invalid season speficifed.')
            end
        elseif isnumeric(varargin{1})
            seas = varargin{1};
            if sum(seas < 1 | seas > 12) > 0
                error('Months must be between 1 and 12.')
            end
        else
            error('Invalid season specified')
        end
    otherwise
        error('Wrong number of input arguments.');
end

years = min(this.year):max(this.year);
n = NaN(size(years));

for i = 1:length(years)
    ind = years(i) == this.year;
    n(i) = sum(ismember(seas, this.month(ind)));
end

end