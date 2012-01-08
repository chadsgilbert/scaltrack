function k1 = plus(k1,k2)
%PLUS overloads PLUS for the SpawnField class.
%
%  PLUS(K1, K2)
%
%  Example:
%  >> K = K1 + K2;
%  returns the su f the two fields.
%
%See also SpawnField

if isa(k1,'SpawnField') && isa(k2,'SpawnField')
    k1.u = k1.u + k2.u;
else
    error('Wrong guys for the job.');
end

end