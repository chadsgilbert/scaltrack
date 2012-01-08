function ct = struct(this)
%STRUCT overloads the function STRUCT for ctimeseries.
%  STRUCT converts a CTIMESERIES to a struct with the same fields. This is
%  mostly intended for internal use within the CTIMESERIES class where MATLAB
%  seems to want to prevent the class constructor from applying 

props = properties(ctimeseries);

for i = 1:length(props)
    ct.(props{i}) = this.(props{i});
end

end