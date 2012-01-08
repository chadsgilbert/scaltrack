function varargout = get_yrange(this, fld)
%GET_YRANGE return the axes range for the y-value.
%  GET_YRANGE is useful for getting a suitable range when setting the axes in
%  plots of GonData. These ranges were carefully selected so as to make plots of
%  data in different years consistent with each-other, while simultaneously 
%  optimizing use of screen real-estate.
%
%  GET_YRANGE(FLD) where FLD is a string listing one of the properties of a
%  GonData oject, returns an appropriate range for plotting in a 1x2 matrix.
%
%  Example:
%    get_yunit('wgw')
%    returns a 1x2 matrix: [0 40]. The actual value returned may depend on the
%    specific data contained in the object, or may be universal to all GonData
%    objects.
%
%See also: GonData/private/get_ylab.m, GonData/private/get_yunit.m

switch fld
    case 'year'
        varargout{1} = [1984 2004];
    case 'month'
        varargout{1} = [1 12];
    case 'day'
        varargout{1} = [0 31];
    case 'lat'
        varargout{1} = [38 42.5];
    case 'lon'
        varargout{1} = [-72 -67];
    case 'height'
        varargout{1} = [0 200];
    case 'dpth'
        varargout{1} = [0 120];
    case 'wgw'
        if max(this.height) <= 95
            varargout{1} = [0 20];
        elseif max(this.height) <= 120
            varargout{1} = [0 40];
        else
            varargout{1} = [0 70];
        end
    case 'wmw'
        if max(this.height) <= 95
            varargout{1} = [0 40];
        elseif max(this.height) <= 120
            varargout{1} = [0 80];
        else
            varargout{1} = [0 140];
        end
    case 'wspw'
        if max(this.height) <= 95
            varargout{1} = [0 30];
        elseif max(this.height) <= 120
            varargout{1} = [0 45];
        else
            varargout{1} = [0 80];
        end
    case 'sex'
        varargout{1} = [-0.5 1.5];
    case 'yd'
        varargout{1} = [724642 732312];
    case 'x'
        varargout{1} = [0.9e6 1.3e6];
    case 'y'
        varargout{1} = [-0.32e6 -0.05e6];
    case 'age'
        varargout{1} = [0 12];
    case 'gsi'
        varargout{1} = [0 70];
    case 'eggs'
        varargout{1} = [0 1e8];
    otherwise
        error('Invalid field name given.')
end

end