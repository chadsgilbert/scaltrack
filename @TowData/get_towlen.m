function len = get_towlen(varargin)
%GET_TOWLEN returns the tow length associated with each tow.
%  GET_TOWLEN knows the length associated with both the DFO and NOAA tows. This
%  length is used to standardize for tow length when scallop density is being
%  estimated. The tow "length" given is truly an area, given in km^2.
%
%  LEN = GET_TOWLEN(THIS) where THIS is a TowData object.
%
%  LEN = GET_TOWLEN(ORG) where ORG is a cell array of the name of the
%  organization for each data sample.
%
%  Example:
%    get_towlen('dfo')
%    returns 1911.16.
%
%See also: 

lens = [this.towlen_noaa this.towlen_dfo];

len = NaN(size(varargin{1}.org));
for i = 1:length(this.orgs)
    ind = strcmp(varargin{1}.org,this.orgs{i});
    len(ind) = lens(i);
end

end

