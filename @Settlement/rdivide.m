function this = rdivide(this, num)
%RDIVIDE overloads RDIVIDE for the Settlement class.
%  RDIVIDE divides the settlement field by a real number. This is useful for
%  making plots of larval density in millions or billions of larvae per km^2,
%  instead of units of larvae per km^2.

this.u = this.u/num;

end