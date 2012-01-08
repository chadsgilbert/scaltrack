function varargout = scatter(this,varargin)
%SCATTER overloads SCATTER for the Track class.
%
%  SCATTER(TROBJ)
%
%  SCATTER(TROBJ, OPT, VAL)
%
%  Options:
%    - 'ipld' provide the ipld in VAL.
%    - 'format' provide the plotting format args in a cell array.
%
%  Example:
%  >> scatter(tr, 'ipld', 68, 'format', {'rs', 'filled'})
%  plots the guys are filled red squared after 68 time-steps.
%
%See also: Track, pcolor, Settlement

opts.ipld = 'pld';
opts.format = {'filled'};
for i = 1:2:(nargin-2)
    opts.(varargin{i}) = varargin{i+1};
end

if strcmp(opts.ipld,'pld'), opts.ipld = get_ipld(this); end
ind = sub2ind(size(this.x), (1:length(opts.ipld))', opts.ipld);
ind = ind(~isnan(ind));

h = scatter(this.x(ind), this.y(ind), opts.format{:});

switch nargout
    case 0
    case 1
        varargout{1} = h;
    otherwise
        error('Too many output arguments reuqested.')
end

end