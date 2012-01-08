function varargout = get_yunit(fld)
%GET_YUNIT return the measurement units of the data field.
%
%  GET_YUNIT(FLD) where FLD is a string listing one of the properties of a
%  GonData oject.
%
%  Example:
%    get_yunit('wgw')
%    returns the string: '(g)', the units that WGW was measured in.
%
%See also: GonData/private/get_ylab.m

switch fld
    case 'year'
        varargout{1} = 'AD';
    case 'month'
        varargout{1} = 'Julian month';
    case 'day'
        varargout{1} = 'Julian day';
    case 'lat'
        varargout{1} = 'decimal degrees';
    case 'lon'
        varargout{1} = 'decimal degrees';
    case 'height'
        varargout{1} = '(mm)';
    case 'dpth'
        varargout{1} = '(m)';
    case 'wgw'
        varargout{1} = '(g)';
    case 'wmw'
        varargout{1} = '(g)';
    case 'wspw'
        varargout{1} = '(g)';
    case 'sex'
        varargout{1} = '(Male or Female)';
    case 'yd'
        varargout{1} = 'days since year 0';
    case 'x'
        varargout{1} = '(m)';
    case 'y'
        varargout{1} = '(m)';
    case 'age'
        varargout{1} = '(years)';
    case 'gsi'
        varargout{1} = '(%)';
    otherwise
        error('Invalid field name given.')
end

end