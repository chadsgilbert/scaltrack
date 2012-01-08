function varargout = pcolor(this,dom,varargin)
%PCOLOR overloads PCOLOR for the Track class.
%  PCOLOR makes a Settlement object and uses it to plot a density field for the
%  settlement distribution of larvae at the end of the Track simulation.
%
%  PCOLOR(TROBJ, DOMOBJ, IPLD) takes the Track object, TROBJ, the Domain object,
%  DOMOBJ and the settlement index IPLD (either a number or a vector) and makes
%  the plot.
%
%  PCOLOR(TROBJ, DOMOBJ, PLD) takes the Track and Domain, as above and a string
%  argument PLD, for either 'ind', or 'const'.
%
%  PCOLOR(TROBJ, DOMOBJ, 'ind', Q10, T0, PLD0) as above, but allows the extra
%  arguments Q10, T0 and PLD0 to specify non-standard values.
%
%  Example:
%  >> pcolor(tr, dom)
%  makes a pcolor plot of settlement distribution.
%
%See also: Track, Settlement, scatter

s = Settlement(this,dom,varargin{:});
h = pcolor(s);

switch nargout
    case {0,1}
        varargout{1} = s;
    case 2
        varargout{1} = s;
        varargout{2} = h;
    otherwise
       error('Wrong number of output arguments.')
end


end