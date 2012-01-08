function this = vertcat(varargin)

this = varargin{1};
for i = 2:nargin
    tr = varargin{2};
    this.x = [this.x; tr.x];
    this.y = [this.y; tr.y];
    this.z = [this.z; tr.z];
    this.d = [this.d; tr.d];
    this.p = [this.p; tr.p];
    this.T = [this.T; tr.T];
end

this.rw = cell2mat(intersect({this.rw},{tr.rw}));
this.behaviour = cell2mat(intersect({this.behaviour},{tr.behaviour}));
this.bed = cell2mat(intersect({this.bed},{tr.bed}));
this.season = cell2mat(intersect({this.season},{tr.season}));