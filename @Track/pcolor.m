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
%See also: pcolor, Track, Settlement, scatter

opts.ipld = 'ind';
opts.scale = 1;
for i = 1:2:(nargin-3)
    opts.(varargin{i}) = varargin{i+1};
end

s = Settlement(this,dom,opts.ipld);
[h,sc] = pcolor(s,'scale',opts.scale);

switch nargout
    case {0,1}
        varargout{1} = s;
    case 2
        varargout{1} = s;
        varargout{2} = h;
    case 3
        varargout{1} = s;
        varargout{2} = h;
        varargout{3} = sc;
    otherwise
       error('Wrong number of output arguments.')
end


end