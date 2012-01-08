function ind = in_bed(this,x,y)
%IN_BED identify which (x,y) pairs are in a bed.
%  IN_BED returns a logical array with 1/true being 'yes, x,y is in the bed' and
%  0/false being 'no, it is not in the bed'.
%
%  IN_BED(BEDOBJ, X, Y)
%
%  Example:
%    >> ind = in_bed(nep, x, y);
%    >> scatter(x(ind), y(ind));
%  plots only those (x,y) pairs that are in the NEP.
%
%See also: Bed, Track

ind = inpolygon(x, y, this.border(1,:), this.border(2,:));
for i = 1:length(this.gap)
    ind = ~inpolygon(x, y, this.gap{i}(1,:), this.gap{i}(2,:)) & ind;
end

end