function varargout = get_connection_fraction(this,bed,varargin)
%GET_CONNECTION_FRACTION returns the connection fraction for the track.
%  GET_CONNECTION_FRACTION computes the connection fraction from the bed
%  this.bed of the Track, to a specified bed.
%
%  GET_CONNECTION_FRACTION(TROBJ, BEDOBJ, PLD) computes the connection fraction
%  from the bed in TROBJ to the bed BEDOBJ, for the Track TROBJ. The settlement
%  time is given by PLD. This can be any of 'ind', 'const', number, vector.
%
%  Example:
%  >> get_connection_fraction(tr, gsc, 'ind');
%  returns the fraction of particles ending up in the GSC at the end of the
%  temperature-dependent pld with Q10 = 2.
%
%See also: Track, Larvae, get_larval_exchange

ipld = read_pld(this,varargin{:});
ind = sub2ind(size(this.x), (1:length(ipld))', ipld);
ind = ind(~isnan(ind));

if isa(bed,'Bed')
    n = sum(inpolygon(this.x(ind), this.y(ind), ...
        bed.border(1,:), bed.border(2,:)));
elseif isa(bed,'Domain')
    n = sum(~isnan(this.x(ind)));
end

cf = n/size(this.x,1);

switch nargout
    case {0,1}
        varargout{1} = cf;
    otherwise
        error('Too many output arguments requested.');
end

end