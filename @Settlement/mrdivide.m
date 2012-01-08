function this = mrdivide(this, num)
%RDIVIDE overloads RDIVIDE for the Settlement class.
%  RDIVIDE divides the settlement field by a real number. This is useful for
%  making plots of larval density in millions or billions of larvae per km^2,
%  instead of units of larvae per km^2.

if isnumeric(num) && max(size(num)) == 1
    this.u = this.u/num;
elseif isa(num, 'Settlement')
    this.u = this.u./num.u;
else
    error('Can only do division by nubers in R^1.')
end

end