function result = minus(krige1,krige2)
%MINUS overloads MINUS for the Krige class.
%  MINUS "subtracts" two Kriges together by subtracting the density vectors (u) 
%  of one krige from another (provided that the two kriges have the same domain
%  (x,y).
%
%  Example:
%  >> k = K1 - K2;
%  returns a new krige object.
%
%See also: minus, Krige

% Check for dimension mismatch.
if sum(krige1.x ~= krige2.x | krige1.y ~= krige2.y) > 0
    error('Can''t add or subtract kriges having different dimensions.');
end

% If the beds have different names, keep the names of both.
if strcmpi(krige1.bed,krige1.bed)
    bed = krige1.bed;
else
    bed = [krige1.bed '+' krige2.bed];
end

% If the size-classes are different, keep the names of both.
if strcmpi(krige1.size_class,krige2.size_class)
    siz = krige1.size_class;
else
    siz = [krige1.size_class '+' krige2.size_class];
end

% If the eras are different, keep the names of both.
if strcmpi(krige1.era, krige2.era)
    era = krige1.era;
else
    era = [krige1.era '+' krige2.era];
end

% Return the result.
result = Krige(krige1.x, krige1.y, krige1.u-krige2.u, bed, siz, era);

end