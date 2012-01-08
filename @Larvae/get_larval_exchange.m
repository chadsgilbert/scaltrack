function varargout = get_larval_exchange(this,bed,varargin)
%GET_LARVAL_EXCHANGE returns the connection fraction for the track.
%  GET_LARVAL_EXCHANGE computes the connection fraction from the bed
%  this.bed of the Track, to a specified bed.
%
%  GET_LARVAL_EXCHANGE(LOBJ, BEDOBJ, PLD) computes the connection fraction
%  from the bed in TROBJ to the bed BEDOBJ, for the Track TROBJ. The settlement
%  time is given by PLD. This can be any of 'ind', 'const', number, vector.
%
%  Example:
%    >> get_larval_exchange(larvae_fal, gsc, 'ind');
%  returns the number of larvae in the Larvae object that settled in the GSC.
%
%See also: Larvae, Track, pcolor, scatter, get_pld, get_ipld

ipld = read_pld(this,varargin{:});

if size(ipld,1) == 1 && size(ipld,2) == 1
    % Easy case: ipld is the same for all particles.
    
    % Find and count those that are in the bed.
    i = inpolygon(this.x(:,ipld), this.y(:,ipld), ...
        bed.border(1,:), bed.border(2,:));
    n = sum(this.n(i,ipld));

else
    % Hard case: ipld is individually-varying.
    
    % Eliminate out-of-bounds larvae.
    ind = ~isnan(ipld);
    ipld = ipld(ind);
    x = this.x(ind,:);
    y = this.y(ind,:);
    n = this.n(ind,:);
    
    % Find the settlement index for those that are left.
    ind = sub2ind(size(x), (1:length(ipld))', ipld);
    
    % Find and count those that are in the bed.
    i = inpolygon(x(ind), y(ind), bed.border(1,:), bed.border(2,:));
    n = sum(n(ind(i)));
end

% Return the result.
varargout{1} = n;

end