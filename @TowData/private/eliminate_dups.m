function varargout = eliminate_dups(td)
%ELIMINATE_DUPS eliminates duplicate records in a towdata struct.
%  ELIMINATE_RECORDS uses the year, lon and lat fields to identify any duplicate
%  records contained in the struct. This may arise if NOAA and DFO both reported
%  the same record.

k = 0;
i = 1;
while i < length(td.year)
    % Look for copies of the records.
    ind = (td.year == td.year(i)) ...
        & (td.lon(i) == td.lon) ...
        & (td.lat(i) == td.lat);
    if length(ind) > 1
        % Eliminate all the copies, but keep the original.
        ind(i) = false;
        td = eliminate(td,~ind);
        k = k + length(ind) - 1;
    end
    i = i + 1;
end

switch nargout
    case {0,1}
        varargout{1} = td;
    case 2
        varargout{1} = td;
        varargout{2} = k;
    otherwise
        error('Too many output arguments requested.')
end

end

function subsample = eliminate(td,ind)

subsample.year   = td.year(ind);
subsample.lat    = td.lat(ind);
subsample.lon    = td.lon(ind);
subsample.depth  = td.depth(ind);
subsample.sizef  = td.sizef(ind,:);
subsample.x      = td.x(ind);
subsample.y      = td.y(ind);
subsample.hvec   = td.hvec;
subsample.u      = td.u(ind);
subsample.org    = td.org(ind);

end