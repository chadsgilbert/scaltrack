function varargout = get_larval_distribution(varargin)
%GET_LARVAL_DISTRIBUTION compute the spatial distribution of larvae.
%  GET_PARTICLE_DISTRIBUTION makes a 2d histogram of larval density, for
%  plotting tracking results.
%
%  GET_LARVAL_DISTIRIBUTION(LARVAE, DOM, IPLD), where LARVAE MUST be a Larvae
%  object, DOM a Domain object, IPLD the settlement indices and MORT a string
%  defining which mortality model to use.
%
%  Example:
%  >> get_particle_distribution(track, domain, ipld)
%
%See also: Settlement, pcolor, Larvae, Track, get_larval_distribution

% Parse the input arguments.
switch nargin
    case 3
        larv = varargin{1};
        dom  = varargin{2};
        ipld = varargin{3};
    otherwise
        error('Wrong number of input arguments.')
end

% Eliminate guys who are outside of the domain.
ind = ~isnan(ipld); ipld = ipld(ind);
x = larv.x(ind,:); y = larv.y(ind,:); n = larv.n(ind,:);
ind = sub2ind(size(x), (1:length(ipld))', ipld);
x = x(ind); y = y(ind); n = n(ind);

xvec = [895000:1000:899000 dom.xvec];
yvec = dom.yvec;

% Get the particle density at each point in the domain.
pmat = hist2(x, y, xvec, dom.yvec);
pmat = smooth2d(pmat,3,1);
pmat = smooth2d(pmat,2,1);
pmat(pmat <= .1) = NaN;
pmat(:,1) = NaN;
pmat = pmat(:,6:end);

% Gather up particles that were too sparse to smooth for individual plotting.
ind = ~isnan(x) & ~isnan(y) | (x>90100);    % Look only at guys in the domain.
x = x(ind);
y = y(ind);
val = interp2(dom.xvec, dom.yvec, pmat, x, y);  % Find out
ind = isnan(val);
xs = x(ind);
ys = y(ind);

% Run through all the non-NaN points and sum up the number of larvae in each.
[X,Y] = meshgrid(xvec,yvec);
for i = find(~isnan(pmat))'
    ind = ( (abs(x-X(i)) <= 500) & (abs(y-Y(i)) <= 500) );
    pmat(i) = sum(n(ind));
end

% Smooth the result out a bit so that it doesn't look totally stupid.
pmat = smooth2d(pmat,3,1);  % Smooth once, window size of three.
pmat = smooth2d(pmat,2,1);  % Smooth again, window size: 2.

% Assign the output arguments.
switch nargout
    case {0,1}
        varargout{1} = pmat;
    case 3
        varargout{1} = pmat;
        varargout{2} = xs;
        varargout{3} = ys;
    otherwise
        error('Wrong number of output arguments.')
end

end