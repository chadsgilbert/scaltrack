function this = mrdivide(this,arg)
%MINUS overloads - for the Larvae class.
%  MINUS compares the cohorts on each particle in two Larvae objects. Note that
%  this requires two identical Tracks underlying each Larvae -- if each Larvae
%  has particles at different positions, adding up the larvae in each doesn't
%  make any sense. In addition to adding the numbers LARV1.n and LARV2.n, the
%  addition is recorded in other fields. For example, if a different mortality
%  scheme was used for the two different objects, the mortality field in the
%  result will list both schemes. Eg. New.mortality = 'LARV1.mortality -
%  LARV.mortality'.
%
%  DIFF = LARV1 - LARV2

if isa(arg, 'Larvae')
    % Divide by the argument.
    this.n = this.n ./ arg.n;
    this.mortality = [this.mortality ' / ' arg.mortality];
elseif isnumeric(arg)
    this.n = this.n/arg;
else
    error('Invalid operand for dividing with class ''Larvae''');
end

end