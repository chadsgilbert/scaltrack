function pld = get_pld(varargin)
%GET_PLD get the settlement time of each particle in the Track.
%  GET_PLD estimates the settlement time of each particle in the Track by
%  applying a Q_{10} temperature-dependent growth model to the particle-tracking
%  time-series.
%
%  The units of PLD are days.
%
%  GET_PLD(TROBJ, Q10, T0, PLD0) where TROBJ is the Track object, Q10 is the Q10
%  growt factor (typically 2), T0 is the default temperature (typically 13.7 C),
%  and PLD0 is the default PLD (typically 35 d).
%
%  GET_PLD(TROBJ) automatically applies the default values to the missing
%  arguments.
%
%  Example:
%  >> tr = Track(...);
%  >> pld = get_pld(tr);
%  returns the PLD in days of every single particle in tr, as a column vector.
%
%See also: Track, get_ipld

% Assign the input arguments.
if nargin == 4
    varargin{4} = round(varargin{4}*24/12.42);
end

% Get the pld.
pld = 12.42/24*get_ipld(varargin{:});

end