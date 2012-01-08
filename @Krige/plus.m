function result = plus(krige1,krige2)
%PLUS overloads PLUS for the Krige class.
%  PLUS "adds" two Kriges together by summing their density vectors (u) together
%  (provided that the two kriges have the same domain (x,y).
%
%  K1 + K2 returns a new krige object.

if sum(krige1.x ~= krige2.x | krige1.y ~= krige2.y) > 0
    error('Can''t add kriges with different dimensions.')
end

if strcmpi(krige1.bed,krige1.bed)
    bed = krige1.bed;
else
    bed = [krige1.bed '+' krige2.bed];
end

if strcmpi(krige1.size_class,krige2.size_class)
    siz = krige1.size_class;
else
    siz = [krige1.size_class '+' krige2.size_class];
end

if strcmpi(krige1.era, krige2.era)
    era = krige1.era;
else
    era = [krige1.era '+' krige2.era];
end

result = Krige(krige1.x, krige1.y, krige1.u+krige2.u, bed, siz, era);

end