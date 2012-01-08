function varargout = get_particle_distribution(track,dom,ipld)
%GET_PARTICLE_DISTRIBUTION compute the spatial distribution of particles.
%  GET_PARTICLE_DISTRIBUTION makes a 2d histogram of particle density, for
%  plotting track results.
%
%  GET_PARTICLE_DISTIRIBUTION(TRACK, DOM, IPLD), where TRACK MUST be a Track
%  object, DOM a Domain object and IPLD the settlement indices.
%
%  Example:
%  >> get_particle_distribution(track, domain, ipld)
%
%See also: Settlement, get_larval_distrbiution

% Eliminate guys who are outside of the domain.
ind = ~isnan(ipld); ipld = ipld(ind);
x = track.x(ind,:); y = track.y(ind,:);
ind = sub2ind(size(x), (1:length(ipld))', ipld);
x = x(ind); y = y(ind);

xvec = [895000:1000:899000 dom.xvec];

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