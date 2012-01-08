function gondata = struct(this)
%STRUCT overloads STRUCT for gondata.
%
%  STRUCT converts a GonData object int a struct with the same data in it.
%
%  GD = STRUCT(THIS) where THIS is a GonData object and GD is a struct with the
%  same fields.
%
%  Example
%    gd = struct(GonData)
%    returns an empty struct with the same fields as a GonData object.
%
%See also: disp, plot, subsref

gondata.year    = this.year;
gondata.month   = this.month;
gondata.day     = this.day;
gondata.lat     = this.lat;
gondata.lon     = this.lon;
gondata.dpth    = this.dpth;
gondata.height  = this.height;
gondata.wgw     = this.wgw;
gondata.wmw     = this.wmw;
gondata.wspw    = this.wspw;

gondata.sex     = 2 - strcmp(this.sex,'m');

end