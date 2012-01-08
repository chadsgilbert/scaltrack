function k1 = mrdivide(k1,k2)
%MRDIVIDE overloads MRDIVIDE for the KRIGE class.
%  DIVIDES the density vector u by a factor

if isnumeric(k2)
    k1.u = k1.u/k2;
elseif isa(k2, 'SpawnField')
    k1.u = k1.u./k2.u;
end

end