function varargout = isconsistent(dom)
%FORMATCHECK determines if a Domain object's fields are self-consistent.
%  FORMATCHECK returns 0/false if the format is invalid and 1/true if it is 
%  valid.
%
%  ISVALID = FORMATCHECK(DOM)
%
%  Example:
%  >> load xydom.mat
%  >> dom = Domain(xydom)
%  >> isvalid = formatcheck(dom)
%  will return true (if xydom is on the path and is correct).
%
%See also: Domain

isvalid = true;
badfield = {};

% Check if the xvec is a monotonically increasing [1xN] vector.
isVector = (size(dom.xvec,1) == 1);
isMonotonic =  (sum(diff(dom.xvec) < 0) == 0);
if ~(isVector && isMonotonic)
    badfield = [badfield {'xvec'}];
    isvalid = false;
end

% Check if the yvec is a monotonically increasing vector.
isVector = (size(dom.yvec,2) == 1);
isMonotonic = (sum(diff(dom.yvec) < 0) == 0);
if  ~(isVector && isMonotonic)
    badfield = [badfield {'yvec'}];
    isvalid = false;
end

% Check if the svec is a monotonically decreasing vector in range.
isVector = (size(dom.svec,2) == 1);
isMonotonic = (sum(diff(dom.svec) > 0) == 0);
isInRange = (sum(dom.svec < -1 | dom.svec > 0) == 0);
if  ~(isVector && isMonotonic && isInRange)
    badfield = [badfield {'svec'}];
    isvalid = false;
end

% Check if the pvec is a monotonically descrasing vector in range.
isVector = (size(dom.pvec,2) == 1);
isMonotonic = (sum(diff(dom.pvec) > 0) == 0);
isInRange = (sum(dom.pvec < -1 | dom.pvec > 0) == 0);
if  ~(isVector && isMonotonic && isInRange)
    badfield = [badfield {'pvec'}];
    isvalid = false;
end

% Check if the dpth matrix is MxN.
n = size(dom.xvec,2);
m = size(dom.yvec,1);
if ~(size(dom.dpth,1) == m && size(dom.dpth,2) == n)
    badfield = [badfield {'dpth'}];
    isvalid = false;
end

% Check if the land cell array is ... actually a cell array of polygons.
if iscell(dom.land)
    for i = 1:length(dom.land)
        if size(dom.land{i},1)~=2
            badfield = [badfield {'land'}];%#ok
            break;
        end
    end
else
    badfield = [badfield {'land'}];
end

% Pass the result back.
switch nargout
    case {0 1}
        varargout{1} = isvalid;
    case 2
        varargout{1} = isvalid;
        varargout{2} = badfield;
    otherwise
        error('Too many output args requested.')
end

end