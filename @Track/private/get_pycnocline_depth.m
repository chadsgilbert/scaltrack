function z_pycno = get_pycnocline_depth(x, y, d, rho, dom, varargin)
%GET_PYCNOCLINE_DEPTH returns the pycnocline depth at each particle position.
%  GET_PYCNOCLINE_DEPTH estimates the pycnocline depth based on the 3D density
%  field \rho(x, y, z) and a density threshold. See Thompson and Fine, 2003.
%  Gilbert et al., 2010 use THRESHOLD=0.8 kg/m^3.
%
%  Where the densty threshold is not reached within the upper 40 meters of the
%  water-column, a NaN is returned, indicating that the water is well-mixed (see
%  Gilbert et al., 2010).
%
%  GET_PYCNOCLINE_DEPTH(X, Y, D, RHO, DOM, THRESHOLD) where X, Y are the (x,y)
%  positions, RHO is the density field, DOM is the domain, and THRESHOLD is the
%  density threshsold.
%
%  Example:
%  >> z_pycno = get_pycnocline_depth(x, y, d, rho, dom)
%  computes the pycnocline depth at every position in (x, y).
%
%See also: get_initial_depths, track_pavi, track_pyvi, Track

% Check the input arguments.
switch nargin
    case 5
        THRES = 0.8;
    case 6
        THRES = varargin{1};
    otherwise
        error('Wrong number of input args passed to get_pycnocline_depth.m');
end

% Numerical parameters to be used in algorithm.
N = size(x,1);          % Remember the number, N, of particles being handled.
p = size(dom.pvec,1);   % Remember the number, p, of sigma levels.
kk = zeros(N,1);        % Pre-allocate 'kk' that it will be the right size.

% Reference values for use in the algorithm.
pvecs = repmat(dom.pvec',N,1);  % [N,p] matrix repeating pvec.
r0 = interp3(dom.xvec, dom.yvec, dom.pvec, rho, x, y, pvecs(:,1));
% r0 is the reference density.

% The algorithm.
% Find the sigma level (in pvecs) that's just below a drho of THRES kg/m^3 at
% each particle position in (x,y).
for i = 2:p
    r = interp3(dom.xvec, dom.yvec, dom.pvec, rho, x, y, pvecs(:,i));
    jj = ((r - r0) <= THRES);   % List all points still above the pycnocline.
    kk = jj + kk;               % Add them to kk to get the index.
end

% Clean out the NaNs and identify the well-mixed regions.
ii = isnan(kk) | (kk==0) | (kk==32);    % List the well-mixed regions.
kk(ii) = 1;                             % Convert to safe kks.
jj = sub2ind(size(pvecs), (1:N)', kk);  % Get indices of pycnoclines.
z_pycno = pvecs(jj).*d;                 % Get the pycno depth of each particle.
z_pycno(ii) = NaN;                      % Designate well-mixed regions w/ NaN.
z_pycno( z_pycno < -40 ) = NaN;         % Any pycno deeper than 40m is also NaN.

end