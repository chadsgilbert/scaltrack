function sum = plus(this,arg)
%PLUS overloads + for the Larvae class.
%  PLUS combines the cohorts on each particle in two Larvae objects. Note that
%  this requires two identical Tracks underlying each Larvae -- if each Larvae
%  has particles at different positions, adding up the larvae in each doesn't
%  make any sense. In addition to adding the numbers LARV1.n and LARV2.n, the
%  addition is recorded in other fields. For example, if a different mortality
%  scheme was used for the two different objects, the mortality field in the
%  result will list both schemes. Eg. New.mortality = 'LARV1.mortality +
%  LARV.mortality'.
%
%  SUM = LARV1 + LARV2

if isa(arg, 'Larvae')

    % Check if the two objects are compatible;
    iscompatible = (this.rw == arg.rw) && ...
        (this.behaviour == arg.behaviour) && ...
        (this.season == arg.season) && ...
        (this.bed == arg.bed);
    if ~iscompatible
        error('The two operands are not compaible for this operaiton.');
    end
    
    % 
    sum = this;
    sum.n = this.n + arg.n;
    sum.mortality = [this.mortality ' + ' arg.mortality];
else
    error('Invalid operand for adding with class ''Larvae''');
end

end
