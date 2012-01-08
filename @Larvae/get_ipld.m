function ipld = get_ipld(this,varargin)
%GET_IPLD get the settlement index of each particle in the Larvae.
%  GET_IPLD estimates the settlement time of each particle in the Larvae by
%  applying a Q_{10} temperature-dependent growth model to the particle-tracking
%  time-series.
%
%  The units of PLD are days.
%
%  GET_PLD(TROBJ, Q10, T0, IPLD0) where TROBJ is the Larvae object, Q10 is the Q10
%  growth factor (typically 2), T0 is the default temperature (typically 13.7 C),
%  and PLD0 is the default PLD (typically 68 time-steps).
%
%  GET_PLD(TROBJ) automatically applies the default values to the missing
%  arguments.
%
%  Example:
%  >> tr = Larvae(...);
%  >> pld = get_pld(tr);
%  returns the PLD in days of every single particle in tr, as a column vector.
%
%See also: Larvae

% Assign the input arguments.
switch nargin
    case 1
        Q10  = 2;
        T0   = 13.7;
        PLD0 = 68;
    case 2
        Q10  = varargin{1};
        T0   = 13.7;
        PLD0 = 68;
    case 3
        Q10  = varargin{1};
        T0   = varargin{2};
        PLD0 = 68;
    case 4
        Q10  = varargin{1};
        T0   = varargin{2};
        PLD0 = varargin{3};
    otherwise
        error('Wrong number of input arguments.')
end

% Pre-allocate important vectors.
l_size = zeros(size(this.x(:,1)));
ipld = NaN(size(l_size));

% Find the settlement age of each larva.
for i = 1:(length(this.yd)-1)
    l_size = l_size + Q10.^((this.T(:,i)-T0)./10);
    ind = (l_size > PLD0) & (isnan(ipld));
    ipld(ind) = i;
end

end