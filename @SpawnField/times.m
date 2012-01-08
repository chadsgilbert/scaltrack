function k = times(n,k)
%TIMES overloads the TIMES function for the SpawnField class.
%
%  TIMES(N,K)
%
%  Example:
%  >> k1 = 100*k;
%  returns 100 times the origial field.
%
%See also: SpawnField

if isnumeric(n) && isa(k,'SpawnField')
    k.u = k.u.*n;
elseif isnumeric(k) && isa(n,'SpawnField')
    n.u = n.u.*k;
else
    error('I am in a hurry. Your function call failed.');
end


end