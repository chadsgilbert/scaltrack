function A = area(this,varargin)
%AREA compute the area of a bed.
%  AREA computes and returns the total area of a bed.
%
%  AREA(BED) returns the area of BED in units of km^2.
%
%  AREA(BED, UNITS) returns the area in the prescribed units. Only 'km^2' and 
%  'm^2' are defined currently.
%
%  Example:
%   >> load nep;
%   >> area(nep)
%   returns the area in km^2 of the NEP.
%
%See also: Bed

switch nargin
    case 1
        units = 'km^2';
    case 2
        units = varargin{2};
    otherwise
        error('Wrong number of input arguments.');
end

switch units(1)
    case {'km', 'km^2'}
        A = length(this.x0)*16;
    case {'m', 'm^2'}
        A = length(this.x0)*16000;
    otherwise
        error('Invalid units specified.');
end

end