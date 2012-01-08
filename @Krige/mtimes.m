function result = mtimes(varargin)
%TIMES overloads TIMES for the KRIGE class.
%  Multplies the density vector u by a factor

if isa(varargin{1},'Krige')
    k = varargin{1};
    f = varargin{2};
    result = Krige(k.x, k.y, k.u*f, k.bed, k.size_class, k.era);
else
    k = varargin{2};
    f = varargin{1};
    result = Krige(k.x, k.y, f*k.u, k.bed, k.size_class, k.era);
end

end