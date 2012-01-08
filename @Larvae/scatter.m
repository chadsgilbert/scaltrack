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

ipld = [];
args = {'filled'};
for i = 1:2:(nargin-1)
    switch varargin{i}
        case 'format'
            args = varargin{i+1};
        case 'ipld'
            ipld = varargin{i+1};
        otherwise
            warning('CHADOOP:Track:scatterArgs', ...
                'Invalid optional argument supplied.');
    end
end

if isempty(ipld), ipld = get_ipld(this); end
size(ipld)
ind = sub2ind(size(this.x), (1:length(ipld))', ipld);
ind = ind(~isnan(ind));

h = scatter(this.x(ind), this.y(ind), args{:});

switch nargout
    case 0
    case 1
        varargout{1} = h;
    otherwise
        error('Too many output arguments reuqested.')
end

end