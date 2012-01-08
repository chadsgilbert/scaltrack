function result = mrdivide(k1,k2)
%MRDIVIDE overloads MRDIVIDE for the KRIGE class.
%  MRDIVIDE divides the density vector u by either a factor, or by the density
%  vector of another krige (provided they have the same size). 
%
%  Example:
%  >> k = K1/5;
%  returns a krige where the reported density of scallops is 1/5th of the
%  original.
%
%  >> k = K1/K2;
%  returns a new field, where each point in the domain reports the ratio of
%  scallop densities K1/K2 at that point.
%
%See also: mrdivide, Krige

switch [class(k1) class(k2)]
    case 'KrigeKrige'
        result = Krige(k1.x, k1.y, k1.u./k2.u, k1.bed, k1.size_class, k1.era);
    case 'Krigedouble'
        result = Krige(k1.x, k1.y, k1.u./k2, k1.bed, k1.size_class, k1.era);
    otherwise
        error('Invalid argument pair.');
end

end