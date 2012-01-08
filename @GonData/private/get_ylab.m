function lab = get_ylab(fld)
%GET_YLAB get the name for the ylabel.

flds = {'wgw' 'wmw' 'wspw' 'gsi'};

labs = {'Wet gonad weight' ...
    'Wet meat weight' ...
    'Wet somatic tissue weight' ...
    'Wet GSI'};

if ismember(fld, flds)
    lab = labs{ismember(flds,fld)};
else
    lab = [];
end

end

