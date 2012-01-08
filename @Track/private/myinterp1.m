function yi = myinterp1(x, y, xi)
%MYINTERP1 is a faster, more error-prone version of MATLAB's 'interp1' function.
%
%  YI = MYINTERP1(X, Y, XI) Performs several linear intepolations on different
%  functions in parallel using MATLAB vector commands for speed.
%   - X is a monotonicly increasing row vector,
%   - Y is a matrix, each row is a 1D f(X), each col i is a sample at X(i)
%   - XI is a row vector; the ith element is the point at which the ith function
%        y is interpolated.

% Author: Chad Gibert
% Date: March 23, 2010

k = zeros(size(xi));
for i = 1:length(x)
    j = (xi <= x(i));
    k = k + j;
end
t = (xi - x(k))./(x(k+1) - x(k));
lx = size(xi,2);
ind = sub2ind(size(y), 1:lx, k);
yi = (1-t).*y(ind) + t.*y(ind+lx);
