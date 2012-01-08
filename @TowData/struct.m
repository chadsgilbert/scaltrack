function td = struct(this)
%STRUCT overloads the function STRUCT for the TowData class.

td.year  = this.year;
td.lon   = this.lon;
td.lat   = this.lat;
td.depth = this.dpth;
td.sizef = this.sizef;
td.hvec  = this.hvec;
td.org   = this.org;
if ~isempty(this.x)
    td.x = this.x;
    td.y = this.y;
    td.u = this.u;
end

end