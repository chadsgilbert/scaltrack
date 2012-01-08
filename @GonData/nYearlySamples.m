function nsamples = nYearlySamples(this, varargin)
%NYEARLYSAMPLES the number of samples in each year.
%  NYEARLYSAMPLES returns a vector with each element listing the number of
%  samples that were taken in each year.
%
%  NYEARLYSAMPLES(THIS) computes the vector for all years having more than 0
%  records.
%
%  NYEARLYSAMPLES(THIS, YEARS) computes the vector for only those years listed
%  in the vector YEARS.

switch nargin
    case 1
        years = min(this.year):max(this.year);
    case 2
        years = varargin{1};
    otherwise
        error('Wrong number of input arguments.');
end

nsamples = NaN(size(years));
for i = 1:length(years)
    nsamples(i) = sum(this.year == years(i));
end

end